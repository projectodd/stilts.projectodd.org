---
title: Circus Framework
layout: default
---

[Clown Shoes]: /clown-shoes/
[JBoss IronJacamar]: http://www.jboss.org/ironjacamar
[JBoss Transactions]: http://www.jboss.org/jbosstm

# Overview

The Circus Stomp Framework aims to separate transaction-handling aspects
of the STOMP protocol from the message- and subscription-handling portion.

Circus accomplishes this by integrating [JBoss IronJacamar] along with
[JBoss Transactions] and providing support for XA-capable `MessageConduit`
implementations.

For non-XA resources (such as the [Clown Shoes] server), a psuedo-XA
adapter is provided, making it even easier to write message conduits.

# SPI

Implementors should work with this SPI.  The Circus container will instantiate
(using a `MessageConduitFactory`) a conduit for each client connection, for the
lifespace of the connection.

    package org.projectodd.stilts.circus;

    import org.projectodd.stilts.StompMessage;
    import org.projectodd.stilts.stomp.spi.Headers;
    import org.projectodd.stilts.stomp.spi.Subscription;

    public interface MessageConduit {

        void send(StompMessage stompMessage) throws Exception;

        Subscription subscribe(String subscriptionId, 
                               String destination, 
                               Headers headers) throws Exception;
    }

