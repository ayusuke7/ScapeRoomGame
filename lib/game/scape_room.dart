import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter_multiplayer/game/level.dart';

class ScapeRoom extends FlameGame 
  with HasCollisionDetection, HasKeyboardHandlerComponents {

  final fixedResolution = Vector2(1280, 640);
  
  Level? _currentLevel;

  @override
  Future<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();

    _loadLevel('level1.tmx');

    return super.onLoad();
  }

  void _loadLevel(String levelName) async {
    _currentLevel = Level(levelName);
    add(_currentLevel!);
  }

}
