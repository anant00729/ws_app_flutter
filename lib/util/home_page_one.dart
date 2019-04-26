import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';


class MyHomePageOne extends StatefulWidget {
  final WebSocketChannel channel;
  MyHomePageOne({@required this.channel});

  @override
  MyHomePageOneState createState() {
    return new MyHomePageOneState();
  }
}

class MyHomePageOneState extends State<MyHomePageOne> {


  TextEditingController editingController = new TextEditingController();



  @override
  void initState() {




    widget.channel.sink.add(json.encode({
      "type" : "name",
      "data" : "Anant"
    }));


    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Web Socket"),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(20.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Form(
              child: new TextFormField(
                decoration: new InputDecoration(labelText: "Send any message"),
                controller: editingController,
              ),
            ),
            new StreamBuilder(
              stream: widget.channel.stream,
              builder: (context, snapshot) {
                return new Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: new Text(snapshot.hasData ? '${json.decode(snapshot.data)['name']} : ${json.decode(snapshot.data)['data']}' : ''),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.send),
        onPressed: _sendMyMessage,
      ),
    );
  }

  void _sendMyMessage() {
    if (editingController.text.isNotEmpty) {
      widget.channel.sink.add(
          json.encode({
            "type" : "message",
            "data" : editingController.text
          }));
    }
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
}



