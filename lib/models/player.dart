import '/models/hitbox.dart';

class Player extends HitBox {

  String? uuid;
  String? name;

  Player({
    this.uuid,
    this.name,
    super.x,
    super.y,
    super.dir,
    super.width,
    super.height,
  });

  factory Player.fromJson(Map<String, dynamic> json) => Player(
    uuid: json["uuid"],
    name: json["name"],
    dir: toDir(json["dir"])
  );
}

Direction toDir(String str) {
  switch (str) {
    case "left": return Direction.left;
    case "right": return Direction.right;
    default: return Direction.idle;
  }
}

