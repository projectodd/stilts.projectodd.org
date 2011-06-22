---
title: Client
layout: default
---

# STOMP Client

Created for our own testing purposes, the Stilts framework includes a STOMP 1.1
client.  It **is** strangely named `AbstractStompClient` at the moment.

    InetSocketAddress address = new InetSocketAddress( "localhost", 8675 );
    client = new AbstractStompClient( address );
    client.setLoggerManager( SimpleLoggerManager.DEFAULT_INSTANCE );

    client.connect();

    ClientSubscription subscription1 = 
            client.subscribe( "/queues/foo" )
              .withMessageHandler( new Acumulator( "one" ) )
              .withAckMode( AckMode.CLIENT_INDIVIDUAL )
              .start();

    ClientSubscription subscription2 = 
            client.subscribe( "/queues/foo" )
              .withMessageHandler( new Acumulator( "two" ) )
              .withAckMode( AckMode.AUTO )
              .start();
        
    ClientTransaction tx = client.begin();

    for (int i = 0; i < 10; ++i) {
        tx.send( 
          StompMessages.createStompMessage( "/queues/foo", "msg-" + i ) 
        );
    }

    tx.commit();

    subscription1.unsubscribe();
    subscription2.unsubscribe();

    client.disconnect();

