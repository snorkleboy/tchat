require 'rack'
require 'json'

module Chat
    class APIController
        def initialize(app)
            @app=app

        end
        def call(env)
            [200, { 'Content-Type' => 'application/json' }, [ JSON.generate({"a"=>4})]]
        end
    end
end 
