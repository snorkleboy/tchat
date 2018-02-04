require 'rack'
require 'json'
require 'sequel'
module Chat
    class APIController
        def initialize(app)
            @app=app
            db = Sequel.connect(adapter: :postgres, user: 'snorkleboy', host: '/var/run/postgresql', port: 5432,
  database: 'chat', max_connections: 10)
            p db


        end
        def call(env)
            [200, { 'Content-Type' => 'application/json' }, [ JSON.generate({"a"=>4})]]
        end
    end
end 
