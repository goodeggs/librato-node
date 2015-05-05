# Change Log

## [v4.0.0](https://github.com/goodeggs/librato-node/tree/v4.0.0) (2015-05-05)

[Full Changelog](https://github.com/goodeggs/librato-node/compare/v3.0.0...v4.0.0)

**Closed issues:**

- ms vs s mismatch in src/worker.coffee [\#38](https://github.com/goodeggs/librato-node/issues/38)

**Merged pull requests:**

- increment uses counters [\#40](https://github.com/goodeggs/librato-node/pull/40) ([bobzoller](https://github.com/bobzoller))

- fixes Worker.startTime [\#39](https://github.com/goodeggs/librato-node/pull/39) ([bobzoller](https://github.com/bobzoller))

- Use Librato 'counters' in addition to 'gauges' [\#37](https://github.com/goodeggs/librato-node/pull/37) ([mmoskal](https://github.com/mmoskal))

- Handle counters and single value gauges [\#27](https://github.com/goodeggs/librato-node/pull/27) ([jgeurts](https://github.com/jgeurts))

## [v3.0.0](https://github.com/goodeggs/librato-node/tree/v3.0.0) (2015-04-14)

[Full Changelog](https://github.com/goodeggs/librato-node/compare/v2.2.0...v3.0.0)

**Closed issues:**

- Counters are being recorded as gauges [\#36](https://github.com/goodeggs/librato-node/issues/36)

- occasional ETIMEDOUT errors [\#35](https://github.com/goodeggs/librato-node/issues/35)

## [v2.2.0](https://github.com/goodeggs/librato-node/tree/v2.2.0) (2015-04-08)

[Full Changelog](https://github.com/goodeggs/librato-node/compare/v2.1.1...v2.2.0)

**Closed issues:**

- Control the resolution/period  [\#20](https://github.com/goodeggs/librato-node/issues/20)

## [v2.1.1](https://github.com/goodeggs/librato-node/tree/v2.1.1) (2015-03-19)

[Full Changelog](https://github.com/goodeggs/librato-node/compare/v2.1.0...v2.1.1)

## [v2.1.0](https://github.com/goodeggs/librato-node/tree/v2.1.0) (2015-03-17)

[Full Changelog](https://github.com/goodeggs/librato-node/compare/v2.0.0...v2.1.0)

**Merged pull requests:**

- Allow you to configure the flush period [\#30](https://github.com/goodeggs/librato-node/pull/30) ([kevinburke](https://github.com/kevinburke))

- Added support for metric sources. [\#24](https://github.com/goodeggs/librato-node/pull/24) ([crito](https://github.com/crito))

## [v2.0.0](https://github.com/goodeggs/librato-node/tree/v2.0.0) (2015-03-12)

[Full Changelog](https://github.com/goodeggs/librato-node/compare/v1.3.2...v2.0.0)

**Closed issues:**

- Is there a way to publish statistics that aren't counters or durations? [\#25](https://github.com/goodeggs/librato-node/issues/25)

**Merged pull requests:**

- `timing` measures function duration [\#28](https://github.com/goodeggs/librato-node/pull/28) ([bobzoller](https://github.com/bobzoller))

- Add documentation about the measure function [\#26](https://github.com/goodeggs/librato-node/pull/26) ([demands](https://github.com/demands))

- Support sources for increment and timing. [\#5](https://github.com/goodeggs/librato-node/pull/5) ([crito](https://github.com/crito))

## [v1.3.2](https://github.com/goodeggs/librato-node/tree/v1.3.2) (2015-02-19)

[Full Changelog](https://github.com/goodeggs/librato-node/compare/v1.3.1...v1.3.2)

**Fixed bugs:**

- ::flush callback isn't called if librato fails because credentials are missing [\#23](https://github.com/goodeggs/librato-node/issues/23)

**Merged pull requests:**

- improve docs [\#22](https://github.com/goodeggs/librato-node/pull/22) ([bobzoller](https://github.com/bobzoller))

## [v1.3.1](https://github.com/goodeggs/librato-node/tree/v1.3.1) (2015-02-18)

[Full Changelog](https://github.com/goodeggs/librato-node/compare/v1.3.0...v1.3.1)

**Closed issues:**

- process.once\('exit', function\(\) {librato.stop\(\); }\) is unsafe. [\#18](https://github.com/goodeggs/librato-node/issues/18)

## [v1.3.0](https://github.com/goodeggs/librato-node/tree/v1.3.0) (2015-02-11)

[Full Changelog](https://github.com/goodeggs/librato-node/compare/v1.2.2...v1.3.0)

**Closed issues:**

- librato-node should let you use it more transactionally [\#15](https://github.com/goodeggs/librato-node/issues/15)

**Merged pull requests:**

- Accept a callback for ::flush [\#21](https://github.com/goodeggs/librato-node/pull/21) ([adborden](https://github.com/adborden))

## [v1.2.2](https://github.com/goodeggs/librato-node/tree/v1.2.2) (2015-01-23)

[Full Changelog](https://github.com/goodeggs/librato-node/compare/v1.2.1...v1.2.2)

## [v1.2.1](https://github.com/goodeggs/librato-node/tree/v1.2.1) (2015-01-23)

[Full Changelog](https://github.com/goodeggs/librato-node/compare/v1.2.0...v1.2.1)

**Closed issues:**

- librato.increment ignores value [\#19](https://github.com/goodeggs/librato-node/issues/19)

## [v1.2.0](https://github.com/goodeggs/librato-node/tree/v1.2.0) (2015-01-02)

[Full Changelog](https://github.com/goodeggs/librato-node/compare/v1.1.0...v1.2.0)

**Closed issues:**

- Can you push the latest to NPM registry? [\#14](https://github.com/goodeggs/librato-node/issues/14)

## [v1.1.0](https://github.com/goodeggs/librato-node/tree/v1.1.0) (2014-12-17)

**Closed issues:**

- Show examples in JavaScript not coffee script [\#11](https://github.com/goodeggs/librato-node/issues/11)

- translate unsupported metric name characters to \_ [\#6](https://github.com/goodeggs/librato-node/issues/6)

- clock not defined? [\#1](https://github.com/goodeggs/librato-node/issues/1)

**Merged pull requests:**

- Removing d3 dependency [\#13](https://github.com/goodeggs/librato-node/pull/13) ([aez](https://github.com/aez))

- Show examples in javascript [\#12](https://github.com/goodeggs/librato-node/pull/12) ([adborden](https://github.com/adborden))

- sanitize the name of the metric sent to timing\(\) and increment\(\)... [\#7](https://github.com/goodeggs/librato-node/pull/7) ([cainus](https://github.com/cainus))

- Update method name [\#4](https://github.com/goodeggs/librato-node/pull/4) ([iltempo](https://github.com/iltempo))

- Don't use literate coffeescript while compiling for tests [\#3](https://github.com/goodeggs/librato-node/pull/3) ([demands](https://github.com/demands))

- Use librato's modern aggregations api [\#2](https://github.com/goodeggs/librato-node/pull/2) ([demands](https://github.com/demands))

- fix tests [\#8](https://github.com/goodeggs/librato-node/pull/8) ([nesQuick](https://github.com/nesQuick))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*