---
title: Stilts Foundation
layout: default
---

[Circus]: /circus/
[JBoss Netty]: http://www.jboss.org/netty

# Overview

At the base of all the Stilts projects is the protocol handlers for STOMP 1.1,
implemented using [JBoss Netty].

# Components

The implementation includes basic reusable components, such as frame and message
encoders and decoders.  Additionally, it provides a contract for interacting
with a `StompProvider`:

    package org.projectodd.stilts.stomp.spi;

    import org.projectodd.stilts.StompException;
    
    public interface StompProvider {
        StompConnection createConnection(AcknowledgeableMessageSink messageSink, 
                                         Headers headers) throws StompException;
    }

The [Circus] server is a `StompProvider`, but others, such as native-JMS, could easily be
created.

