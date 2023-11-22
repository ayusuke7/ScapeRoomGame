import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter_multiplayer/game/platform.dart';
import 'package:flutter_multiplayer/game/player.dart';
import 'package:flutter_multiplayer/game/scape_room.dart';

class Level extends World with HasGameRef<ScapeRoom> {
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
    _setupCamera();
    
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
            anchor: Anchor.center,
            position: position,
            size: size,
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

  void _setupCamera() {
    game.camera = CameraComponent.withFixedResolution(
      world: this,
      width: (_level.tileMap.map.width * _level.tileMap.map.tileWidth).toDouble(),
      height: (_level.tileMap.map.height * _level.tileMap.map.tileHeight).toDouble(),
    );
    game.camera.viewfinder.anchor = Anchor.topLeft;


    // game.camera = CameraComponent.withFixedResolution(
    //   world: this,
    //   width: game.fixedResolution.x,
    //   height: game.fixedResolution.y,
    // );
    // camera.viewfinder.position = fixedResolution / 2;
    // game.camera.follow(_player, maxSpeed: 200);
    // game.camera.setBounds(
    //   Rectangle.fromLTRB(
    //     game.fixedResolution.x / 2,
    //     game.fixedResolution.y / 2,
    //     _level.width - game.fixedResolution.x / 2,
    //     _level.height - game.fixedResolution.y / 2,
    //   ),
    // );
  }
}