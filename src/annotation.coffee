class Annotation

  constructor: ->
    @annotation_cache = {}

  flushTo: (queue) ->
    for name, value of @annotation_cache
      queue.push {name, value}
      delete @annotation_cache[name]

  annotation: (stream, title, options={}) ->
    a = { title: title }
    a[k] = v for k,v of options
    (@annotation_cache[stream] ?= []).push a

    
module.exports = Annotation
