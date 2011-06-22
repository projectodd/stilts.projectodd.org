---
title: Example Stomplets
layout: default
---

# Core Stomplets

Two Stomplets are available from the container to all applications: `SimpleQueueStomplet` and `SimpleTopicStomplet`.
Both assume any message that reaches them arrived on a valid destination, and will "provision" the destination
if necessary. 

## SimpleQueueStomplet

* [Source](https://github.com/projectodd/stilts/blob/master/stomplet-api/src/main/java/org/projectodd/stilts/stomplet/simple/SimpleQueueStomplet.java)

The `SimpleQueueStomplet` is a non-durable queue.  It is so non-durable that messages sent
to it when no subscribers exist are quietly dropped.  It tracks each subscription request
and chooses one lucky subscriber for each message sent to it.

Non-acknowledged messages (either explicit or due to disconnection) will be attempted to be redelivered
to some other lucky (or maybe the same!) subscriber.

## SimpleTopicStomplet

* [Source](https://github.com/projectodd/stilts/blob/master/stomplet-api/src/main/java/org/projectodd/stilts/stomplet/simple/SimpleTopicStomplet.java)

The `SimpleTopicStomplet` is a non-durable topic. Messages delivered to it are broadcast
back out to all subscribers (including the origin) at the time.  If no subscribers are 
connected, the message will be silently dropped.
