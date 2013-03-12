import librarytests.*;
import org.openkinect.*;
import org.openkinect.processing.*;

int thick;
color col;
int currentT, startT, wholeT;
PVector loc;
PVector prevLoc;
PGraphics graph;
boolean addPath;

//ArrayList locs = new ArrayList();//location points
ArrayList Paths = new ArrayList();//array of lines
int currentPath;

// Showing how we can farm all the kinect stuff out to a separate class
KinectTracker tracker;
// Kinect Library object
Kinect kinect;


void setup() {
  size(640, 480);
  smooth();
  background(40);

  kinect = new Kinect(this);
  tracker = new KinectTracker();
  loc = new PVector(0, 0);
  prevLoc = new PVector(0, 0);

  currentT = 0;
  startT = 0;
  wholeT = 1000;

  currentPath = 0;
  addPath = true;

  graph = createGraphics(width, height-50, P2D);
}

void draw() {
  // Run the tracking analysis
  tracker.track();
  // Show the image
  tracker.display();

  currentT = millis();
  if (currentT-startT > wholeT) {
    startT = currentT;
    thick = int(random(3, 30));
    col = color(int(random(0, 255)), int(random(0, 255)), int(random(0, 255)));
  }

  loc = tracker.getPos();
  if (prevLoc.x == 0 && prevLoc.y == 0) {
    prevLoc = loc;
  }

  if (Paths.size() == 0) {
    Paths.add(new ArrayList());
  }

  if (tracker.inRange) {
    ArrayList Locs = (ArrayList)Paths.get(currentPath);
    Locs.add(loc);
    addPath =! addPath;
  }
  else{
    if(addPath){
    Paths.add(new ArrayList());
    currentPath++;
    addPath =! addPath;
    }
  }
  
  println("Tracker boolean is " + tracker.inRange);

  for (int i=0; i< Paths.size(); i++) {   //run through all the paths in the big array list
  //println("Main array : " + Paths.size());
    ArrayList p = (ArrayList)Paths.get(i); //every path is an array list itself
  //  println("Path size is : " + p.size());
    for (int j = 0; j<p.size(); j++) {    //run through all thr PVectors in the path
    
      PVector v = (PVector)p.get(j);
      PVector pv = new PVector();
      if (j <= 1) {
        pv = v;
      }//end if
      else {
       // println("Index is " + j);
       // println("Index for pv is " + (j-1));
        pv = (PVector)p.get(j-1);
      }//end else
      /*
      graph.beginDraw();
      graph.stroke(col);
      graph.strokeWeight(thick);
      graph.line(v.x, v.y, pv.x, pv.y);
      graph.noStroke();
      */
      stroke(col);
      strokeWeight(thick);
      line(v.x, v.y, pv.x, pv.y);
      noStroke();
    }//end inner for loop
  }//end out for loop
  /*
  graph.endDraw();  
  image(graph, 0, 0);
*/
  prevLoc = loc;
}//end draw()

void keyPressed() {
  if (key == 'c') {
    background(40);
  }
  if (key == 'q') {
    tracker.quit();
    super.stop();
  }
}

