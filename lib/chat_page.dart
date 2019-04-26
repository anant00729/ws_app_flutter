import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Flutter Chat"),
        ),
        body: new ChatScreen());
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final WebSocketChannel channel =
      new IOWebSocketChannel.connect("wss://tciikas.herokuapp.com/");

  final TextEditingController _chatController = new TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];


  List<String> names = ["Anant", "Ajit", "Omi" , "Sumit", "Akash"];

  String current_name;

  @override
  void initState() {
    super.initState();
    var rng = new Random();
    try{


      channel.stream.listen(
              (msg){
                final _d = json.decode(msg);
                  ChatMessage message = new ChatMessage(text: _d['data'], name: _d['name'],c_name: current_name);
                  setState(() {
                    _messages.insert(0, message);
                  });

            // handling of the incoming messages
          },
          onError: (error, StackTrace stackTrace){
            // error handling
            print(error);

          },
          onDone: (){
            print('onDone');
            // communication has been closed
          }
      );
    }catch(e){
      print(e);
    }



    current_name = names[rng.nextInt(100)%5];

    channel.sink.add(json.encode({
      "type" : "name",
      "data" : current_name
    }));



  }

  void _handleSubmit(String text) {

    _chatController.clear();

    if (text.isNotEmpty) {
      channel.sink
          .add(json.encode({"type": "message", "data": text}));
    }

//    ChatMessage message = new ChatMessage(text: text);
//
//    setState(() {
//      _messages.insert(0, message);
//    });
  }

  Widget _chatEnvironment() {
    return IconTheme(
      data: new IconThemeData(color: Colors.blue),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                decoration:
                    new InputDecoration.collapsed(hintText: "Start typing ..."),
                controller: _chatController,
                onSubmitted: _handleSubmit,
              ),
            ),
            new Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => _handleSubmit(_chatController.text),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[

        new Flexible(
          child: ListView.builder(
            padding: new EdgeInsets.all(8.0),
            reverse: true,
            itemBuilder: (_, int index) => _messages[index],
            itemCount: _messages.length,
          ),
        ),
        new Divider(
          height: 1.0,
        ),
        new Container(
          decoration: new BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          child: _chatEnvironment(),
        )
      ],
    );
  }
}

const String _name = "Anonymous";

class ChatMessage extends StatelessWidget {
  final String text;
  final String name;
  final String c_name;


// constructor to get text from textfield
  ChatMessage({this.text, this.name , this.c_name});

  @override
  Widget build(BuildContext context) {


    TextDirection t_d;

    if(c_name == name){
      t_d = TextDirection.rtl;
    }else{
      t_d = TextDirection.ltr;
    }
    return  new Directionality(
      textDirection: t_d,
      child: new Builder(
        builder: (BuildContext context) {
          return new MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: 1.0,
            ),
            child: new ListTile(
              contentPadding: const EdgeInsets.all(4.0),
              leading: Container(
                //color: Colors.blue,
                width: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: FadeInImage(
                    width: double.infinity,
                    placeholder: AssetImage('assets/app_logo_single.png'),
                    image: NetworkImage("https://api.adorable.io/avatars/91/${name}@adorable.io"),
                    fit: BoxFit.cover,
                    height: 50,
                    //width: 100,
                  ),
                ),
              ),
              title: new Text(name ?? "No data", style: Theme.of(context).textTheme.subhead),
              subtitle: new Text(text ?? "No data"),
            ),
          );
        },
      ),
    );









//      new Container(
//        margin: const EdgeInsets.symmetric(vertical: 10.0),
//        child: new Row(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//
//            Container(
//              //color: Colors.blue,
//              width: 50,
//              child: ClipRRect(
//                borderRadius: BorderRadius.circular(25),
//                child: FadeInImage(
//                  width: double.infinity,
//                  placeholder: AssetImage('assets/app_logo_single.png'),
//                  image: NetworkImage("https://api.adorable.io/avatars/91/${name}@adorable.io"),
//                  fit: BoxFit.cover,
//                  height: 50,
//                  //width: 100,
//                ),
//              ),
//            ),
//
//
//            SizedBox(width: 8,),
//
//            new Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                new Text(name ?? "No data", style: Theme.of(context).textTheme.subhead),
//                new Container(
//                  margin: const EdgeInsets.only(top: 5.0),
//                  child: new Text(text ?? "No data"),
//                )
//              ],
//            )
//          ],
//        ));
  }
}
