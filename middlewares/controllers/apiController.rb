require 'rack'
require 'json'
require 'net/http'
module Chat
    class APIController
        def initialize(app)
            @app=app


            @routes = routes=Rack::URLMap.new(
                '/testpost' =>lambda do |env|

                    #set uri
                    
                    user = {username: "username",password:'password'}
                    uri = URI.parse("http://localhost:6000/user")
                    res = Net::HTTP.post_form(uri, user)

                    if res.is_a?(Net::HTTPSuccess)
                            [200, { 'Content-Type' => 'application/json' }, [(res.body)]]
                    else
                            [400, { 'Content-Type' => 'application/json' },[ JSON.generate({'error'=>res.value})]]
                    end

                end,
                '/testget' =>lambda do |env|
                    begin
                        uri = URI("http://localhost:6000/user")
                        res = Net::HTTP.get_response(uri)
                        if res.is_a?(Net::HTTPSuccess)
                            [200, { 'Content-Type' => 'application/json' }, [(res.body)]]
                        else
                            [400, { 'Content-Type' => 'application/json' },[ JSON.generate({'error'=>res.value})]]
                        end
                    rescue => exception
                        [400, { 'Content-Type' => 'application/json' },[ JSON.generate({'error'=>exception})]]
                        
                    end
                    
                end
            )
        end

        def call(env)
            p '',['api controller'],''
            @routes.call(env)
        end
    end
end 
