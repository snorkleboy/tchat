
# Tchat
### A Websocket and TCP instant chat service. chat.artemkharshan.com:80 is websocket based instant chat app.

### chat.artemkharshan.com:90 is a TCP server that impliments instant chat between users directly through TCP. You can use anything from telnet to netcat to connect to it and chat and users on the TCP server seamlessly chat with browser clients and visa versa. 

### Users on both servers can seemlessy chat with eachother and make and join chat rooms.  




## how to start servers
 sudo ruby tcpserver.rb 90 0.0.0.0
 sudo rackup -E production -p 80 -o 0.0.0.0
 *you shoudl start the tcpserver first for the servers to connect to each other correctly
 *setting the rackup server to production is important even indevelopment mode as Faye websockets cant hijack right in Puma dev mode.
 
## TCP side

### TCPclient
simply make a tcp connection to the server and you will be prompted for a username and can request a list of signed on users. 
once signed on you can type messages to send in the cli and messages recieved will be tagged by author.

#### TCPclient commands
```
                     '\help'        =>shows commands
                     '\croom room'=>change rooms to 'room'
                     '\see'         =>see all rooms and users
                     '\seeroom'     =>see users in same room
```

### TCPserver console commands
```
'see'                   =>shows a list of users and running threads. Note that the server is always user[0].
'diss'                  =>closes all connections in the User pool
'myip'                  =>outputs your IP 
'msg your message here' =>sends 'your message here' to all users(on tcp server)

