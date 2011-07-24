---
title: Javascript STOMP Client
layout: default
---

# Javascript STOMP Client

Borrowed from former coworker Jeff Mesnil, the Javascript STOMP client works
over WebSockets.

    client = Stomp.client( "ws://localhost:8675/" );

    client.connect( "bob", "sw0rdf1sh", function(frame) {

      // once connected...

      subscription_id = client.subscribe("/queues/one", function(msg) {
          // handle messages for this subscription 
      } );
    
      client.begin( "tx-1" );
      client.send("/queues/one", {transaction: "tx-1"}, "message in a transaction");

      client.commit( "tx-1" );
  
      client.disconnect();
    }


## Future adjustments

We'd like to mutate the Javascript STOMP client to follow an API more akin
to the Java client, exposing more options through the API, such as message
acknowledgement-mode, and objectified transations.
