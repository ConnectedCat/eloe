class Spot {
  PVector loc;
  int thickness;
  color shade;

  Spot(PVector _loc, int _size, color _color) {
    loc = _loc;
    thickness = _size;
    shade = _color;
  }
  void drawSpot(){
    noStroke();
    fill(shade);
    ellipse(loc.x, loc.y, thickness, thickness);
    noFill();
  }
}

