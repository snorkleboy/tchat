require 'faye/websocket'
require_relative "../TCPserver/sister_server"
require 'json'
module Chat
    class Websockets
        KEEPALIVE_TIME = 15 # in seconds

        def initialize(app)
            @app     = app
            @usersList = [];
            @clients = []
            @foreignUsers = []
            @foreignRooms = {}
            @rooms=Hash.new{|h,k| h[k]=Array.new()}
            @rooms['general']=[]
            begin
                @sisterClient = SisterClient.new(9009,'localhost', self)
            rescue => exception
                p '',[exception,'sister client not connected'],''
            end
            
            @msgAllProc = Proc.new{|msg,room| @rooms[room].each{|client| client.send(msg)}}
            begin
                @sisterClient.open(@msgAllProc)
            rescue => exception
                p exception
                p '','couldnt connect to sister server',''
            end
        end

        def call(env)
            if Faye::WebSocket.websocket?(env)
                ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME })
                wsClient = Client.new(ws,env['PATH_INFO'][1..-1],'general',true)
                ws.on :open do |event|
                    p '',['websocket connection opened', ws.object_id]
                    @clients.push(wsClient)
                    @rooms[wsClient.room].push(wsClient)
                    # send userlist to frontend
                    sendUserListToClient()
                    p '','clients connected:'
                    p [@clients.count,@clients.map{|client| client.name}]
                end

                ws.on :message do |event|
                    msg = JSON.parse(event.data)
                    p '',['websocket message event', msg],''
                    if (msg['action'] === 'msg')
                        @rooms[msg['room']].each{|client| client.send(event.data) unless client.ws==ws }
                        @sisterClient.send(msg)
                    else
                        webSocketClientController(msg,wsClient)
                    end
                    
                end

                ws.on :close do |event|
                    p '',['websocket closing', ws.object_id, event.code, event.reason],''
                    @clients.delete(wsClient)
                    @rooms[wsClient.room].delete(wsClient)
                    ws = nil
                end

                ws.rack_response
            else
                @app.call(env)
            end
        end

        def webSocketClientController(msg,client)
            case msg['action']
                when 'roomChange'
                    p 'change room action',msg,client.name,@rooms
                    newRoom = msg['payload']['room']
                    oldRoom = client.room

                    @rooms[oldRoom].delete(client)
                    @rooms.delete(oldRoom) if (oldRoom != 'general' && @rooms[oldRoom].empty?)
                    @rooms[newRoom]= @rooms[newRoom].push(client)
                    client.room = newRoom
                    sendUserListToClient()
                    p 'change room',@rooms
                else
                    p 'unrecognized webSocketClient command'
            end
        end

        def sendUserListToClient
            tempCopy = {}
            @foreignRooms.each_pair{|k,v| tempCopy[k]=v.map{|client| client}}
            tempCopy = tempCopy.merge(@rooms){|k,v1,v2| v1.concat(v2)}
            p 'tempcopy',tempCopy
            @clients.each do |client|
                client.send(JSON.generate({
                    'action'=>'userList',
                    'payload'=>{'userList'=>@clients,'rooms'=>tempCopy}
                }))
            end
        end

        def addUsers(payload)
            @foreignUsers = payload['userList']
            @foreignRooms = payload['rooms']
            sendUserListToClient()
            p 'added users',@rooms,@foreignRooms,''
            
        end


    end
        
end

class Client
    attr_accessor :ws,:name,:room,:tcp
    
    def initialize(wsInterface,name,room,websocket=true)
        @ws=wsInterface
        @name=name
        @room=room
        @websocket=tcp
    end

    def send(msg)
        @ws.send(msg)
    end
    def inspect
        @name
    end
    def to_json(options)
        {'name'=>@name,'room'=>@room,'websocket?'=>@websocket}.to_json
    end


end