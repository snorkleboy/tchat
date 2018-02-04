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


        end
        def call(env)

            map 'api/test' do
                [200, { 'Content-Type' => 'application/json' }, [ JSON.generate({"test"=>4})]]
            end

            map 'api/route' do
                [200, { 'Content-Type' => 'application/json' }, [ JSON.generate({"route"=>4})]]
            end

        end
    end
end 
