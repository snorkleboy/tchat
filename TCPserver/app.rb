require 'rack'
class App
    def initialize
        
    end

    def call(env)

        ['200', {'Content-Type' => 'text/html'}, ["Hello world! this is a 'rack' app and The time is #{Time.now}"]]
    end
end


