require 'socket'
require 'thread'
include Socket::Constants
ESCAPE_CHAR = 'q'

socket = Socket.new(AF_INET, SOCK_STREAM, 0)
# pack_sockaddr_in(80, 'example.com')
sockaddress = Socket.pack_sockaddr_in(ARGV[0] || 9876, ARGV[1] || 'localhost')
socket.bind(sockaddress)
listen = socket.listen(5)

p 'socket bound and listening'
p listen

connections = []
while(true) do
p 'waiting for connection'
    Thread.start(socket.accept) do |connection| 
        p "server accepted :#{connection}"
        client = connection[0]
        client.puts "hello"


    end


end