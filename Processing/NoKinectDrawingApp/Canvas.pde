class Canvas {

  int Cwidth, Cheight, Cx, Cy;

  ArrayList <ArrayList> Trails = new ArrayList <ArrayList> ();//array of lines

  int currentTrail;

  boolean addTrail;
  PVector loc;
  PVector prevLoc;

  Canvas(int _x, int _y, int _width, int _height) {
    Cwidth = _width;
    Cheight = _height;
    Cx = _x;
    Cy = _y;

    loc = new PVector(0, 0);
    prevLoc = new PVector(0, 0);

    currentTrail = 0;
    addTrail = true;
  }//end constructor

  void drawLines(PVector _loc, int _size, color _color) {
    if(loc != _loc){
    if (Trails.size() == 0) {
      //println("Trail size 0 so adding new Trail"); //fo' debuggin'
      Trails.add(new ArrayList());
    }
    
    if (_loc != null && _loc.x<Cwidth && _loc.y<Cheight) {
      loc = _loc;
      if (prevLoc.x == 0 && prevLoc.y == 0) {
        prevLoc = loc;
      }
      //println("Canvas loc is: " + loc);  //fo' debuggin'
      //println("Canvas prevLoc is: " + prevLoc);  //fo' debuggin'
      
      ArrayList Paths = (ArrayList)Trails.get(currentTrail);

      if (loc.x != 0 && loc.y != 0 && prevLoc.x != 0 && prevLoc.y != 0 && loc != prevLoc) {
        Paths.add(new Path(prevLoc, loc, _size, _color));
       /// println("Path added to Trail " + currentTrail);  //fo' debuggin'
        prevLoc = loc;
      }
      if (!addTrail) {
        addTrail = true;
      }
    }//end drawing conditions if
    }// end if checking for new pointer
    else{
      if (addTrail) {
      Trails.add(new ArrayList());
      currentTrail++;
      addTrail = false;
      prevLoc.x = prevLoc.y = 0;
    }//end inner if
    }
  }//end drawLines


  void clear() {
    if(Trails.size() > 0){
      for (int i=0; i<Trails.size(); i++) {
        Trails.remove(i);
      }//end for
    }//end if
    int trSize = Trails.size();
    if(trSize > 0){
    currentTrail = trSize-1;
    }
    else{
      currentTrail = 0;
    }
  }//end clear

  void display() {
    for (int i = 0; i<Trails.size(); i++) {          //run through all the trails in the big array list
      ArrayList tr = (ArrayList)Trails.get(i);    //every trail is an array list itself
        for (int j = 0; j<tr.size(); j++) {          //run through all thr PVectors in the path
          Path p = (Path)tr.get(j);
          if (p.loc.x != 0 && p.loc.y != 0) { // for some reason loc is set to 0 when tracker.inRange goes from true to false. We dont want those lines going to upper left corner all the time!!
            p.drawPath();
          }
        }//end inner for loop
    }//end outer for loop
  }//end display
  
}// end class Canvas

