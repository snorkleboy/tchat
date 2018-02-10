require './middlewares/websockets'
require 'rack'
require './middlewares/file_server'
require './middlewares/controllers/apiController'
# require 'rack/cors'

# use Rack::Cors do
#   # allow all origins in development
#   allow do
#     origins '*'
#     resource '*', 
#         :headers => :any, 
#         :methods => [:get, :post, :delete, :put, :options]
#   end
# end

use Chat::Websockets

map "/api/" do
    use Chat::APIController
end
use Rack::Static, :urls => [""],:root=> 'public', :index =>'index.html'
# use fourOhFour

run lambda {}



