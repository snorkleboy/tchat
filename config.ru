require './middlewares/websockets'
require 'rack'
require './middlewares/file_server'

use Chat::Websockets
use Rack::Static, :urls => [""],:root=> 'public', :index =>'index.html'
use Chat::FileServer
run lambda {}