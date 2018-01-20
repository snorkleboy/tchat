require 'socket'
require 'thread'
include Socket::Constants
ESCAPE_CHAR = 'q'
socket = Socket.new(AF_INET, SOCK_STREAM, 0)
# pack_sockaddr_in(80, 'example.com')
p ENV
p ""
p ENV["PORT"]
sockaddress = Socket.pack_sockaddr_in(ARGV[0] || ENV["PORT"] || 9876, ARGV[1] || ENV["address"] || 'localhost')
socket.bind(sockaddress)
listen = socket.listen(5)

p "socket bound and listening on #{ARGV[0] || ENV["port"] || 9876}, #{ARGV[1] || ENV["address"] || 'localhost'}"
p listen
# p ENV

connections = []
while(true) do
p 'waiting for connection'
    Thread.start(socket.accept) do |connection| 
        p "server accepted :#{connection}"
        client = connection[0]
        # p client.methods
       while(!client.closed?)
        msg = client.gets
        puts msg
       end
       client.close()
       p 'client closed'
    end


end