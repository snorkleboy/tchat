class SisterServer
    def initialize(port, host)
        @SisterSocket = Socket.new(AF_INET, SOCK_STREAM, 0)
        sistersockaddress = Socket.pack_sockaddr_in(port,host)
        @location = [port,host]
        @SisterSocket.bind(sistersockaddress)
        @connected = false
    end

    def start(proc)
        
        p 'sister_server_start'
        p proc
        Thread.new(){
            Thread.current[:name]='Sister Listener'
            @SisterSocket.listen(1)
            p "sister server up and listening on #{@location}"
            Thread.new(@SisterSocket.accept) do |connection| 
                Thread.current[:name]="sister listener: #{connection}"
                @client = connection[0]
                p "SISTER SERVER ACCEPTED :#{connection}"
                @connected =true
                listen(proc)
            end
        }
    end

    def listen(proc)
        p "sisterserver listen start, proc=#{proc}"
        while (msg = @client.gets)
            
            p "sisterserver listen #{msg}"
            proc.call(msg)
        end
        p 'sister connection closing'
        @client.close()
        @connected = false
    end

    def send(msg)
        if (@connected)
            p "sister server puts #{msg}"
            @client.puts(msg)
        else
            p 'sister server not connected to sister client'
        end
    end

end


class SisterClient

    attr_accessor :socket

    def initialize(port, host)
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
            puts 'couldnt connect to sister server'
            p exception
            @connected = false
        end

    end

    def listen(proc)
        p "sister client start listen, proc= #{proc}"
        while (true)
            msg = socket.gets
            p "sister client received #{msg}"
            proc.call(msg)
        end
    end

    def send(msg)
        if (@connected)
            p "sister client puts #{msg}"
            @socket.puts(msg)
        else
            p 'not connected to sister client'
        end
    end

end