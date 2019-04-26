import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';



WebSocketNoti w_s_n = WebSocketNoti();


final String SERVER_ADDR = "wss://tciikas.herokuapp.com/";


//https://tick-node-app.herokuapp.com/
//ws://192.168.1.183:3000/
//"ws://192.168.1.183:3000"
//ws://localhost:3000

class WebSocketNoti{
  static final WebSocketNoti _s = WebSocketNoti._internal();


  factory WebSocketNoti(){
    return _s;
  }


  WebSocketNoti._internal();

  IOWebSocketChannel _channel;

  bool isOn = false;

  ObserverList<Function> _listeners = ObserverList<Function>();


  initCommunication() async {
    reset();


    try{
      _channel = new IOWebSocketChannel.connect(SERVER_ADDR);
      _channel.stream.listen(_onReceptionOfMessageFromServer);
    }catch(e){

    }
  }



  reset(){
    if(_channel != null){
      if(_channel.sink != null){
        _channel.sink.close();
        isOn = false;
      }
    }
  }


  send(String message){
    if(_channel != null){
      if(_channel.sink != null){
        _channel.sink.add(message);
      }
    }
  }


  addListeners(Function callback){
    _listeners.add(callback);
  }


  removeListerners(Function callback){
    _listeners.remove(callback);
  }

  _onReceptionOfMessageFromServer(message){
    isOn = true;
    _listeners.forEach((callback) => {
      callback(message)
    });
  }


}


