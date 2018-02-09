

def postUser(params)
    begin
       p ['post user ',params]
        #set uri
        uri = URI.parse("http://localhost:6000/user")
        res = Net::HTTP.post_form(uri, params)

        if res.is_a?(Net::HTTPSuccess)
            return [true, res.body]
        else
            return [false,res.body]
        end
    rescue => exception
       return [false,exception]
    end
end

    



begin
    params = JSON.parse(request.body.read)
    p ['api controller, login',params]
    #set uri
    uri = URI.parse("http://localhost:6000/login")
    res = Net::HTTP.post_form(uri, params)
    if res.is_a?(Net::HTTPSuccess)
            [200, { 'Content-Type' => 'application/json' }, [res.body]]
    else
            [400, { 'Content-Type' => 'application/json' },[res.body]]
    end
    
rescue => exception
    [400, { 'Content-Type' => 'application/json' },[ JSON.generate({'error'=>exception})]]
end


                    begin
    params = JSON.parse(request.body.read)
    p ['api controller, user check',params]
    #set uri
    uri = URI.parse("http://localhost:6000/isuser")
    res = Net::HTTP.post_form(uri, params)
    if res.is_a?(Net::HTTPSuccess)
            [200, { 'Content-Type' => 'application/json' }, [res.body]]
    else
            [400, { 'Content-Type' => 'application/json' },[res.body]]
    end
    
rescue => exception
    [400, { 'Content-Type' => 'application/json' },[ JSON.generate({'error'=>exception})]]
end


                    begin
    params = JSON.parse(request.body.read)
    p ['api controller, token check',params]
    #set uri
    uri = URI.parse("http://localhost:6000/tokencheck")
    res = Net::HTTP.post_form(uri, params)
    if res.is_a?(Net::HTTPSuccess)
            [200, { 'Content-Type' => 'application/json' }, [res.body]]
    else
            [400, { 'Content-Type' => 'application/json' },[res.body]]
    end
    
rescue => exception
    [400, { 'Content-Type' => 'application/json' },[ JSON.generate({'error'=>exception})]]
end