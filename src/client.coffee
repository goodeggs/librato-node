request = require 'request'
Q = require 'q'
util = require 'util'
packageJson = require '../package.json'

class Client
  endpoint: 'https://metrics-api.librato.com/v1'

  constructor: ({email, token}) ->
    if not email or not token
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
    deferred = Q.defer()

    request requestOptions, (err, res, body) ->
      return deferred.reject(err) if err?
      if res.statusCode > 399 or body?.errors?
        deferred.reject(new Error("Error sending to Librato: #{util.inspect(body)} (statusCode: #{res.statusCode})"))
      else
        deferred.resolve(body)
      deferred.promise
    
module.exports = Client

