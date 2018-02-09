require 'rack'
require 'json'
require 'net/http'
require_relative '../../util/dbServerApi'
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
                    begin
                        req = Rack::Request.new(env) 
                        params = JSON.parse(req.body.read)     
                        p ['api controller', 'signup',params]
                        res = postUser( params)              
                        if res[0]
                            [200, { 'Content-Type' => 'application/json' }, [res[1]]]
                        else
                            [400, { 'Content-Type' => 'application/json' },[res[1]]]
                        end  
                    rescue => exception
                        [400, { 'Content-Type' => 'application/json' },[ JSON.generate({'error'=>exception})]]
                    end

                end,
                '/login' =>lambda do |env|
                    begin
                        request = Rack::Request.new(env) 
                        params = JSON.parse(request.body.read)
                        p ['api controller', 'login',params]
                        res = postSession(params)
                        if res[0]
                                [200, { 'Content-Type' => 'application/json' }, [res[1]]]
                        else
                                [400, { 'Content-Type' => 'application/json' },[res[1]]]
                        end
                        
                    rescue => exception
                        [400, { 'Content-Type' => 'application/json' },[ JSON.generate({'error'=>exception})]]
                    end

                end,
                '/isuser' =>lambda do |env|
                    begin
                        request = Rack::Request.new(env) 
                        params = JSON.parse(request.body.read)
                        p ['api controller, user check',params]
                        #set uri
                        res = checkUser(params)    
                        if res[0]
                            [200, { 'Content-Type' => 'application/json' }, [res[1]]]
                        else
                            [400, { 'Content-Type' => 'application/json' },[res[1]]]
                        end                      
                    rescue => exception
                        [400, { 'Content-Type' => 'application/json' },[ JSON.generate({'error'=>exception})]]
                    end

                end,
                '/tokencheck' =>lambda do |env|
                    begin
                        request = Rack::Request.new(env) 
                        params = JSON.parse(request.body.read)
                        p ['api controller, token check',params]
                        #set uri
                        res tokenCheck(params)
                        if res[0]
                            [200, { 'Content-Type' => 'application/json' }, [res[1]]]
                        else
                            [400, { 'Content-Type' => 'application/json' },[res[1]]]
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
