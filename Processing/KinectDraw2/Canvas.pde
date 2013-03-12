class Canvas {
  PGraphics pg;
  int Cwidth, Cheight, Cx, Cy;
  ArrayList spots;
  ArrayList paths;
  boolean addAL;
  PVector circLoc;
  PVector prevCircLoc;
  PVector lineLoc;
  PVector prevLineLoc;

  //Spot spot;

  Canvas(int _x, int _y, int _width, int _height) {
    Cwidth = _width;
    Cheight = _height;
    Cx = _x;
    Cy = _y;

    spots = new ArrayList();
    paths = new ArrayList();

    circLoc = new PVector(0, 0);
    prevCircLoc = new PVector(0, 0);
    lineLoc = new PVector(0, 0);
    prevLineLoc = new PVector(0, 0);

    pg = createGraphics(Cwidth, Cheight, P2D);
  }//end constructor

  void drawLines(PVector _loc, int _size, color _color) {
    if (_loc != null && _loc.x<Cwidth && _loc.y<Cheight) {
      lineLoc = _loc;
      /*
      if(prevLineLoc.x == 0 && prevLineLoc.y == 0){
        println("prevLineLoc not set");
        prevLineLoc.set(mouseX, mouseY, 0);
      }
      */
      prevLineLoc.set(mouseX, mouseY, 0);
      if (lineLoc.x != 0 && lineLoc.y != 0 && prevLineLoc.x != 0 && prevLineLoc.y != 0 && lineLoc != prevLineLoc) {
        println("PrevLineLoc = " + prevLineLoc);
        println("lineLoc = " + lineLoc);
        paths.add(new Path(prevLineLoc, lineLoc, _size, _color));
        prevLineLoc = lineLoc;
      }
    }//end drawing conditions if
  }

  void drawCircles(PVector _loc, int _size, color _color) {
    if (_loc != null && _loc.x<Cwidth && _loc.y<Cheight) {
      circLoc = _loc;
      if (circLoc.x != 0 && circLoc.y != 0 && circLoc != prevCircLoc) {
        spots.add(new Spot(circLoc, _size, _color));
        prevCircLoc = circLoc;
      }
    }//end drawing conditions if
  }//end drawCircles
  
  void clear(){
    if (spots.size() > 0) {
      for (int i = 0; i < spots.size(); i++) {
        spots.remove(i);
      }//end for
    }//end if
    if (paths.size() > 0) {
      for (int i = 0; i < paths.size(); i++) {
        paths.remove(i);
      }//end for
    }//end if
  }

  void display() {
    pg.beginDraw();
    if (spots.size() > 0) {
      for (int i = 0; i < spots.size(); i++) {
        Spot sp = (Spot)spots.get(i);
        sp.drawSpot();
      }//end for
    }//end if
    if (paths.size() > 0) {
      for (int i = 0; i < paths.size(); i++) {
        Path p = (Path)paths.get(i);
        p.drawPath();
      }//end for
    }//end if
    pg.endDraw();
    image(pg, Cx, Cy);
  }//end display
}// end class Canvas

