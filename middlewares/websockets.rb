require 'faye/websocket'
require_relative "../TCPserver/sister_server"
require 'json'
module Chat
  class Websockets
    KEEPALIVE_TIME = 15 # in seconds

    def initialize(app)
        @app     = app
        @clients = []
        @rooms={'general'=>[]}
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

            ws.on :open do |event|
                
                p '',['websocket connection opened', ws.object_id]
                # p event
                @clients << ws
                p '','clients connected:'
                p @clients.count
            end

            ws.on :message do |event|
                p '',['websocket message event', event.data],''
                @clients.each {|client| client.send(event.data) unless client==ws }
                @sisterClient.send(JSON.parse(event.data))
            end

            ws.on :close do |event|
                p '',['websocket closing', ws.object_id, event.code, event.reason],''
                @clients.delete(ws)
                ws = nil
            end

            ws.rack_response
        else
            @app.call(env)
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
        @ws.send
    end


end