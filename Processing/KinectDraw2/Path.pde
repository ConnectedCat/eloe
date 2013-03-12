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
    line(prevLoc.x, prevLoc.y, loc.x, loc.y);
    noStroke();
  }
  
}//end class
