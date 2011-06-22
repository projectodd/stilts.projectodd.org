---
title: Development Notes
layout: default
---

# Known Deficiencies

## Too much logging

I'm notoriously bad with log statements.

## Need a threading model

Currently the stomplet container borrows Netty's I/O thread when dispatching
inbound messages and subscriptions.  An executor handler in the pipeline
before message/subscription dispatch would be handy.

## No version negotiation

Client and server all assume everyone's happily speaking STOMP 1.1

## No virtual-host support

A host-handler is required in the Netty pipeline to dispatch to a specific
`StompProvider` based upon host.  It should be possible to run a Clown Shoes
stomplet server on one virtual-host, with a Circus-JMS provider on another,
on the same socket:port.

## Extensions to STOMP 1.1

Should investigate what Apache Apollo is doing, in terms of extending
with headers.  Anything common we can agree on?

* [http://activemq.apache.org/apollo/](http://activemq.apache.org/apollo/)
