require 'json'
class SisterServer
    def initialize(port, host,tcpserver)
        @SisterSocket = Socket.new(AF_INET, SOCK_STREAM, 0)
        sistersockaddress = Socket.pack_sockaddr_in(port,host)
        @location = [port,host]
        @SisterSocket.bind(sistersockaddress)
        @connected = false
        @server = tcpserver
    end

    def start(proc)
        p 'sister_server_start'
        p proc
        p @server
        Thread.new(){
            Thread.current[:name]='Sister Listener'
            @SisterSocket.listen(1)
            p "sister server up and listening on #{@location}"
            Thread.new(@SisterSocket.accept) do |connection| 
                Thread.current[:name]="sister listener: #{connection}"
                @client = connection[0]
                p "SISTER SERVER ACCEPTED :#{connection}"
                @connected = true
                listen(proc)
            end
        }
    end

    def listen(proc)
        p "sisterserver listen start, proc=#{proc}"
        while (msg = @client.gets)
            message = JSON.parse(msg)
            puts "sisterserver listen", message,msg,''
            if (message['action'] === 'msg')
                proc.call(message)
            else
                sisterController(message)
            end
        end
        p 'sister connection closing'
        @client.close()
        @connected = false
    end

    def send(msg)
        if (@connected)
            p "sister server puts #{[msg]}"
            @client.puts(JSON.generate(msg))
        else
            p 'sister server not connected to sister client'
        end
    end

    def sisterController(msg)
        case msg['action']
            when 'userList'
                p '','new user list', msg,''
                @server.newForeignUserlist(msg['payload']['rooms'])
            else
                p 'unknown sisterserver command'
        end
    end

end


class SisterClient

    attr_accessor :socket, :connected

    def initialize(port, host,parent)
        @parent = parent
        @port = port
        @host = host
        @socket = nil
        @connected = false
    end


    def open(proc)
        begin
            @socket = TCPSocket.open(@host, @port)
            Thread.new(){
                @connected = true
                listen(proc)
            } 
        rescue => exception
            puts '','couldnt connect to sister server'
            p exception,''
            @connected = false
        end

    end

    def listen(proc)
        p '',"sister client start listen, proc= #{proc}",''
        while (msg = socket.gets) 
            message = JSON.parse(msg)
            puts '',"sister client received #{message}",''
            if (message['action'] == 'msg')           
                proc.call(msg,message['room'])
            else
                sisterController(message)
            end
        end
    end

    def send(msg)
        if (@connected)
            p '',"sister client puts #{msg}",''
            @socket.puts(JSON.generate(msg))
        else
            p 'not connected to sister client'
        end
    end

    def sisterController(msg)
        p ['sister controller']
        case msg['action']
            when 'userList'
                p ["new userlist",msg]
                @parent.addUsers(msg['payload'])

            when ''
            
            else
                p ['unknown server action',msg]
        end
    end

end