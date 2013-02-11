
class CounterCache
  
  constructor: ->
    @cache = {}
    
  flushTo: (queue) ->
    for name, value of @cache
      queue.push {name, value}
      delete @cache[name]
    
  increment: (name, value=1) ->
    @cache[name] ?= 0
    @cache[name] += value


module.exports = CounterCache

