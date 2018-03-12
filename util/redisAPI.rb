require 'json'
require 'redis'
class RedisApi
  MESSAGECHANNEL = 'messages'.freeze
  ROOMCHANNEL = 'rooms'.freeze
  def initialize(sendMsgToClients, updateRooms)
    @sendMsgToClients = sendMsgToClients
    @updateRooms = updateRooms

    # uri      = URI.parse(ENV["REDISCLOUD_URL"])
    @redis = newRedis
    p ['REDISAPI', @redis]
    thr = Thread.new do
      thr[:name] = 'redis MESSAGECHANNEL'
      redis_messages = newRedis
      redis_messages.subscribe(MESSAGECHANNEL) do |on|
        on.message do |_channel, msg|
          message = JSON.parse(msg)
          p 'received message from redis on message channel', message
          @sendMsgToClients.call(msg, message['room'])
        end
      end
    end
    thr = Thread.new do
      thr[:name] = 'redis ROOMCHANNEL'
      redis_rooms = newRedis
      redis_rooms.subscribe(ROOMCHANNEL) do |on|
        on.message do |_channel, msg|
          message = JSON.parse(msg)
          p 'received message from redis on room channel', message
          @updateRooms.call(message['payload']['rooms'])
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
        Redis.new # (host: uri.host, port: uri.port, password: uri.password)
  end

  def receive_redis(response)
    response.call
  end

  def publish(channel, msg)
    @redis.publish(channel, JSON.generate(msg))
  end
end
