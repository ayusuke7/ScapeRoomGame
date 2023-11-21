import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter_multiplayer/game/level.dart';

class GamePlatform extends FlameGame 
  with HasCollisionDetection, HasKeyboardHandlerComponents {

  final fixedResolution = Vector2(1280, 960);

  late Image spriteSheet;
  
  Level? _currentLevel;

  @override
  Future<void> onLoad() async {
    spriteSheet = await images.load('spritesheet.png');

    _setupDevice();
    _loadLevel('level1.tmx');

    return super.onLoad();
  }

  void _setupDevice() async {
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();
  }

  Future<void> _loadLevel(String levelName) async {
    _currentLevel = Level(levelName);
    camera = CameraComponent.withFixedResolution(
      world: _currentLevel,
      width: fixedResolution.x,
      height: fixedResolution.y,
    );
    camera.viewfinder.anchor = Anchor.topLeft;
    await add(_currentLevel!);
  }

}
