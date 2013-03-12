import librarytests.*;
import org.openkinect.*;
import org.openkinect.processing.*;

import processing.net.*;

Server myServer;
int port = 5204;
byte zero = 0;

Kinect kinect;
KinectTracker tracker;

boolean connected;
int trackedX, trackedY;

void setup() {
  size(300, 100);

  myServer = new Server(this, port);
  
  kinect = new Kinect(this);
  tracker = new KinectTracker();
  
}

void draw() {
  background(100);
  Client thisClient = myServer.available();
  if(thisClient !=null){
    text ("We have a client: " + thisClient.ip(), 10, 10);
    tracker.track();
    PVector v = tracker.getPos();
    trackedX = (int)v.x;
    trackedY = (int)v.y;
    myServer.write(trackedX + "," + trackedY);
    myServer.write(zero);
  }
  else {
    text("Nothing is connected", 10, 10);
  }
}
