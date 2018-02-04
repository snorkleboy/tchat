require './middlewares/websockets'
require 'rack'
require './middlewares/file_server'
require './middlewares/controllers/apiController'

use Chat::Websockets

map "/api/" do
    use Chat::APIController
end
use Rack::Static, :urls => [""],:root=> 'public', :index =>'index.html'
# use fourOhFour

run lambda {}