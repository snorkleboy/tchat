class Rooms
    def [](room)
        @rooms[room]
    end
    def rooms=(obj)
        @rooms = obj
    end
    def rooms
        @rooms
    end
    def initialize(senduserlistToSisterProc,senduserlistToClientsProc = Proc.new{})
        @rooms = Hash.new{|h,v| h[v]=Array.new()}
        @rooms['general']=[]
        @sendUserListToSister = senduserlistToSisterProc
        @senduserlistToClientsProc = senduserlistToClientsProc
        @foreignRooms = {}
    end
    def push(user)
        @rooms[user.room].push(user)
        @sendUserListToSister.call()
        @senduserlistToClientsProc.call()
    end

    def changeRoom(user,newroom)
        oldroom = user.room
        @rooms[oldroom].delete(user)
        @rooms.delete(oldroom) if (oldroom != 'general' && @rooms[oldroom].empty?)
        @rooms[newroom] = @rooms[newroom].push(user)
        user.room = newroom
        @sendUserListToSister.call()
        @senduserlistToClientsProc.call()
    end

    def delete(user)
        @rooms[user.room].delete(user)
        @rooms.delete(user.room) if (@rooms[user.room].empty?)
        @sendUserListToSister.call()
        @senduserlistToClientsProc.call()
    end
    def users()
        @rooms.values.flatten
    end
    def allUsers()
        users().concat(@foreignRooms.values.flatten).map{|user|{'name'=> user['name'],'room'=>user['room']} }
    end
    def allUsersString()
        "TCPusers :\n #{@rooms.users().map{|user| user[:name]}} \n Other Users:\n#{@foreignRooms.values.flatten.map{|user|user['name']}}"
    end

    def allRooms()
        tempCopy = {}
        @foreignRooms.each_pair{|k,v| tempCopy[k]=v.map{|client| client}}
        tempCopy = tempCopy.merge(@rooms){|k,v1,v2| v1.concat(v2)}
        tempCopy
    end

    def keys()
        @rooms.keys
    end
    def values
        @rooms.values
    end

    def newForeignRooms(rooms)
        @foreignRooms = rooms
        @senduserlistToClientsProc.call()
    end
    def foreignRooms
        @foreignRooms
    end
end