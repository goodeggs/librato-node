
class CounterCache
  
  constructor: ->
    @cache = {}
    
  flushTo: (queue) ->
    for metric, value of @cache
      [name, source] = metric.split(';')
      console.log(metric, name, source)
      if source? then queue.push {name, value, source}
      else queue.push {name, value}
      delete @cache[metric]
    
  increment: (name, value=1) ->
    @cache[name] ?= 0
    @cache[name] += value


module.exports = CounterCache

