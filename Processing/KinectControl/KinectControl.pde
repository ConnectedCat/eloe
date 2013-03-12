import processing.video.*;

import hypermedia.video.*;

import librarytests.*;
import org.openkinect.*;
import org.openkinect.processing.*;

import controlP5.*;

ControlP5 uiControl;
float sliderDMin, sliderDMax;
float sliderRMin, sliderRMax;
int sliderX, sliderY, sliderW, sliderH;
String sliderDName;
String sliderRName;

KinectTracker tracker;
Kinect kinect;
int deg;
int range;

OpenCV opencv;

void setup(){
  size(1024, 480);
  uiControl = new ControlP5(this);
  sliderDName = "deg";
  sliderDMin = -30;
  sliderDMax = 30;
  
  sliderRName = "range";
  sliderRMin = 500;
  sliderRMax = 1500;
  
  sliderW = 15;
  sliderH = 200;
  sliderX = width - sliderW*5;
  sliderY = 200;
  
  
  
  
  uiControl.addSlider(sliderDName,sliderDMin, sliderDMax, sliderX, sliderY, sliderW, sliderH);

  
  kinect = new Kinect(this);
  tracker = new KinectTracker();
  deg = 0;
  range = tracker.threshold;
  
  uiControl.addSlider(sliderRName, sliderRMin, sliderRMax, range, sliderX - 100, sliderY, sliderW, sliderH);
}

void draw(){
  background(0);
  tracker.track();
  tracker.display();
  kinect.tilt(deg);
  tracker.setThreshold(range);
 // tracker.calculateBlobs();
}
