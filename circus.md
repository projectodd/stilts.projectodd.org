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

## MessageConduitFactory

Your implementation of a Circus extension starts with a `MessageConduitFactory`,
which may be akin in life-cycle to a JMS connection, capable of creating
`MessageConduit` instances, one per client connection, which would map to
a JMS `Session`.

    package org.projectodd.stilts.circus;

    import org.projectodd.stilts.stomp.spi.AcknowledgeableMessageSink;

    public interface MessageConduitFactory {
    
        MessageConduit createMessageConduit(AcknowledgeableMessageSink messageSink) 
          throws Exception;
    
    }

The `AcknowledgeableMessageSink` interacts with the underlying Stilts connection
for the client.

## MessageConduit

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

The `Subscription` is simply a handle for the Circus server to control (cancel)
the client subscription.

    package org.projectodd.stilts.stomp.spi;

    import org.projectodd.stilts.StompException;

    public interface Subscription {
    
        public static enum AckMode {
            AUTO("auto"),
            CLIENT("client"),
            CLIENT_INDIVIDUAL("client-individual"),;
            
            private String str;
    
            AckMode(String str) {
                this.str = str;
            }
            
            public String toString() {
                return this.str;
            }
        }
        
        String getId();
        void cancel() throws StompException;
    }
