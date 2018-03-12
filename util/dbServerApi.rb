
require 'uri'
require 'net/http'

def postUser(params)
  p ['DBAPI controller', 'post user ', params]
  # set uri
  uri = URI.parse('http://localhost:6000/user')
  res = Net::HTTP.post_form(uri, params)
  result(res)
rescue StandardError => exception
  [false, exception]
end

def postSession(params)
  p ['DBAPI controller, post session', params]
  # set uri
  uri = URI.parse('http://localhost:6000/login')
  res = Net::HTTP.post_form(uri, params)
  result(res)
rescue StandardError => exception
  [false, exception]
end

def checkUser(params)
  p ['DBAPI controller, user check', params]
  # set uri
  uri = URI.parse('http://localhost:6000/isuser')
  res = Net::HTTP.post_form(uri, params)
  result(res)
rescue StandardError => exception
  [false, exception]
end

def tokenCheck(params)
  p ['DBAPI controller, token check', params]
  # set uri
  uri = URI.parse('http://localhost:6000/tokencheck')
  res = Net::HTTP.post_form(uri, params)
  result(res)
rescue StandardError => exception
  [false, exception]
end

def result(res)
  [ok?(res), res.body]
end

def ok?(res)
  res.is_a?(Net::HTTPSuccess)
end
