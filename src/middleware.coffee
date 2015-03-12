# Connect/Express middleware that records request count, response times, and status codes (1xx - 5xx).
# based on connect logger middleware https://github.com/senchalabs/connect/blob/master/lib/middleware/logger.js

module.exports = (librato) ->
  return ({requestCountKey, responseTimeKey, statusCodeKey}={}) ->
    return (req, res, next) ->
      req._libratoStartTime = new Date

      # mount safety
      return next() if req._librato?

      # flag as librato
      req._librato = true

      librato.increment(requestCountKey ? 'requestCount')

      end = res.end
      res.end = (chunk, encoding) ->
        res.end = end
        res.end(chunk, encoding)
        librato.measure(responseTimeKey ? 'responseTime', new Date - req._libratoStartTime)
        librato.increment("#{statusCodeKey ? 'statusCode'}.#{Math.floor(res.statusCode / 100)}xx")

      next()

