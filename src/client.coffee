request = require 'request'
util = require 'util'
packageJson = require '../package.json'
_ = require 'lodash'

class Client
  endpoint: 'https://metrics-api.librato.com/v1'

  constructor: ({email, token, simulate, requestOptions}) ->
    if not email or not token
      console.warn "librato-node metrics disabled: no email or token provided." unless simulate
    else
      @_requestOptions = _.defaults (requestOptions or {}),
        method: 'POST'
        uri: "#{@endpoint}/metrics"
        headers: {}
      @_requestOptions.headers = _.defaults @_requestOptions.headers,
        authorization: 'Basic ' + new Buffer("#{email}:#{token}").toString('base64')
        'user-agent': "librato-node/#{packageJson.version}"

  send: (json, cb) ->
    return process.nextTick(cb) unless @_requestOptions?

    requestOptions = _.extend {}, @_requestOptions, {json}

    request requestOptions, (err, res, body) ->
      return cb(err) if err?
      if res.statusCode > 399 or body?.errors?
        return cb(new Error("Error sending to Librato: #{util.inspect(body, depth: null)} (statusCode: #{res.statusCode})"))
      return cb(null, body)

module.exports = Client

