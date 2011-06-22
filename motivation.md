---
title: Motivation
layout: default
---

# Why do we need this?

With the advent of HTML5 WebSockets (and somewhat starting with the earlier comet work), 
developers have been working on hooking back-end systems all the way to the browser.

Initial suggestions have been to use some sort of message-broker solution.  These are either
self-contained client/server pieces with their own pub/sub semantics, or shims atop your
traditional message-broker, such as HornetQ, exposing them to WebSocket clients.

Self-contained brokers meant specifically for the web tier require additional work to
perform the actual bridging into back-end systems.  Laying WebSockets directly onto your 
enterprise broker possibly opens up many security issues.

# Messaging as an API

For the longest time, messaging was something your system used internally.  You might
have used a proprietary broker with a proprietary wire protocol, and nobody would care,
because nobody but yourself consumed it.

With WebSockets, the boundaries of the messaging are able to push even further out,
getting closer to the end consumer, no longer contained within your firewalls.

STOMP is an awesome model and wire protocol for passing messages between parties,
without implying any particular pub/sub model.  Instead of simply exposing your
existing internal message broker through a transliteration layer to the STOMP 
wire format, we have an opportunity to treat the STOMP end-point as an explicitly-designed
API.  

When clients need request/response interaction, they use HTTP, which might ultimately
scribble some rows in the database.  When they want to perform asynchronous requests,
they use STOMP (over WebSockets, or not), which may (or may not) end up interacting
with bits of your system, which may (or may not) involve your back-end message broker.

We don't typically simply expose our database over REST to the end user (unless you're using
Mongo, poorly), why should we do similar with our messaging back-ends?

# Native STOMP

HTTP is not simply a way to expose our database to the web, so STOMP should not be thought
of as a way to expose our message broker to web-like clients.  We take the opportunity to place
**controllers** (of MVC fame) between the user and the database.  With STOMP as a _native_ protocol
for a server, we can also now place **controllers** between the possibly-untrusted messaging client
and our tidy back-end systems.

# Stomplets

Just as the Java Servlet API provides a framework for writing controllers for HTTP, the Stomplet API
allows easily writing controllers for messaging endpoints.
