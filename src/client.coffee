request = require 'request'
util = require 'util'
packageJson = require '../package.json'

class Client
  endpoint: 'https://metrics-api.librato.com/v1'

  constructor: ({email, token, simulate}) ->
    if (not email or not token) and not simulate
      console.warn "librato-node metrics disabled: no email or token provided."
    else
      @_authHeader = 'Basic ' + new Buffer("#{email}:#{token}").toString('base64')
    
  send: (json, cb) ->
    return unless @_authHeader
    requestOptions =
      method: 'POST'
      uri: "#{@endpoint}/metrics"
      json: json
      headers:
        authorization: @_authHeader
        'user-agent': 'librato-node/'+ packageJson.version
        
    request requestOptions, (err, res, body) ->
      return cb(err) if err?
      if res.statusCode > 399 or body?.errors?
        return cb(new Error("Error sending to Librato: #{util.inspect(body)} (statusCode: #{res.statusCode})"))
      return cb(null, body)

    
module.exports = Client

