class CounterCache

  constructor: ->
    @cache = {}

  flushTo: (queue, noreset) ->
    for key, value of @cache
      [name, source] = key.split ';'
      queue.push unless source? then {name, value} else {name, value, source}
      delete @cache[key] unless noreset

  increment: (name, value=1) ->
    @cache[name] ?= 0
    @cache[name] += value


module.exports = CounterCache
