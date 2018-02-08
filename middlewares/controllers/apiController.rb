require 'rack'
require 'json'
require 'sequel'
require_relative '../../db/migration/initialMigration'
module Chat
    class APIController
        def initialize(app)
            @app=app
            db = Sequel.connect(adapter: :postgres, user: 'snorkleboy', host: 'localhost', port: 5432, database: 'chat', max_connections: 10, password:'9252623278')
            p ['connected to postgreSQL',db]

# DB.create_table :items do
#   primary_key :id
#   String :name
#   Float :price
# end

# items = DB[:items] # Create a dataset

# # Populate the table
# items.insert(:name => 'abc', :price => rand * 100)
# items.insert(:name => 'def', :price => rand * 100)
# items.insert(:name => 'ghi', :price => rand * 100)

# # Print out the number of records
# puts "Item count: #{items.count}"

# # Print out the average price
# puts "The average price is: #{items.avg(:price)}"

            @routes = routes=Rack::URLMap.new(
                "/test" => lambda{|env|
                    [200, { 'Content-Type' => 'application/json' }, [ JSON.generate({"db"=>db})]]
                },

                '/route' => lambda{|env|
                    [200, { 'Content-Type' => 'application/json' }, [JSON.generate({ "route"=>['route',1,2,3,4,5,6,7] })]]
                },
                '/migrate'=> lambda{|env|
                    result =migrate(db)
                    if (result[0])
                        p result
                        return [200, { 'Content-Type' => 'application/json' }, [JSON.generate({'status'=>'migrated'})]]
                    else
                        # return [200, { 'Content-Type' => 'application/json' }, ['error']]
                        [400, { 'Content-Type' => 'application/json' }, [JSON.generate({'error'=>result[1]})]]
                    end
                    
                },
                '/testpost' =>lambda{|env|
                    begin
                        rooms = db[:room] # Create a dataset
                        # Populate the table
                        rooms.insert(:name => 'abc')
                        rooms.insert(:name => 'def')
                        rooms.insert(:name => 'room3')
                        [200, { 'Content-Type' => 'application/json' },[JSON.generate( "rooms count"=>rooms.count)]]
                    rescue => exception
                        [400, { 'Content-Type' => 'application/json' },[ JSON.generate({'error'=>exception})]]
                    end
                    


                },
                '/testget' =>lambda{|env|
                    begin
                        rooms = db[:room]
                        [200, { 'Content-Type' => 'application/json' }, [JSON.generate(rooms.all)]]
                    rescue => exception
                        [400, { 'Content-Type' => 'application/json' },[ JSON.generate({'error'=>exception})]]
                        
                    end
                    
            }
            )
        end

        def call(env)
            p '',['api controller'],''
            @routes.call(env)
        end
    end
end 
