---
title: Clown Shoes
layout: default
---

[JBoss Weld]: http://seamframework.org/Weld

# Overview

The Stilts Clown Shoes server provides an environment for running your
[Stomplets](/stomplet/).

The Clown Shoes server builds upon the Stilts Circus framework, adding
in support for the Stomplet API and integrating [JBoss Weld].

# Usage

To use, simply fill a directory of your Jars full of Stomplets and CDI components,
as many resource-adapter archives you need, and a `stomplet.conf` and run the
`clownshoes` binary with 1 argument, pointing to that directory.

    $ clownshoes ./path/to/my/app


