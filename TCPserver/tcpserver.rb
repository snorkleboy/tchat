#!/usr/bin/env ruby

require 'socket'
require 'thread'
require_relative "../util/sister_server"
require_relative "../util/rooms"
require 'json'
include Socket::Constants
ESCAPE_CHAR = 'q'


User = Struct.new(:client, :name,:room, :address) do 
    def to_json(options)
        {'name'=>name,'room'=>room}.to_json
    end
end


class Server 
    def initialize(port, host, name = 'TCPserverHOST')
        @rooms = Rooms.new(Proc.new{sendUserList()})
        # @threads = []
        @socket = Socket.new(AF_INET, SOCK_STREAM, 0)
        @sisterServer = SisterServer.new(9009,'localhost',self)
        @messageallProc = Proc.new{|msg| write_room("#{msg['handle']}: #{msg['text']}",nil,msg['room'])}
        @sisterServer.start(@messageallProc)
        sockaddress = Socket.pack_sockaddr_in(port,host)
        
        @socket.bind(sockaddress)
        
        p "socket bound on #{host} #{port}"
        
        start()
    end
    def start
        @socket.listen(5)
        Thread.current[:name]='Main Listener'
        p 'listening' 
        start_console()
        p 'console running'
        # on connection put new socket into new thread
        # thread does 'handshake' which gets username from TCP cleint
        # If tcpclient it reads and broadcasts messages from it, otherwise it closes the connection in handhsake and then kills the thread.
        while(true) do
            thr = Thread.start(@socket.accept) do |connection| 
                
                p '',"server accepted :#{connection}"
                begin
                    # hand shake looks at request, if its HTTP is sends response and returns false after closing the connection,
                    # if its not HTTP it welcomes to TCPChat and asks for a user name, then returns a userStruct(@socket,name)
                    user = handshake(connection)   
                    puts user     
                rescue => exception
                    p '',"handshake rescue: #{exception}"
                    p self
                end
                if (user)
                    thr[:name]=user[:name]
                    read(user)
                end
            end
            # @threads.push(thr)
        end
    end
    def handshake(connection)
        release = false
        client = connection[0]
        client.puts "welcome to Tchat"
        while (!release)
            client.puts "please enter a username. to see who is on enter 's'"
            msg = client.gets.chomp
            p "client handshake: #{msg}"
            if (msg == 's')
                client.puts 
            else
                release = true
                user = User.new(client,msg,'general',connection[1])
                p '',"new user: #{user}",''
            end 
        end

        @rooms.push(user)
        user[:client].puts "currently connected: #{@rooms.users().map{|user| user[:name]}}"
        user[:client].puts "current rooms: #{@rooms.keys.map{|room| room}}"
        user[:client].puts "\\help for help"
        return user

    end

    def read(user)
        # encoding is for rare cases of someone trying to send something like control-c (^c), which throws a 'cant convert ancci to utf' error.
        begin
            while(msg = user[:client].gets.chomp.force_encoding("ISO-8859-1").encode("UTF-8"))
                puts "#{user[:name]}: #{msg}"
                if (msg[0] !="\\")             
                    begin
                        write_room("#{user[:name]}: #{msg}", user)
                        @sisterServer.send({'action'=>'msg','room'=>user[:room],'handle'=>user[:name],'text'=>msg})
                    rescue => exception
                        p '',"write error #{exception}",''
                    end
                else
                    clientMessageController(msg,user)
                end

            end
        rescue
            p '',"closing #{[user[:client],user[:name]]}",''
            user[:client].close
            @rooms.delete(user)
            p @rooms
        end
    end

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

    def write_to(msg, client)
        client.puts msg
    end

    def local_ip
        orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily

        UDPSocket.open do |s|
            s.connect '64.233.187.99', 1
            s.addr.last
        end
        ensure
            Socket.do_not_reverse_lookup = orig
    end
    def newForeignUserlist(frooms)
        @rooms.newForeignRooms(frooms)
    end
    def sendUserList
        begin
            @sisterServer.send({'action'=>'userList','payload'=>{'userList'=>@rooms.users(),'rooms'=>@rooms.rooms}})
        rescue => e
            p ['send userlist error',e]
        end
    end

    #if msg comes in with '\' as first charecter it gets sent to this controller
    # msg syntax is \'command' 'parameter'
    # like '\croom general' to change to room 'general'
    def clientMessageController(msg, originator)
        command = msg.split(' ')
        command[0] = command[0][1..-1]
        p ['client command',command, originator]
        case command[0]
            when 'help' || 'h'
                originator.client.puts [
                     ['\\croom {room}','change rooms to {room}'],
                     ['\\see','see all rooms and users'],
                     ['\\seeroom','see users in same room']
                ]
            when 'croom'
                @rooms.changeRoom(originator,command[1])
                originator.client.puts "changed room to #{command[1]}"
            when 'see'
                originator.client.puts @rooms.allUsers().sort{|a,b| a['room']<=>b['room']}
            when 'seeroom'
                originator.client.puts [originator.room,@rooms[originator.room].map{|user| user.name}]
            else
                p 'unknown client command'
                originator.puts 'SERVER WARNING:unknown command'
        end

    end

end


server = Server.new(ARGV[0] || 9876,ARGV[1] || 'localhost')


