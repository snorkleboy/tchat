def get_username(client)
    while(true)
        client.puts "please enter a username.to see who is on enter 's'. To get on as a guest enter guest"
        msg = client.gets.chomp
        p "client username input: #{msg}"
        if (msg == 's')
            client.puts @rooms.allUsers()
        else
            return msg
        end
    end
end
def get_password(client,registered,username)
    while(true)
        display = registered ?
            "Hi, #{username},please enter a password. or press Q to sign in as different user"
        : 
            "hi new user, enter a password to make a new account, or enter q to enter a different username"
        client.puts display
        msg = client.gets.chomp
        p "client password input: #{msg}"
        if (msg == 'q' || msg == 'Q')
            return false
        else    
            return msg
        end
    end
end
def signIn(client,username,password)
    res = postUser({username:username,password:password})
    if (res[0])
        client.puts 'signed in!'
        return true
    else
        client.puts "error! #{res[1]}"
        return false
    end
end
def login(client,username,password)
    res = postSession({username:username,password:password})
    if (res[0])
        client.puts 'logged in!'
        return true
    else
        client.puts "error! #{res[1]}"
        return false
    end
end

def guest(client)
    res = postSession({username:'guest',password:'password'})
    if (res[0])
        name = JSON.parse(res[1])['username']
        client.puts "logged in as #{name}!"
        return name
    else
        client.puts "error! #{res[1]}"
        return false
    end
end