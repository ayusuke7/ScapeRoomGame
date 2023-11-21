import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_multiplayer/io/server.dart';
import 'package:flutter_multiplayer/models/hitbox.dart';
import 'package:flutter_multiplayer/models/player.dart';

var colors = <Color>[
  Colors.red,
  Colors.black,
  Colors.green,
  Colors.blue,
  Colors.orange
];


class TesteBoard extends StatefulWidget {
  const TesteBoard({super.key});

  @override
  State<TesteBoard> createState() => _TesteBoardState();
}

class _TesteBoardState extends State<TesteBoard> {
  final _fps = const Duration(milliseconds: 50);
  final _server = Server();

  double force = 10.0;
  double gravity = 5.0;
  double velocity = 20.0;
  
  Timer? _timer;
  Size? _size;
  
  void _start() {
    _timer = Timer.periodic(_fps, (t) {

      for (var player in _server.players) {
        player.y += player.velocity.y;
        player.x += player.velocity.x;

        /* gravity */
        if (
          player.bottom + player.velocity.y >= 0) {
          player.velocity.y -= gravity;
        } else {
          player.velocity.y = 0;
        }

        /* moviments */
        if (player.right < _size!.width && player.dir == Direction.right) {
          player.velocity.x = velocity; 
        } else
        if (player.left > 0 && player.dir == Direction.left) {
          player.velocity.x = -velocity; 
        } else {
          player.velocity.x = 0;
        }
      }

      /* update three */
      setState(() {});
    });

  }

  void _stop() {
    _timer?.cancel();
  }

  String _convertTime() {

    if(_timer != null) {
      var ms = _timer!.tick * _fps.inMilliseconds;
      var d = Duration(milliseconds: ms);
      return '${d.inSeconds}s';
    }

    return '0s';
  }

  @override
  void dispose() {
    _stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;


    var players = _server.players;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                if (!_server.started) {
                  _server.start();
                  
                  _server.addPlayer(Player(
                    uuid: '1a',
                    name: 'Teste',
                    x: 100,
                    y: 100
                  ));

                  _server.addPlayer(Player(
                    uuid: '2a',
                    name: 'Teste',
                    x: 300,
                    y: 100
                  ));

                  _start();
                } else {
                  _server.stop();
                  _stop();
                }

              },
              style: TextButton.styleFrom(
                backgroundColor: _server.started ? Colors.green : Colors.red,
                foregroundColor: _server.started ? Colors.white : Colors.black
              ),
              child: Text("SERVER ${_server.started ? 'ON' : 'OFF'}"),
            ),

            Text(_convertTime(), style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0
            ))
          ],
        ),
      ),
      body: Container(
        color: Colors.grey,
        child: Stack(
          children: <Widget>[

            for (var p in players)
              AnimatedPositioned(
                left: p.x,
                bottom: p.y,
                duration: _fps,
                child: Container(
                  width: p.width,
                  height: p.height,
                  alignment: Alignment.center,
                  color: colors[players.indexOf(p)],
                  child: Text('${p.x.round()}, ${p.y.round()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12
                    ),
                  ),
                )
              )

          ],
        ),
      ),
    );
  }
}