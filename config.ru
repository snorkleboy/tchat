require './middlewares/backend'
require 'rack'

use Chat::ChatBackend
use Rack::Static, :urls => [""],:root=> 'public', :index =>'index.html'
run lambda { |env|
puts 'in lambda run'
  [
    200,
    {
      'Content-Type'  => 'text/html',
      'Cache-Control' => 'public, max-age=86400'
    },
    File.open('index.html', File::RDONLY)
  ]
}