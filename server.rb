require 'socket'
require 'thread'
include Socket::Constants
ESCAPE_CHAR = 'q'
socket = Socket.new(AF_INET, SOCK_STREAM, 0)

port = ENV["PORT"] || ARGV[0] || 3000
host = ARGV[1] || ENV["address"] || 'localhost'
sockaddress = Socket.pack_sockaddr_in(port,host )

socket.bind(sockaddress)
listen = socket.listen(5)

p "socket bound and listening on #{[host,port]}"

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