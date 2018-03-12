# if msg comes in with '\' as first charecter it gets sent to this controller
# msg syntax is \'command' 'parameter'
# like '\croom general' to change to room 'general'
class ClientController
  def self.act(msg, originator, rooms)
    command = msg.split(' ')
    command[0] = command[0][1..-1]
    p ['client command', command, originator]
    case command[0]
    when 'help' || 'h'
      originator.client.puts [
        ['\\croom {room}', 'change rooms to {room}'],
        ['\\see', 'see all rooms and users'],
        ['\\seeroom', 'see users in same room']
      ]
    when 'croom'
      rooms.changeRoom(originator, command[1])
      originator.client.puts "changed room to #{command[1]}"
    when 'see'
      originator.client.puts rooms.allUsers.sort_by { |a| a['room'] }
    when 'seeroom'
      originator.client.puts [originator.room, rooms[originator.room].map(&:name)]
    else
      p 'unknown client command'
      originator.puts 'SERVER WARNING:unknown command'
    end
  end
end
