import librarytests.*;
import org.openkinect.*;
import org.openkinect.processing.*;

import controlP5.*;

ControlP5 controlp5;
float sliderDMin, sliderDMax;
float sliderRMin, sliderRMax;
int sliderX, sliderY, sliderW, sliderH;
String sliderDName;
String sliderRName;
RadioButton InputSelect;
RadioButton ModeSelect;
int radioX, radioY;

Kinect kinect;
KinectTracker tracker;

Canvas canvas;

int thick;
color col;
int deg = 0;
int threshold;
PVector pointer;
PVector prevPointer;
boolean kinectSelected, drawLines;

void setup() {
  size(840, 480);
  smooth();

  controlp5 = new ControlP5(this);
  sliderDName = "deg";
  sliderDMin = -30;
  sliderDMax = 30;

  sliderRName = "threshold";
  sliderRMin = 0;
  sliderRMax = 1500;

  sliderW = 15;
  sliderH = 200;
  sliderX = width - sliderW*5;
  sliderY = 30;
  controlp5.addSlider(sliderDName, sliderDMin, sliderDMax, sliderX, sliderY, sliderW, sliderH);

  radioX = 680;
  radioY = height-160;

  InputSelect = controlp5.addRadioButton("inputSelect", radioX, radioY);
  InputSelect.setColorBackground(color(0, 85, 122));
  InputSelect.setColorActive(color(255));
  InputSelect.setColorLabel(color(255));//text in the button field
  InputSelect.setItemsPerRow(2);
  InputSelect.setSpacingColumn(63);

  addToRadioButton(InputSelect, "Kinect", 1);
  addToRadioButton(InputSelect, "Tablet", 2);

  ModeSelect = controlp5.addRadioButton("modeSelect", radioX, radioY+40);
  ModeSelect.setColorBackground(color(0, 85, 122));
  ModeSelect.setColorActive(color(255));
  ModeSelect.setColorLabel(color(255));
  ModeSelect.setItemsPerRow(2);
  ModeSelect.setSpacingColumn(63);

  addToRadioButton(ModeSelect, "Draw Lines", 3);
  addToRadioButton(ModeSelect, "Spay Circles", 4);

  kinect = new Kinect(this);
  tracker = new KinectTracker();
  canvas = new Canvas(0, 0, 640, 480);

  kinectSelected = false;
  drawLines = false;

  threshold = tracker.threshold;

  controlp5.addSlider(sliderRName, sliderRMin, sliderRMax, threshold, sliderX - 50, sliderY, sliderW, sliderH);
}

void draw() {

  background(40);
  thick = int(random(3, 30));
  col = color(int(random(0, 255)), int(random(0, 255)), int(random(0, 255)));

  if (kinectSelected) {
    tracker.track();
    tracker.display();
    pointer = tracker.getPos();
    if (prevPointer == null) {
      prevPointer = tracker.getPos();
    }

    if (!drawLines) {
      canvas.drawCircles(pointer, thick, col);
    }
    else {
      canvas.drawLines(pointer, thick, col);
    }
  }// end if kinect
  else {
    if (!drawLines) {
      canvas.drawCircles(pointer, thick, col);
    }
    else {
      canvas.drawLines(pointer, thick, col);
    }
  }// end else for mouse

  stroke(10);
  line(640, 0, 640, height);
  noStroke();
}

void keyPressed() {
  if (key == 'q') {
    tracker.quit();
    super.stop();
  }
  if (key == 'c') {
    canvas.clear();
  }
}

void mouseDragged() {
  if (!kinectSelected) {
    pointer = new PVector(float(mouseX), float(mouseY));
  }
}

void mousePressed() {
  if (!kinectSelected) {
    pointer = new PVector(float(mouseX), float(mouseY));
  }
}

void addToRadioButton(RadioButton theRadioButton, String theName, int theValue ) {
  Toggle t = theRadioButton.addItem(theName, theValue);
  t.captionLabel().setColorBackground(color(135, 120, 20));
  t.captionLabel().style().movePadding(2, 2, -1, 2);
  t.captionLabel().style().moveMargin(-2, 3, 0, -3);
  t.captionLabel().style().backgroundWidth = 60;
}

void controlEvent(ControlEvent theEvent) {
  switch(int(theEvent.group().value())) {
  case 1:
    kinectSelected  = true;
    break;
  case 2:
    kinectSelected = false;
    break;
  case 3:
    drawLines = true;
    break;
  case 4:
    drawLines = false;
    break;
  default:
    kinectSelected = false;
    drawLines = false;
    break;
  }
}

