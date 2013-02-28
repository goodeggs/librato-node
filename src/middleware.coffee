# Connect/Express middleware that records request count, response times, and status codes (1xx - 5xx).
# based on connect logger middleware https://github.com/senchalabs/connect/blob/master/lib/middleware/logger.js

safeParseInt = (val) ->
  try
    parseInt(val, 10)
  catch e
    null

measureHerokuHeaders = (librato, req) ->
  if (val = safeParseInt(req.headers['x-heroku-dynos-in-use']))?
    librato.measure 'heroku.dynos', val
  if (val = safeParseInt(req.headers['x-heroku-queue-depth']))?
    librato.measure 'heroku.queueDepth', val
  if (val = safeParseInt(req.headers['x-heroku-queue-wait-time']))?
    librato.measure 'heroku.queueWaitTime', val

module.exports = (librato) ->
  return ({requestCountKey, responseTimeKey, statusCodeKey}={}) ->
    return (req, res, next) ->
      req._libratoStartTime = new Date

      # mount safety
      return next() if req._librato?

      # flag as librato
      req._librato = true

      librato.increment(requestCountKey ? 'requestCount')
      
      # various forwarding proxies add this header
      if req.headers['x-request-start']? and (val = safeParseInt(req.headers['x-request-start']))?
        librato.measure 'requestWaitTime', (new Date().getTime() - val)
      
      measureHerokuHeaders(librato, req) if req.headers['x-heroku-dynos-in-use']?

      end = res.end
      res.end = (chunk, encoding) ->
        res.end = end
        res.end(chunk, encoding)
        librato.timing(responseTimeKey ? 'responseTime', new Date - req._libratoStartTime)
        librato.increment("#{statusCodeKey ? 'statusCode'}.#{Math.floor(res.statusCode / 100)}xx")

      next()

