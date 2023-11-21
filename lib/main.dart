import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multiplayer/game/game.dart';

void main() {
  runApp(const MyApp());
}

//final game = GamePlatform();

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Multiplayer',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Scaffold(body: GameWidget(game: GamePlatform())),
    );
  }
}
