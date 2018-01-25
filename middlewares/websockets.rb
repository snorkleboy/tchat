require 'faye/websocket'
require_relative "../TCPserver/sister_server"

module Chat
  class Websockets
    KEEPALIVE_TIME = 15 # in seconds

    def initialize(app)
      @app     = app
      @clients = []
      @sisterClient = SisterClient.new(9001,'localhost')
      @msgAllProc = Proc.new{|msg| @clients.each{|client| client.send(msg) }}
      begin
          @sisterClient.open(@msgAllProc)
      rescue => exception
          p exception
          p 'couldnt connect to sister server'
      end
    end

    def call(env)
        if Faye::WebSocket.websocket?(env)
            ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME })

            ws.on :open do |event|
                p ['websocket connection opened', ws.object_id]
                @clients << ws
                p 'clients connected:'
                p @clients.count
            end

            ws.on :message do |event|
                p ['websocket message event', event.data]
                @clients.each {|client| client.send(event.data) unless client==ws }
                @sisterClient.send(event.data)
            end

            ws.on :close do |event|
                p ['websocket closing', ws.object_id, event.code, event.reason]
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