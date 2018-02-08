
def migrate(db)
    begin 
        db.drop_table?(:room_user_join)
        db.drop_table?(:user)
        db.drop_table?(:room)
             
        db.create_table :user do
            primary_key :id
            String :username
            String :password_digest
            String :password
        end

        
        db.create_table :room do
            primary_key :id
            String :name
        end

        db.create_table :room_user_join do
            primary_key :id
            foreign_key :user_id, :user
            foreign_key :room_id, :room
        end

    rescue => e
        return [false,e]
    end
        return [true,nil]
end
