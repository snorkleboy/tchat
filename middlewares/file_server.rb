
module Chat
    class FileServer
        def initialize(app)
            @app = app
        end

        def call(env)
            [
                200,
                {
                'Content-Type'  => 'text/html',
                'Cache-Control' => 'public, max-age=86400'
                },
                File.open('index.html', File::RDONLY)
            ]
        end
    end
end