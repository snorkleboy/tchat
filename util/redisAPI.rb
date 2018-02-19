require 'json'
require 'redis'
class RedisApi
    MESSAGECHANNEL        = "messages"
    ROOMCHANNEL           = 'rooms'
    def initialize(sendMsgToClients,updateRooms)
        @sendMsgToClients =sendMsgToClients
        @updateRooms = updateRooms

        # uri      = URI.parse(ENV["REDISCLOUD_URL"])
        @redis   = newRedis()
        p ['REDISAPI',@redis]
        thr = Thread.new do
            thr[:name] = 'redis MESSAGECHANNEL'
            redis_messages = newRedis()
            redis_messages.subscribe(MESSAGECHANNEL) do |on|
                on.message do |channel, msg|
                    p 'received message from redis on message channel',channel, msg,JSON.parse(msg)
                    @sendMsgToClients.call(JSON.parse(msg))
                end
            end
        end
        thr = Thread.new do
            thr[:name] = 'redis ROOMCHANNEL'
            redis_rooms = newRedis()
            redis_rooms.subscribe(ROOMCHANNEL) do |on|
                on.message do |channel, msg|
                    p 'received message from redis on room channel',channel, msg,JSON.parse(msg)
                    @updateRooms.call(JSON.parse(msg)['payload']['rooms'])
                end
            end
        end
    end
    def message_channel
        MESSAGECHANNEL
    end
    def room_channel
        ROOMCHANNEL
    end
    def newRedis(uri = false)
        uri ?
            Redis(host: uri.host, port: uri.port, password: uri.password)
        :
            Redis.new  #(host: uri.host, port: uri.port, password: uri.password)
    end
    def receive_redis(response)
        response.call
    end

    def publish(channel,msg)
        @redis.publish(channel, JSON.generate(msg))
    end

end