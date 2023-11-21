enum Direction { left, right, idle }

class HitBox {

  Vector velocity = Vector(0, 0);
  
  double x;
  double y;

  double width;
  double height;

  Direction dir;

  HitBox({
    this.x = 0,
    this.y = 0,
    this.width = 80.0,
    this.height = 80.0,
    this.dir = Direction.idle,
  });

  double get top => y + height;

  double get right => x + width;
  
  double get bottom => y;
  
  double get left => x;

  String get log {
    return "XY: ($x, $y), TRBL: ($top, $right, $bottom, $left), VEL: (${velocity.x}, ${velocity.y})";
  }

}

class Vector {
  double x;
  double y;

  Vector(this.x, this.y); 
}
