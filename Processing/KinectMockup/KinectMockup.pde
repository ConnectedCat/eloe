import mindset.*;
import processing.serial.*;
import processing.net.*;
import librarytests.*;
import org.openkinect.*;
import org.openkinect.processing.*;

// Showing how we can farm all the kinect stuff out to a separate class
KinectTracker tracker;
// Kinect Library object
Kinect kinect;

MindSet mindset;
Serial port;

//Variables
String serialPort = "/dev/tty.MindSet-DevB";
PVector v1;
PVector prevLoc;
float attention, meditation, thickness, colorValue;



void setup() {
  //Set the size of the sketch
  size(1024, 768);
  //Set the background color
  background(255);
  smooth();
  
  kinect = new Kinect(this);
  tracker = new KinectTracker();
  
  mindset = new MindSet(this);
  mindset.connect(serialPort);
  
  tracker.track();
  prevLoc = tracker.getPos();
}

void draw() {
  // Run the tracking analysis
  tracker.track();
  
  // Let's draw the raw location
  v1 = tracker.getPos();
  
  attention = mindset.data.attention;
  meditation = mindset.data.meditation;
  thickness = map(attention, 0, 100, 15, 1);
  if (meditation >= 0 && meditation < 25){
    stroke(255, 0, 0);
  }
  else if (meditation >= 25 && meditation < 50){
    stroke(0, 255, 0);
  }
  else if (meditation >= 50 && meditation < 75){
    stroke(0, 0, 255);
  }
  else {
    stroke(0);
  }
 /*
  fill(50,100,250,200);
  noStroke();
  ellipse(v1.x,v1.y,20,20);
  */
  
  strokeWeight(thickness);
  line(v1.x, v1.y, prevLoc.x, prevLoc.y);
  
  
  prevLoc = v1;
}
