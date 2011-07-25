---
title: Stilts STOMP Framework
layout: default
---

[Message Conduit Framework]: /stilts-conduit/
[JBoss Netty]: http://www.jboss.org/netty

# Overview

At the base of all the Stilts projects is the protocol handlers for STOMP 1.1,
implemented using [JBoss Netty].

# Components

The implementation includes basic reusable components, such as frame and message
encoders and decoders.  Additionally, it provides a contract for interacting
with a `StompProvider`:

    package org.projectodd.stilts.stomp.spi;

    import org.projectodd.stilts.stomp.Headers;
    import org.projectodd.stilts.stomp.StompException;
    
    public interface StompProvider {
        StompConnection createConnection(TransactionalAcknowledgeableMessageSink messageSink, Headers headers) throws StompException;
    }

The [Message Conduit Framework] is a `StompProvider` which adapts the API to a simpler
abstraction in which transactions are handled for you. But others, such as native-JMS, 
could easily be created.

# Server

You may easily wire up your `StompProvider` to the transport server:

    StompServer<MyStompProvider> server = new StompServer<MyStompProvider>();
    server.setStompProvider( new MyStompProvider() );
    server.start();
