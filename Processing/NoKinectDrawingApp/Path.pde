class Path{
  PVector loc;
  PVector prevLoc;
  int thickness;
  color shade;
  
  Path(PVector _prevloc, PVector _loc, int _size, color _color){
    prevLoc = _prevloc;
    loc = _loc;
    thickness = _size;
    shade = _color;
    
  }//end constructor
  
  void drawPath(){
    
    stroke(shade);
    strokeWeight(thickness);
    line(loc.x, loc.y, prevLoc.x, prevLoc.y);
    noStroke();
  }
  
}//end class
