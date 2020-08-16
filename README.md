# Fluentdex

**This is just an experiment repo. The eventual goal is to create a configurable library.**

A Fluentd OUTPUT server that implements Fluentd's [Forward output specification](https://github.com/fluent/fluentd/wiki/Forward-Protocol-Specification-v1#eventtime-ext-format). In other words, a server that receives messages from FluentD. For sending logs to FluentD, check out projects like [Fluentd logger backend](https://github.com/jackjoe/logger-fluentd-backend).

This repo is largely based on wojtekmach's [Fluentx](https://github.com/wojtekmach/fluentx).

## Installation

Assumes that you've setup and configured Fluentd (refer below).

1. Clone repo
2. Start server with `iex -S mix`

## FluentD Setup

There are many ways to install Fluentd such as td-agent or using Ruby. Personally I found the [Fluentd UI](https://docs.fluentd.org/deployment/fluentd-ui) to be quite useful. Here are the steps that worked for me:

1. Install Fluentd with Ruby 'gem install fluentd'
2. Install Fluentd UI with instructions [here](https://github.com/fluent/fluentd-ui)

Note: I originally installed td-agent instead, but it didn't jive with the UI version.

### Fluentd Config

**This is an example config file (ports may vary) for testing**

```
<source>
  # http://docs.fluentd.org/articles/in_forward
  #
  # port 24224 is what my logger backend is using: https://github.com/jackjoe/logger-fluentd-backend
  @type forward
  port 24224
</source>

<match **>
  # Matches ALL tags and:
  #
  # 1. Sends to stdout (for debug)
  # 2. Forwards to a TCP port
  #
  @type copy
  <store>
    @type stdout
  </store>
  <store>
    @type forward
  	send_timeout 60s
  	recover_wait 10s
  	hard_timeout 60s

  	<server>
      name myserver1
      host 0.0.0.0
      port 24230
      weight 60
    </server>
    <buffer>
      # Send messages every _ seconds
      flush_interval 2s
    </buffer>
  </store>
</match>
```

## References

- [Documentation for output forward](https://docs.fluentd.org/output/forward)
- [Ranch Protocol Handler](https://ninenines.eu/docs/en/ranch/2.0/guide/protocols/)
- [Ranch with Elixir tutorial](http://dbeck.github.io/Using-Ranch-From-Elixir/)
- [Msgpax docs](https://hexdocs.pm/msgpax/Msgpax.html)
- [Fluentd logger backend](https://github.com/jackjoe/logger-fluentd-backend)



