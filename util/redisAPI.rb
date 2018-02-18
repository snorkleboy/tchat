require 'json'
require 'redis'
class RedisApi
    def initialize(tcpserver)
        @tcpserver = tcpserver
        p ['REDISAPI',@TCPserver]

        # uri      = URI.parse(ENV["REDISCLOUD_URL"])
        @redis   = Redis.new  #(host: uri.host, port: uri.port, password: uri.password)
        p ['REDISAPI',@redis]
    end

    def receive_redis(response)
        response.call
    end

    def subscribe()

    end

    def publish()

    end

end