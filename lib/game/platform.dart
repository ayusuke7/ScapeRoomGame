import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Platform extends PositionComponent with CollisionCallbacks {
  Platform({
    required Vector2 position,
    required Vector2 size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
  }) : super(
          position: position,
          size: size,
          scale: scale,
          angle: angle,
          anchor: anchor,
        );

  @override
  Future<void> onLoad() async {
    await add(RectangleHitbox()..collisionType = CollisionType.passive);
  }
}
