class CounterCache

  constructor: ->
    @cache = {}

  flushTo: (queue) ->
    for key, value of @cache
      [name, source] = key.split ';'
      queue.push unless source? then {name, value} else {name, value, source}

  increment: (name, value=1) ->
    @cache[name] ?= 0
    @cache[name] += value


module.exports = CounterCache
