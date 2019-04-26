import 'package:flutter/material.dart';
import 'game_communication.dart';

class GamePage extends StatefulWidget {

  GamePage({
    Key key,
    this.oppoName,
    this.character
  });

  final String oppoName;

  final String character;


  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  List<String> _grid = <String>["","","","","","","","",""];


  @override
  void initState() {
    super.initState();
    game.addListener(_onAction);
  }





  _onAction(message){
    switch(message["action"]){
      case 'resigned':
        Navigator.of(context).pop();
        break;

      case 'play':
        var data = (message["data"] as String).split(';');
        _grid[int.parse(data[0])] = data[1];

        // Force rebuild
        setState((){});
        break;
    }
  }

  /// ---------------------------------------------------------
  /// This player resigns
  /// We need to send this notification to the other player
  /// Then, leave this screen
  /// ---------------------------------------------------------
  _doResign(){
    game.send('resign', '');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      top: false,
      bottom: false,
      child: new Scaffold(
        appBar: new AppBar(
            title: new Text('Game against: ${widget.oppoName}', style: new TextStyle(fontSize: 16.0)),
            actions: <Widget>[
              new RaisedButton(
                onPressed: _doResign,
                child: new Text('Resign'),
              ),
            ]
        ),
        body: _buildBoard(),
      ),
    );
  }

  _buildBoard() {
    return new SafeArea(
      top: false,
      bottom: false,
      child: new GridView.builder(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: 9,
        itemBuilder: (BuildContext context, int index){
          return _gridItem(index);
        },
      ),
    );
  }

  Widget _gridItem(int index){
    Color color = _grid[index] == "X" ? Colors.blue : Colors.red;

    return new InkWell(
      onTap: () {
        ///
        /// The user taps a cell.
        /// If the latter is empty, let's put this player's character
        /// and notify the other player.
        /// Repaint the board
        ///
        if (_grid[index] == ""){
          _grid[index] = widget.character;

          ///
          /// To send a move, we provide the cell index
          /// and the character of this player
          ///
          game.send('play', '$index;${widget.character}');

          /// Force the board repaint
          setState((){});
        }
      },
      child: new GridTile(
        child: new Card(
          child: new FittedBox(
              fit: BoxFit.contain,
              child: new Text(_grid[index], style: new TextStyle(fontSize: 50.0, color: color,))
          ),
        ),
      ),
    );
  }
}
