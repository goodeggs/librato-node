librato-node is a Node.js client for Librato Metrics (http://metrics.librato.com/)

[![Build Status](https://travis-ci.org/goodeggs/librato-node.png)](https://travis-ci.org/goodeggs/librato-node)

Getting Started
---------------

### Install

    $ npm install librato-node

### Setup

Once `librato.start` is called, a worker will send aggregated stats to librato once every 60 seconds.

``` coffee
librato = require 'librato-node'
librato.configure email: 'foo@example.com', token: 'ABC123'
librato.start()

process.once 'exit', ->
  librato.stop()
```

### Increment

Use `librato.increment` to track counts in librato.  On each flush, the incremented total for that period will be sent.

``` coffee
librato = require 'librato-node'

librato.increment 'foo'
```

### Timing

Use `librato.timing` to track durations in librato.
On each flush, the library sends a `count`, `sum`, `min`, `max`, and `sum_squares` metric for that period
[so librato can accurately display multi-sample measurements](http://dev.librato.com/v1/post/metrics#gauge_specific).

``` coffee
librato = require 'librato-node'

librato.timing 'foo', 500
```

### Annotation

Use `librato.annotation` to add an annotation in librato.
On each flush, the library sends the annotation(s) for that period.

``` coffee
librato = require 'librato-node'

librato.annotation 'stream', 'title'
```

### Express

librato-node includes Express middleware to log the request count and response times for your app.  It also works in other Connect-based apps.

``` coffee
express = require 'express'
librato = require 'librato-node'

app = express()
app.use librato.middleware()
```

The key names the middleware uses are configurable by passing an options hash.

``` coffee
librato.middleware requestCountKey: 'myRequestCount', responseTimeKey: 'myResponseTime'
```

Contributing
-------------

```
$ git clone https://github.com/goodeggs/librato-node && cd librato-node
$ npm install
$ npm test
```

History
-------

librato-node is largely based off of Librato's own [librato-rails](https://github.com/librato/librato-rails).  Visit that repository if you're running Ruby or for more information on Librato Metrics in general.

License
-------

librato-node is released under the [MIT License](http://www.opensource.org/licenses/MIT).

