---
layout: default
title: Stilts Stomplet Framework
---

# Foundations

The STOMP protocol can be divided into transaction-management, subscription-management
and message-sending.  The Stomplet API aims to provide developer-control over the 
last two.

# The API

The API tries to be simple, with and `initialize()` and `destroy()` pair for
lifecycle-management, an `onSubscribe()` and `onUnsubscribe()` pair for
subscription-management, and a simple `onMessage()` for message-sending.

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

# Routing

Similar to how Java Servlets are bound to particular contexts within the web-server
space, Stomplets get bound to destinations through the use of _routes_.

A route is made up of 3 parts:

1. The _pattern_ to match against the destination.
2. The Stomplet to handle requests (subscription- and message-related) to the route.
3. Arbitrary configuration properties for this route's Stomplet.

## Destination patterns

The patterns are modelled after Ruby-on-Rails web-request routing patterns. The
pattern is taken to be mostly a literal match against STOMP destinations, but
portions that start with a colon, such as `:name` match as a named segment, until
the next slash.  Each named segment is available to the Stomplet while processing
the each incoming message.

This pattern:

    /queues/:customer/:name

Would match any of the following destinations

    /queues/bigcorp/accounts-payable
    /queues/littlecompany/accounts-receivable
    /queues/hey/anything

And the `customer` and `name` segments would be extracted for easy use by the
Stomplet.

# `stomplet.conf`

Routes are setup through files named `stomplet.conf`, which matches stylistically, with
the actual STOMP protocol.  To define a route, the `ROUTE` keyword is followed by the
route pattern, and the Java classname to manage that route.

    ROUTE /queues/:queue org.projectodd.MyQueueHandler
    ROUTE /topics/:topics org.projectodd.MyTopicHandler

# Receiving messages from clients

When a client sends a message to a destination, the matching Stomplet will have
its `onMessage()` method called.  The Stomplet may then do whatever it deems necessary
to process that message.  It may place the message on a subsequent JMS-backed queue,
it could simply echo it to other subscribers, or it may perform other operations
in response.

# Subscription Management

## New subscriptions

When a client attempts to subscribe to a destination, the same route-matching logic
is performed, and the request is dispatched to the appropriate Stomplet's `onSubscribe()`
method.  If the Stomplet returns without error, the subscription will be considered
successful.  

## Cancelling subscriptions

When a client cancels a subscription, the same `Subscription` object will be passed
back to the Stomplet's `onUnsubscribe()` method.

# Sending messages to subscribers

## No acknowledgement

The `Subscriber` parameter passed to `onSubscribe(...)` implements a variety of `MessageSink` interfaces to allow
the Stomplet to return messages back to the new subscriber.  The simplest option is:

    void send(StompMessage message) throws StompException;

Messages sent using this method will be delivered to the subscriber.  Un-acknowledged
messages will be silently dropped, regardless of the client transaction's acknowledgement-mode.

## Simple acknowledgement

If your Stomplet would like to receive acknowledgement notices, you can implement
`AcknowledgeableStomplet` which adds two more methods:

    void ack(Subscriber subscriber, 
             StompMessage message);

    void nack(Subscriber subscriber, 
              StompMessage message);

In the event of a `nack()` event, you may decide to attempt redelivery or otherwise
handle the failure.

## Advanced acknowledgement

For Stomplets doing tighter integration with back-end systems, such as JMS, a more explicit
acknowledgement callback mechanism is available on the `Subscriber` object.

    void send(StompMessage message, 
              Acknowledger acknowledger) throws StompException;

This method takes an `Acknowledger` implementation which contains the methods `ack()`
and `nack()` which the server will call at the appropriate time.  This allows you to 
wrap, for instance, the JMS `Message#acknowledge()` method in an `Acknowledger#ack()`
method handled directly by the container.

# Server

You can easily stand up a Stomplet server with virtual-hosted Stomplet containers.

    StompletContainer container = new SimpleStompletContainer();
    Stomplet queueOneStomplet = new MyQueueStomplet();
    container.addStomplet( "/queues/one", queueOneStomplet );

    server = new StompletServer();
    server.setTransactionManager( getTransactionManager() );
    server.setDefaultStompletContainer( container );
    server.start();
