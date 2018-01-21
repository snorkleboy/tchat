require 'rack'
class App
    def initialize
        
    end

    def call(env)
        use Rack::Static, :urls => [""],:root=> 'public', :index =>'index.html'
        run lambda { |env|
            [
                200,
                {
                'Content-Type'  => 'text/html',
                'Cache-Control' => 'public, max-age=86400'
                },
                File.open('index.html', File::RDONLY)
            ]
        }
        # ['200', {'Content-Type' => 'text/html'}, ["Hello world! this is a 'rack' app and The time is #{Time.now}"]]
    end
end


