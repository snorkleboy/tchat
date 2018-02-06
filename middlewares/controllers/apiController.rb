require 'rack'
require 'json'
require 'sequel'
module Chat
    class APIController
        def initialize(app)
            @app=app
            db = Sequel.connect(adapter: :postgres, user: 'snorkleboy', host: '/var/run/postgresql', port: 5432,
  database: 'chat', max_connections: 10)
            p ['connected to postgreSQL',db]


            @routes = routes=Rack::URLMap.new(
                "/test" => lambda{|env|
                    [200, { 'Content-Type' => 'application/json' }, [ JSON.generate({"db"=>db})]]
                },

                '/route' => lambda{|env|
                    [200, { 'Content-Type' => 'application/json' }, JSON.generate({ "route"=>['route',1,2,3,4,5,6,7] })]
                }
            )
        end

        def call(env)
            p '',['api controller'],''
            @routes.call(env)
        end
    end
end 
