require 'socket'
require 'thread'
include Socket::Constants
ESCAPE_CHAR = 'q'
socket = Socket.new(AF_INET, SOCK_STREAM, 0)
if (ENV["PORT"])
    port = ENV["PORT"]
    host = '0.0.0.0'
else
    port = ARGV[0] || 3000
    host = ARGV[1] || 'localhost'
end

sockaddress = Socket.pack_sockaddr_in(port,host )

socket.bind(sockaddress)
listen = socket.listen(5)

p "socket bound and listening on #{[host,port]}"

connections = []
while(true) do
p 'waiting for connection'
    Thread.start(socket.accept) do |connection| 
        client = connection[0]
        request = client.gets
        puts request

        client.print "HTTP/1.1 200\r\n" # 1
        client.print "Content-Type: text/html\r\n" # 2
        client.print "\r\n" # 3
        client.print "Hello world! The time is #{Time.now}" #4

        client.close
    end


end