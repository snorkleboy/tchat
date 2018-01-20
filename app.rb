class App_maker
    def initialize
        
    end

    def make
        return app = Proc.new do |env|
            ['200', {'Content-Type' => 'text/html'}, ["Hello world! this is a 'rack' app and The time is #{Time.now}"]]
        end
    end
end
