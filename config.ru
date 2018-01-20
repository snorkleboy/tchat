require './middlewares/backend'
require 'rack'
require './middlewares/file_server'

use Rack::Static, :urls => [""],:root=> 'public', :index =>'index.html'
use Chat::ChatBackend
use Chat::FileServer
run lambda {}