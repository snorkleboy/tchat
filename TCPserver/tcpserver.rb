#!/usr/bin/env ruby

require 'socket'
require 'thread'
require_relative "../util/sister_server"
require_relative "../util/rooms"
require 'json'
require_relative "../util/dbServerApi"
require_relative "../util/redisAPI"
require_relative "./clientController"
require_relative "./authenticationSequence"
include Socket::Constants



# this Users object must have a client.send, room, and name to work with the Rooms data structure and to synchronize properly with other servers
# should have a json of name and room
User = Struct.new(:client, :name,:room, :address) do 
    def to_json(options)
        {'name'=>name,'room'=>room}.to_json
    end
end


class Server 
    def initialize(port, host, name = 'TCPserverHOST')
        # rooms is a wrapper for a hash of key:roomname=>value:[array of users]
        # it has all the synchronization logic of adding/removing users inside.
        # pushing a user in or chagning a users room results in it automatically message to synchronize with other servers
        @rooms = Rooms.new(Proc.new{sendUserList()})

        # start main socket
        @socket = Socket.new(AF_INET, SOCK_STREAM, 0)
        sockaddress = Socket.pack_sockaddr_in(port,host)
        @socket.bind(sockaddress)

        # redis setup

        @redisAPI = RedisApi.new(self)

        # starts sister server for connecting to other servers for messenging
        # starts with a proc it uses to respond to messages anda reference to this server
        @sisterServer = SisterServer.new(9009,'localhost',self)
        messageallProc = Proc.new{|msg| write_room("#{msg['handle']}: #{msg['text']}",nil,msg['room'])}
        @sisterServer.start(messageallProc)

        p "socket bound on #{host} #{port}"
        start()
    end

    # start starts up the socket to accept connections, 
    # puts each conection into a new thread where a authentication process ('handshake') is done
    # upon authentication it starts reading and writing to the socket
    def start
        @socket.listen(5)
        Thread.current[:name]='Main Listener'
        p 'listening' 
        start_console()
        p 'console running'
        # on connection put new socket into new thread
        # thread does 'handshake' which gets username and password from TCP cleint
        # If handshake returns a user object it reads and broadcasts messages from it, otherwise it closes the connection in handhsake and then kills the thread.
        while(true) do
            thr = Thread.start(@socket.accept) do |connection| 
                user = nil
                p '',"server accepted :#{connection}"
                begin
                    # hand shake looks at request, if its HTTP is sends response and returns false after closing the connection,
                    # if its not HTTP it welcomes to TCPChat and asks for a user name, then returns a userStruct(@socket,name)
                    user = handshake(connection)   
                rescue => exception
                    p '',"handshake rescue: #{exception}"
                end
                if (user)
                    thr[:name]=user[:name]
                    read(user)
                end
            end
        end
    end
    # handshake gives a welcome message and gets a username and password, upon authentication it returns a user object
    def handshake(connection)
        release = false
        client = connection[0]
        client.puts "welcome to Tchat"
        # gets username and checks whether that username is registered
        # then if regereisted it gets a password to attempt to login
        # otherwise it creates an account
        while (!release)
            username = get_username(client)
            registered = checkUser({'username'=>username})
            p '',registered,'registered',''
            registered = JSON.parse(registered[1])['isuser']
            if registered
                password = get_password(client,registered,username)
                release = password ? login(client,username,password) : false
            else
                password = get_password(client,registered,username)
                release = password ? signIn(client,username,password) : false
            end
        end
        user = User.new(client,username,'general',connection[1])
        p '',"new user: #{user}"
        @rooms.push(user)
        user[:client].puts "currently connected: #{@rooms.users().map{|user| user[:name]}}"
        user[:client].puts "current rooms: #{@rooms.keys.map{|room| room}}"
        user[:client].puts "\\help for help"
        return user

    end
    # read reads from a socket (which should be on its own thread)
    # every message recieved is checked for if its a command (prefixed with '\')
    # otherwise it writes to everyone in the same room as the user and sends the message to other servers
    #  if there is an error the user is dissconnected and deleted from rooms
    def read(user)
        # encoding is for rare cases of someone trying to send something like control-c (^c), which throws a 'cant convert ancci to utf' error.
        begin
            while(msg = user[:client].gets.chomp.force_encoding("ISO-8859-1").encode("UTF-8"))
                # puts "#{user[:name]}: #{msg}"
                if (msg[0] !="\\")             
                    begin
                        write_room("#{user[:name]}: #{msg}", user)
                        @sisterServer.send({'action'=>'msg','room'=>user[:room],'handle'=>user[:name],'text'=>msg})
                    rescue => exception
                        p '',"write error #{exception}",''
                    end
                else
                    ClientController.act(msg,user,@rooms)
                end

            end
        rescue
            p '',"closing #{[user[:client],user[:name]]}",''
            user[:client].close
            @rooms.delete(user)
            p @rooms
        end
    end

    # writes to every user on this server
    def write_all(msg, originator = nil)
        @rooms.users().each do |user| 
            if(user != originator)
                begin
                    user.client.puts(msg) 
                rescue => exception
                    p "closing #{user}"
                    user[:client].close
                    @rooms.delete(user)
                end
            end
        end
    end
    #  writes to everyone on this server in specific room or originators room
    def write_room(msg,originator, room =  nil)
        @rooms[room || originator.room].each do |user| 
            begin
                user.client.puts(msg) 
            rescue => exception
                p '',"closing #{user}",''
                user[:client].close
                @rooms.delete(user)
            end
        end
    end

    # starts up a console seperately from the listneing thread
    # lets you put in messages to see whats up with the server
    def start_console()
        thr = Thread.new() do
            thr[:name]='console'
            loop {
                cmd = $stdin.gets.chomp
                if (/msg*/.match(cmd))
                    msg =  (/msg(.*)/.match(cmd))
                    msg = me.name + msg[1]
                    p msg
                    write_all(msg,me)
                elsif(cmd == '-h')
                    puts "'msg 'message'; outputs everything after 'msg'"
                    puts "'see' ; outputs user and threads arrays"
                    puts "'diss'; disconnects all users"
                    puts "'myip'; outputs the IP adress of machine" 
                elsif(cmd == 'see')
                    puts "users: #{@rooms.users().length}"
                    @rooms.users().each{|user| puts user[:name]}
                    puts "threads: #{Thread.list.length}"
                    Thread.list.each{|t| puts "thread name:#{t[:name]}"}
                    puts 'allrooms', @rooms.allRooms()
                    
                elsif(cmd == 'diss')
                    @rooms.users().each{|user| user.client.close()}
                elsif(cmd == 'myip')
                    p local_ip
                end
                
            }
        end
    end
    # this is for receiving a new room list
    def newForeignUserlist(frooms)
        @rooms.newForeignRooms(frooms)
    end
    # this is for sending a room list
    def sendUserList
        begin
            @sisterServer.send({'action'=>'userList','payload'=>{'userList'=>@rooms.users(),'rooms'=>@rooms.rooms}})
        rescue => e
            p ['send userlist error',e]
        end
    end

    # just for fun, returns your ip
    def local_ip
        orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily

        UDPSocket.open do |s|
            s.connect '64.233.187.99', 1
            s.addr.last
        end
        ensure
            Socket.do_not_reverse_lookup = orig
    end

end

server = Server.new(ARGV[0] || 9876,ARGV[1] || 'localhost')


