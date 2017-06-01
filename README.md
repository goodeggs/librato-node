librato-node
============

librato-node is a Node.js client for Librato Metrics (http://metrics.librato.com/)

[![build status][travis-badge]][travis-link]
[![npm version][npm-badge]][npm-link]
[![mit license][license-badge]][license-link]
[![we're hiring][hiring-badge]][hiring-link]

## Getting Started

### Install

    $ npm install librato-node

### Setup

Once `librato.start` is called, a worker will send aggregated stats to Librato once every 60 seconds.

``` javascript
var librato = require('librato-node');

librato.configure({email: 'foo@example.com', token: 'ABC123'});
librato.start();

process.once('SIGINT', function() {
  librato.stop(); // stop optionally takes a callback
});

// Don't forget to specify an error handler, otherwise errors will be thrown
librato.on('error', function(err) {
  console.error(err);
});
```

### Increment

Use `librato.increment` to track counts in Librato.  On each flush, the incremented total for that period will be sent.

``` javascript
var librato = require('librato-node');

librato.increment('foo');                     // increment by 1
librato.increment('foo', 2);                  // increment by 2
librato.increment('foo', 2, {source: 'bar'}); // custom source
```

### Measurements

You can send arbitrary measurements to Librato using `librato.measure`. These will be sent as gauges. For example:

``` javascript
var librato = require('librato-node');

librato.measure('member-count', 2001);
librato.measure('response-time', 500);
librato.measure('foo', 250, {source: 'bar'}); // custom source
```

### Timing

Use `librato.timing` to measure durations in Librato. You can pass it a synchronous function or an asynchronous function (it checks the function arity).  For example:

``` javascript
var librato = require('librato-node');

// synchronous
librato.timing('foo', function() {
  for (var i=0; i<50000; i++) console.log(i);
});

// async without a callback
librato.timing('foo', function(done) {
  setTimeout(done, 1000);
});

// async with a callback
var workFn = function(done) {
  setTimeout(function() {
    done(null, 'foo');
  });
};
var cb = function(err, res) {
  console.log(res); // => 'foo'
};
librato.timing('foo', workFn, cb);
librato.timing('foo', workFn, {source: 'bar'}, cb); // all timing calls also accept a custom source
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

### Advanced

By default the librato-node worker publishes data every 60 seconds. Configure
this value by passing a `period` argument to the `configure` hash.

```javascript
var librato = require('librato-node');
librato.configure({email: 'foo@bar.com', token: 'ABC123', period: 5000})
```

### Request Options

You can pass additional options for the HTTP POST to Librato using the `requestOptions` parameter.  See [request/request](https://github.com/request/request) for a complete list of options. For example, to configure a timeout:

```javascript
var librato = require('librato-node');
librato.configure({email: 'foo@bar.com', token: 'ABC123', requestOptions: {timeout: 250}})
```

By default librato-node will retry up to 3 times on connection failures and 5xx responses using an exponential backoff strategy with a 100ms base. These defaults can be overridden using the `requestOptions` paramter. See [requestretry](https://github.com/FGRibreau/node-request-retry) for a list of options. For example, to limit to a single attempt:

```javascript
var librato = require('librato-node');
librato.configure({email: 'foo@bar.com', token: 'ABC123', requestOptions: {maxAttempts: 1}})
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

librato-node is largely based off of Librato's own [librato-rack](https://github.com/librato/librato-rack).  Visit that repository if you're running Ruby or for more information on Librato Metrics in general.

------

## License

[MIT][license-link]

[travis-badge]: http://img.shields.io/travis/goodeggs/librato-node/master.svg?style=flat-square
[travis-link]: https://travis-ci.org/goodeggs/librato-node
[npm-badge]: http://img.shields.io/npm/v/librato-node.svg?style=flat-square
[npm-link]: https://www.npmjs.org/package/librato-node
[license-badge]: http://img.shields.io/badge/license-mit-blue.svg?style=flat-square
[license-link]: LICENSE.md
[hiring-badge]: https://img.shields.io/badge/we're_hiring-yes-brightgreen.svg?style=flat-square
[hiring-link]: http://goodeggs.jobscore.com/?detail=Open+Source&sid=161
