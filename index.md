---
layout: default
title: Overview
---

[architecture]: /architecture/
[conduit]: /stilts-conduit/

# What is Stilts?

Stilts is STOMP-native messaging framework.  It is **not** a message broker.  It aims
to address treating STOMP as primary contract for messaging, and integrating around 
it, instead of simply applying STOMP shims to existing services.

You can read more about the [motivation behind Stilts](/motivation/). Stilts
was built as a layered [architecture].  It encompasses most notably the [**Stomplet API**](/stilts-stomplet/)
and the [**Stilts Stomplet Container**](/stilts-stomplet/).

# Why should I care?

## Stomplet API

At the top-most level, Stilts introduces the [Stomplet API](/stilts-stomplet/) for creating messaging endpoint
handlers.  Stomplets build upon the JMS `MessageListener` concept to include handling
registration of subscribers.

    package org.projectodd.stilts.stomplet;

    import org.projectodd.stilts.StompException;
    import org.projectodd.stilts.StompMessage;

    public interface Stomplet {
    
        void initialize(StompletConfig config) throws StompException;
        void destroy() throws StompException;
        
        void onMessage(StompMessage message) throws StompException;
        
        void onSubscribe(Subscriber subscriber) throws StompException;
        void onUnsubscribe(Subscriber subscriber) throws StompException;

    }

By implementing these simple components (within the environment which includes CDI, JTA and JCA),
your application can have complete control over how to react to a variety of STOMP events.

You may or may not involve your enterprise JMS message broker in these interactions.

## MessageConduit SPI

If you'd like to have more control over the interactions between the STOMP protocol and
your own code, you can drop down a layer, and work with the `MessageConduit` SPI, a part
of the [Stilts Message Conduit framework][conduit].  This allows you to control all subscriptions and message
transfer for each client connection at a single point.  The underlying Circus framework handles
the transactionality of the connections for you.

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

## StompProvider SPI

In the event you want to bind as closely as possible to the underlying STOMP transport,
you may forgo the Circus framework, and implement a `StompProvider` and its constellation
of support classes directly:

    package org.projectodd.stilts.stomp.spi;

    import org.projectodd.stilts.StompException;

    public interface StompProvider {
        StompConnection createConnection(TransactionalAcknowledgeableMessageSink messageSink, 
                                         Headers headers) throws StompException;
    }

