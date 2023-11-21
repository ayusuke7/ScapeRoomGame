import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter_multiplayer/game/game.dart';
import 'package:flutter_multiplayer/game/platform.dart';
import 'package:flutter_multiplayer/game/player.dart';
import 'dart:async';

class Level extends World with HasGameRef<GamePlatform> {
  final String levelName;
  late Player _player;
  late TiledComponent _level;

  Level(this.levelName) : super();

  @override
  FutureOr<void> onLoad() async {
    _level = await TiledComponent.load(levelName, Vector2.all(32));
    add(_level);

    _spawObjects();
    _addCollisions();
    
    return super.onLoad();
  }

  void _spawObjects() {
    final objectsMap = _level.tileMap.getLayer<ObjectGroup>('Objects');

    for (final obj in objectsMap!.objects) {
      final position = Vector2(obj.x, obj.y - obj.height);
      final size = Vector2(obj.width, obj.height);

      switch (obj.class_) {
        case 'Player':
          _player = Player(
            game.spriteSheet,
            anchor: Anchor.center,
            position: position,
            size: size
          );
          add(_player);
          break;
        default:
          break;
      }

    }

  }

  void _addCollisions() {
    final platformsMap = _level.tileMap.getLayer<ObjectGroup>('Platforms');

    for (final platform in platformsMap!.objects) {
      add(Platform(
        position: Vector2(platform.x, platform.y),
        size: Vector2(platform.width, platform.height),
      ));
    }
  }

}