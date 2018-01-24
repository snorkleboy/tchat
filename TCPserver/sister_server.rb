class SisterServer
    def initialize(port, host)
        @SisterSocket = Socket.new(AF_INET, SOCK_STREAM, 0)
        sistersockaddress = Socket.pack_sockaddr_in(port,host)
        @location = [port,host]
        @SisterSocket.bind(sistersockaddress)
    end

    def start(proc)
        p 'sister_server_start'
        p proc
        Thread.new(){
            @SisterSocket.listen(1)
            p "sister server up and listening on #{@location}"
            Thread.new(@SisterSocket.accept) do |connection| 
                @client = connection[0]
                p "SISTER SERVER ACCEPTED :#{connection}"
                p "HERHERHERHERH"
                listen(proc)
            end
        }
    end

    def listen(proc)
        p "sisterserver listen start, proc=#{proc}"
        while (true)
            msg = @client.gets
            p "sisterserver listen #{msg}"
            proc.call(msg)
        end
    end

    def send(msg)
        p "sister server puts #{msg}"
        @client.puts(msg)
    end

end


class SisterClient

    attr_accessor :socket

    def initialize(port, host)
        @port = port
        @host = host
        @socket = nil
    end


    def open(proc)
        
        @socket = TCPSocket.open(@host, @port)
        Thread.new(){
            listen(proc)
        }
    end

    def listen(proc)
        p "sister client start listen, proc= #{proc}"
        while (true)
            msg = socket.gets
            proc.call(msg)
        end
    end

    def send(msg)
        p "sister client puts #{msg}"
        @socket.puts(msg)
    end

end