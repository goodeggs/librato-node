# Connect/Express middleware that records request count and response times.
# based on connect logger middleware https://github.com/senchalabs/connect/blob/master/lib/middleware/logger.js

module.exports = (librato) ->
  return ({requestCountKey, responseTimeKey}={}) ->
    return (req, res, next) =>
      req._libratoStartTime = new Date

      # mount safety
      return next() if req._librato?

      # flag as librato
      req._librato = true

      librato.increment(requestCountKey ? 'requestCount')

      end = res.end
      res.end = (chunk, encoding) =>
        res.end = end
        res.end(chunk, encoding)
        librato.timing(responseTimeKey ? 'responseTime', new Date - req._libratoStartTime)

      next()

