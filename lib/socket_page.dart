import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class SocketPage extends StatefulWidget {
  @override
  _SocketPageState createState() => _SocketPageState();
}

class _SocketPageState extends State<SocketPage> {

  IOWebSocketChannel _c;


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 200,
        height: 200,
        color: Colors.yellow,
      ),
    );
  }


  @override
  void dispose() {
    _c.sink.close();
    super.dispose();
  }
}




