require 'faye/websocket'
require_relative "../util/sister_server"
require 'json'
require_relative "../util/rooms"

module Chat
    class Websockets
        KEEPALIVE_TIME = 15 # in seconds

        def initialize(app)
            @app     = app
            @usersList = [];
            @clients = []
            @rooms=Rooms.new(Proc.new{sendUserListToSister},Proc.new{sendUserListToClients})

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
                    @rooms.push(wsClient)
                    p '','clients connected:'
                    p [@clients.count,@clients.map{|client| client.name}]
                end

                ws.on :message do |event|
                    msg = JSON.parse(event.data)
                    p '',['websocket message event', msg,event.data],''
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
                    @rooms.delete(wsClient)
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

                    @rooms.changeRoom(client,newRoom)
                    p 'change room',@rooms
                else
                    p 'unrecognized webSocketClient command'
            end
        end

        def sendUserListToClients
            copy = @rooms.allRooms()
            @clients.each do |client|
                client.send(JSON.generate({
                    'action'=>'userList',
                    'payload'=>{'userList'=>@clients,'rooms'=>copy}
                }))
            end
        end

        def sendUserListToSister

            @sisterClient.send({
                'action'=>'userList',
                'payload'=>{'userList'=>@clients,'rooms'=>@rooms.allRooms()}
            })
        end

        def addUsers(payload)
            @rooms.newForeignRooms(payload['rooms'])
            p 'added users',@rooms.allRooms(),''
            
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