import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multiplayer/game/scape_room.dart';

final game = ScapeRoom();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  //await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  runApp(GameWidget(
    game: kDebugMode ? ScapeRoom() : game
  ));
}

