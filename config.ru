require './middlewares/backend'
require 'rack'
require './middlewares/file_server'

use Chat::ChatBackend
use Rack::Static, :urls => [""],:root=> 'public', :index =>'index.html'
use Chat::FileServer
run lambda {}