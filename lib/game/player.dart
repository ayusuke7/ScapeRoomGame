import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multiplayer/game/platform.dart';


class Player extends SpriteComponent with CollisionCallbacks, KeyboardHandler {
  int _hAxisInput = 0;
  bool _jumpInput = false;
  bool _isOnGround = false;

  final double _gravity = 11.0;
  final double _jumpSpeed = 400;
  final double _moveSpeed = 350;
  final double _terminalVelocity = 300;

  final Vector2 _up = Vector2(0, -1);
  final Vector2 _velocity = Vector2.zero();

  Player(
    Image image, {
    Vector2? position,
    Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
  }) : super.fromImage(
      image,
      srcPosition: Vector2.zero(),
      srcSize: Vector2.all(32),
      position: position,
      size: size,
      scale: scale,
      angle: angle,
      anchor: anchor,
      priority: priority,
  );

   @override
  Future<void> onLoad() async {
    await add(CircleHitbox());
  }

  @override
  void update(double dt) {
    _velocity.x = _hAxisInput * _moveSpeed;
    _velocity.y += _gravity;
    _velocity.y = _velocity.y.clamp(-_jumpSpeed, _terminalVelocity);
    position += _velocity * dt;

    if (_jumpInput && _isOnGround) {
      _velocity.y = -_jumpSpeed;
      _isOnGround = false;
      _jumpInput = false;
    }

    _velocity.y = _velocity.y.clamp(-_jumpSpeed, 300);


    // Flip player if needed.
    if (_hAxisInput < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (_hAxisInput > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Platform) {
      if (intersectionPoints.length == 2) {
        final mid = (intersectionPoints.elementAt(0) + intersectionPoints.elementAt(1)) / 2;

        final collisionNormal = absoluteCenter - mid;
        final separationDistance = (size.x / 2) - collisionNormal.length;
        collisionNormal.normalize();

        // If collision normal is almost upwards,
        // player must be on ground.
        if (_up.dot(collisionNormal) > 0.9) {
          _isOnGround = true;
        }

        // Resolve collision by moving player along
        // collision normal by separation distance.
        position += collisionNormal.scaled(separationDistance);
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _hAxisInput = 0;
    _hAxisInput += keysPressed.contains(LogicalKeyboardKey.arrowLeft) ? -1 : 0;
    _hAxisInput += keysPressed.contains(LogicalKeyboardKey.arrowRight) ? 1 : 0;
    _jumpInput = keysPressed.contains(LogicalKeyboardKey.arrowUp);
    return true;
  }
}