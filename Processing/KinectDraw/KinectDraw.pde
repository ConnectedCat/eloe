import librarytests.*;
import org.openkinect.*;
import org.openkinect.processing.*;
import java.awt.Rectangle;

import controlP5.*;

import hypermedia.video.*;

OpenCV opencv;

ControlP5 controlp5;
float sliderDMin, sliderDMax;
float sliderRMin, sliderRMax;
int sliderX, sliderY, sliderW, sliderH;
String sliderDName;
String sliderRName;

int threshold = 190;

Kinect kinect;
PImage img;
int deg = 0;

ArrayList spots;

void setup() {

  size( 640, 480 );

  // open video stream
  opencv = new OpenCV( this );
  opencv.capture(640, 480);


  controlp5 = new ControlP5(this);
  sliderDName = "deg";
  sliderDMin = -30;
  sliderDMax = 30;

  sliderRName = "threshold";
  sliderRMin = 0;
  sliderRMax = 255;

  sliderW = 15;
  sliderH = 200;
  sliderX = width - sliderW*5;
  sliderY = 30;
  controlp5.addSlider(sliderDName, sliderDMin, sliderDMax, sliderX, sliderY, sliderW, sliderH);

  kinect = new Kinect(this);
  kinect.start();
  kinect.enableDepth(true);

  controlp5.addSlider(sliderRName, sliderRMin, sliderRMax, threshold, sliderX - 50, sliderY, sliderW, sliderH);

  spots = new ArrayList();
}

void draw() {
  //background(192);
  img = kinect.getDepthImage();
  kinect.tilt(deg);
  image(img, 0, 0);

  opencv.copy(img);           // grab frame from camera
  opencv.threshold(threshold);    // set black & white threshold 

  // find blobs
  Blob[] blobs = opencv.blobs( 10, width*height/2, 5, true, OpenCV.MAX_VERTICES*4);

  // draw blob results
  for ( int i=0; i<blobs.length; i++ ) {
    
    spots.add(new PVector(blobs[i].centroid.x, blobs[i].centroid.y));
  /*
    for ( int j=0; j<blobs[i].points.length; j++ ) {
      spots.add(new PVector( blobs[i].points[j].x, blobs[i].points[j].y ));
    }
*/
  }//end for

  for (int k=0; k< spots.size(); k++) {
    PVector vec = (PVector)spots.get(k);
    fill(255, 0, 255);
    noStroke();
    ellipse(vec.x, vec.y, 10, 10);
  }
}

void keyPressed() {
  if (key == 'q') {
    kinect.quit();
    super.stop();
  }
  if (key == 'c') {
    spots.clear();
  }
}

