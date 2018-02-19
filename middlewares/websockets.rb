require 'faye/websocket'
require_relative "../util/sister_server"
require_relative "../util/redisAPI"

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

            # redis setup
            messageClients = Proc.new{|msg| @rooms[msg['room']].each{|client| client.send(msg)}}
            updateRooms = Proc.new{|newRooms| @rooms.newForeignRooms(newRooms)}
            @redisAPI = RedisApi.new(messageClients,updateRooms)

        end

        def call(env)
            if Faye::WebSocket.websocket?(env)
                ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME })

                
                temp=  env['PATH_INFO'].split('/')
                name, token = temp[1],temp[2]
                p temp
                wsClient = Client.new(ws,name,'general',true)
                ws.on :open do |event|
                    p '',['websocket connection opened', ws.object_id]

                    params = ({username:name,token:token})
                    uri = URI.parse("http://localhost:6000/tokencheck")
                    res = Net::HTTP.post_form(uri, params)
                    if res.is_a?(Net::HTTPSuccess)
                        @clients.push(wsClient)
                        @rooms.push(wsClient)
                        p '','clients connected:'
                        p [@clients.count,@clients.map{|client| client.name}]
                    else
                        ws.send(JSON.generate({'action'=>'error','error'=>"incorrect token"}))
                        ws.close;
                    end
                    
                end

                ws.on :message do |event|
                    msg = JSON.parse(event.data)
                    p '',['websocket message event', msg],''
                    if (msg['action'] === 'msg')
                        # @rooms[msg['room']].each{|client| client.send(event.data) unless client.ws==ws }
                        @redis.publish(@redis.message_chanel,msg)
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
            @rooms.users.each do |client|
                client.send(JSON.generate({
                    'action'=>'userList',
                    'payload'=>{'userList'=>@clients,'rooms'=>copy}
                }))
            end
        end

        def sendUserListToSister
            @redis.publish(@redis.message_chanel,{
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