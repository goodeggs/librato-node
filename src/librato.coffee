{EventEmitter} = require 'events'
Client = require './client'
Worker = require './worker'
Collector = require './collector'
middleware = require './middleware'

{collector, client, worker, config} = {}

librato = new EventEmitter()

librato.configure = (newConfig) ->
  config = newConfig
  collector = new Collector()
  client = new Client config
  worker = new Worker job: librato.flush
  
librato.increment = (name) ->
  collector.increment(name)

librato.timing = (name, valueMs) ->
  collector.timing(name, valueMs)
    
librato.annotation = (stream, title, options={}) ->
  collector.annotate(stream, title, options)

librato.start = ->
  worker.start()
    
librato.stop = ->
  worker.stop()
  librato.flush()
    
librato.flush = ->
  gauges = []
  collector.flushTo gauges
  measurement.source = config.source for measurement in gauges
  if gauges.length
    client.send {gauges}, (err) ->
      librato.emit 'error', err if err?
  annotations = []
  collector.flushToAnnotation annotations
  if annotations.length
    for a in annotations
      for v in a.value
        client.send {annotation: true, name: a.name, body: v}, (err) ->
          librato.emit 'error', err if err?

librato.middleware = middleware(librato)


module.exports = librato

