import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'websocket_notifications.dart';


GameCommunication game = GameCommunication();


class GameCommunication{
  static final GameCommunication _g = GameCommunication._internal();



  String _playerName = "";

  String _playerId = "";

  factory GameCommunication(){
    return _g;
  }


  GameCommunication._internal(){
    w_s_n.initCommunication();
    w_s_n.addListeners(_onMessageReceived);
  }


  String get playerName => _playerName;


  _onMessageReceived(serverMessage){
    Map message = json.decode(serverMessage);

    switch(message["action"]){
      case "connect" :
        _playerId = message["data"];
        break;


      default:
        _listeners.forEach((Function callback){
          callback(message);
        });
        break;

    }
  }


  ObserverList<Function> _listeners = ObserverList();


  addListener(Function callback){
    _listeners.add(callback);
  }
  removeListener(Function callback){
    _listeners.remove(callback);
  }


  /// ----------------------------------------------------------
  /// Common method to send requests to the server
  /// ----------------------------------------------------------
  send(String action, String data){
    ///
    /// When a player joins, we need to record the name
    /// he provides
    ///
    if (action == 'join'){
      _playerName = data;
    }

    ///
    /// Send the action to the server
    /// To send the message, we need to serialize the JSON
    ///
    w_s_n.send(json.encode({
      "action": action,
      "data": data
    }));
  }



}
