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
            @rooms={'general'=>[]}
            @rooms.default = []
            begin
                @sisterClient = SisterClient.new(9000,'localhost')
            rescue => exception
                p '',[exception,'sister client not connected'],''
            end
            
            @msgAllProc = Proc.new{|msg| @clients.each{|client| client.send(msg) }}
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
                wsClient = Client.new(ws,env['PATH_INFO'][1..-1],'general',false)
                ws.on :open do |event|
                    p '',['websocket connection opened', ws.object_id]
                    @clients.push(wsClient)
                    @rooms[wsClient.room].push(wsClient)
                    # send userlist to frontend
                    @clients.each do |client|
                        client.send(JSON.generate({
                            'action'=>'userList',
                            'payload'=>{'userList'=>@clients,'rooms'=>@rooms}
                        }))
                    end
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
                    client.room = newRoom
                    @rooms[oldRoom].delete(client)
                    @rooms[newRoom] = @rooms[newRoom].push(client)
                    @clients.each do |client|
                        client.send(JSON.generate({
                            'action'=>'userList',
                            'payload'=>{'userList'=>@clients,'rooms'=>@rooms}
                        }))
                    end
                    p 'change room',@rooms
                else
                    p 'unrecognized webSocketClient command'
            end
        end


    end
        
end

class Client
    attr_accessor :ws,:name,:room,:tcp
    
    def initialize(wsInterface,name,room,tcp=false)
        @ws=wsInterface
        @name=name
        @room=room
        @tcp=tcp
    end

    def send(msg)
        @ws.send(msg)
    end
    def inspect
        [@name,@room,@tcp]
    end
    def to_json(options)
        {'name'=>@name,'room'=>@room,'tcpclient?'=>@tcp}.to_json
    end


end