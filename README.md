librato-node
============

librato-node is a Node.js client for Librato Metrics (http://metrics.librato.com/)

[![Build Status][travis-badge]][travis-link]
[![npm version][npm-badge]][npm-link]
[![mit license][license-badge]][license-link]

## Getting Started

### Install

    $ npm install librato-node

### Setup

Once `librato.start` is called, a worker will send aggregated stats to librato once every 60 seconds.

``` javascript
var librato = require('librato-node');
librato.configure({email: 'foo@example.com', token: 'ABC123'});
librato.start();

process.once('SIGINT', function() {
  librato.stop(); // stop optionally takes a callback
});
```

### Increment

Use `librato.increment` to track counts in librato.  On each flush, the incremented total for that period will be sent.

``` javascript
var librato = require('librato-node');

librato.increment('foo');
```

### Timing

Use `librato.timing` to track durations in librato.
On each flush, the library sends a `count`, `sum`, `min`, `max`, and `sum_squares` metric for that period
[so librato can accurately display multi-sample measurements](http://dev.librato.com/v1/post/metrics#gauge_specific).

``` javascript
var librato = require('librato-node');

librato.timing('foo', 500);
```

### Express

librato-node includes Express middleware to log the request count and response times for your app.  It also works in other Connect-based apps.

``` javascript
var express = require('express');
var librato = require('librato-node');

var app = express();
app.use(librato.middleware());
```

The key names the middleware uses are configurable by passing an options hash.

``` javascript
librato.middleware({requestCountKey: 'myRequestCount', responseTimeKey: 'myResponseTime'});
```

------

## Contributing

```
$ git clone https://github.com/goodeggs/librato-node && cd librato-node
$ npm install
$ npm test
```

------

## History

librato-node is largely based off of Librato's own [librato-rails](https://github.com/librato/librato-rails).  Visit that repository if you're running Ruby or for more information on Librato Metrics in general.

------

## License

[MIT][license-link]

[travis-badge]: http://img.shields.io/travis/goodeggs/librato-node/master.svg?style=flat
[travis-link]: https://travis-ci.org/goodeggs/librato-node

[npm-badge]: http://img.shields.io/npm/v/librato-node.svg?style=flat
[npm-link]: https://www.npmjs.org/package/librato-node

[license-badge]: http://img.shields.io/badge/license-mit-lightgrey.svg?style=flat
[license-link]: LICENSE.md
