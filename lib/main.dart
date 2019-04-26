import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:socket_app/chat_page.dart';
import 'package:socket_app/home.dart';
import 'package:socket_app/start_page.dart';
import 'package:socket_app/util/home_page_one.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:async';

void main() {
  runApp(new MyApp());
//    try{
//
//      WebSocketChannel _c = new IOWebSocketChannel.connect('ws://192.168.1.183:3000/');
//      _c.stream.listen(
//              (message){
//            print(message);
//            _c.sink.add(json.encode({
//              "action": 'message',
//              "data": 'chu'
//            }));
//
//            _c.sink.add(json.encode({
//              "action": 'hello',
//              "data": 'anant'
//            }));
//            // handling of the incoming messages
//          },
//          onError: (error, StackTrace stackTrace){
//            // error handling
//            print(error);
//
//          },
//          onDone: (){
//            print('onDone');
//            // communication has been closed
//          }
//      );
//    }catch(e){
//      print(e);
//    }
}




class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: ChatPage()/*new MyHomePageOne(
        channel: new IOWebSocketChannel.connect("ws://192.168.1.30:3000/"),
      ),*/
    );
  }
}


