import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'package:web_socket_channel/status.dart' as status;


class Home extends StatelessWidget {


  //https://tickt-tac.herokuapp.com/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              settings: RouteSettings(name: '/movie_detail'),
              builder: (c) {
                return MyHomePage(
                  channel: new IOWebSocketChannel.connect("wss://tciikas.herokuapp.com/"),
                );
              }));
        },
          child: Text('Press'),
        ),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  final WebSocketChannel channel;
  MyHomePage({@required this.channel});

  @override
  MyHomePageState createState() {
    return new MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {



  TextEditingController editingController = new TextEditingController();

  @override
  void initState() {
//    json.encode({{
//      "action": "connection",
//      "data": "data to be sent"
//    }});
    widget.channel.sink.add(
        json.encode({
          "type" : "connect",
          "data" : "ANANt"
        })
    );


    print(widget.channel);
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
                  child: new Text(snapshot.hasData ? '${snapshot.data}' : ''),
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
          editingController.text
      );
    }
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
}
