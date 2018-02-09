require 'rack'
require 'json'
require 'net/http'

# sample javascript fetch

# var payload = {
#     username: 'timl',
#     password: 'pass'
# };


# fetch("http://localhost:3000/api/testpost",
# {
#     method: "POST",
#     body: JSON.stringify(payload)
# })
# .then(function(res){ return res.json(); })
# .then(function(data){ console.log( JSON.stringify( data ) ) })

module Chat
    class APIController
        def initialize(app)
            @app=app


            @routes = routes=Rack::URLMap.new(
                '/signup' =>lambda do |env|
                    req = Rack::Request.new(env)      

                    begin
                        params = JSON.parse(req.body.read)
                        p ['api controller, post user',params]
                        #set uri
                        uri = URI.parse("http://localhost:6000/user")
                        res = Net::HTTP.post_form(uri, params)

                        if res.is_a?(Net::HTTPSuccess)
                                [200, { 'Content-Type' => 'application/json' }, [res.body]]
                        else
                                [400, { 'Content-Type' => 'application/json' },[res.body]]
                        end
                        
                    rescue => exception
                        [400, { 'Content-Type' => 'application/json' },[ JSON.generate({'error'=>exception})]]
                    end

                end,
#  sample login fetch
#                 var payload = {
#     username: 'timl',
#     password: 'pass'
# };


# fetch("http://localhost:3000/api/login",
# {
#   method: "POST",
#   body: JSON.stringify(payload),
# 	headers:new Headers({'authentication':'jwt start'})
# })
# .then(function(res){ return res.json(); })
# .then(function(data){ console.log( JSON.stringify( data ) ) })
                '/login' =>lambda do |env|
                    request = Rack::Request.new(env) 

                    begin
                        params = JSON.parse(request.body.read)
                        p ['api controller, login',params]
                        #set uri
                        uri = URI.parse("http://localhost:6000/login")
                        res = Net::HTTP.post_form(uri, params)
                        if res.is_a?(Net::HTTPSuccess)
                                [200, { 'Content-Type' => 'application/json' }, [res.body]]
                        else
                                [400, { 'Content-Type' => 'application/json' },[res.body]]
                        end
                        
                    rescue => exception
                        [400, { 'Content-Type' => 'application/json' },[ JSON.generate({'error'=>exception})]]
                    end

                end,
                '/isuser' =>lambda do |env|
                    request = Rack::Request.new(env) 

                    begin
                        params = JSON.parse(request.body.read)
                        p ['api controller, user check',params]
                        #set uri
                        uri = URI.parse("http://localhost:6000/isuser")
                        res = Net::HTTP.post_form(uri, params)
                        if res.is_a?(Net::HTTPSuccess)
                                [200, { 'Content-Type' => 'application/json' }, [res.body]]
                        else
                                [400, { 'Content-Type' => 'application/json' },[res.body]]
                        end
                        
                    rescue => exception
                        [400, { 'Content-Type' => 'application/json' },[ JSON.generate({'error'=>exception})]]
                    end

                end,
            )
        end

        def call(env)
            p ['api controller']
            @routes.call(env)
        end

        def auth()
                        # jwt = request.get_header('HTTP_AUTHENTICATION')
                        # req = Net::HTTP::Post.new(uri)
                        # req['authentication'] = jwt
                        
                        # res = Net::HTTP.start(uri.hostname, uri.port) do |http|
                        #     http.request(req)
                        # end
        end
    end
end 
