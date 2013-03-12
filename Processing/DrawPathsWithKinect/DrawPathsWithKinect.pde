import controlP5.*;

import librarytests.*;
import org.openkinect.*;
import org.openkinect.processing.*;

int thick;
color col;
int currentT, startT, wholeT;
PVector loc;
PVector prevLoc;
Path pth;
boolean addTrail;

boolean kinectSelected, drawLines;

ArrayList <ArrayList> Trails = new ArrayList <ArrayList> ();//array of lines
int currentTrail;

// Showing how we can farm all the kinect stuff out to a separate class
KinectTracker tracker;
// Kinect Library object
Kinect kinect;

//controlP5 varailbles
ControlP5 uiControl;
float sliderDMin, sliderDMax;
float sliderRMin, sliderRMax;
int sliderX, sliderY, sliderW, sliderH;
String sliderDName;
String sliderRName;
RadioButton InputSelect;
RadioButton ModeSelect;
int radioX, radioY;

int deg;
int range;

void setup() {
  size(840, 480);
  smooth();

  kinect = new Kinect(this);
  tracker = new KinectTracker();
  loc = new PVector(0, 0);
  prevLoc = new PVector(0, 0);

  deg = 0;
  range = tracker.threshold;

  currentT = 0;
  startT = 0;
  wholeT = 1000;

  currentTrail = 0;
  addTrail = true;

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
  sliderY = 50;

  uiControl.addSlider(sliderDName, sliderDMin, sliderDMax, sliderX, sliderY, sliderW, sliderH);
  uiControl.addSlider(sliderRName, sliderRMin, sliderRMax, range, sliderX - 100, sliderY, sliderW, sliderH);

  radioX = 680;
  radioY = height-160;

  InputSelect = uiControl.addRadioButton("inputSelect", radioX, radioY);
  InputSelect.setColorBackground(color(0, 85, 122));
  InputSelect.setColorActive(color(255));
  InputSelect.setColorLabel(color(255));//text in the button field
  InputSelect.setItemsPerRow(2);
  InputSelect.setSpacingColumn(63);

  addToRadioButton(InputSelect, "Kinect", 1);
  addToRadioButton(InputSelect, "Tablet", 2);

  ModeSelect = uiControl.addRadioButton("modeSelect", radioX, radioY+40);
  ModeSelect.setColorBackground(color(0, 85, 122));
  ModeSelect.setColorActive(color(255));
  ModeSelect.setColorLabel(color(255));
  ModeSelect.setItemsPerRow(2);
  ModeSelect.setSpacingColumn(63);

  addToRadioButton(ModeSelect, "Draw Lines", 3);
  addToRadioButton(ModeSelect, "Spay Circles", 4);

  kinectSelected = false;
  drawLines = false;
}//end setup

void draw() {
 // background(40);

  currentT = millis();
  if (currentT-startT > wholeT) {
    startT = currentT;
    thick = int(random(3, 30));
    col = color(int(random(0, 255)), int(random(0, 255)), int(random(0, 255)));
  }

  if (Trails.size() == 0) {
    Trails.add(new ArrayList());
  }

  if (kinectSelected) {  //what to do with Kinect
    tracker.track();
    tracker.display();

    kinect.tilt(deg);
    tracker.setThreshold(range);

    if (tracker.inRange) {
      //println("tracker position = " + tracker.getPos());  //fo debuggin'
      loc = tracker.getPos();
      if (prevLoc.x == 0 && prevLoc.y == 0) {
        prevLoc = loc;
      }

      ArrayList Paths = (ArrayList)Trails.get(currentTrail);
      Paths.add(new Path(prevLoc, loc, thick, col));
      if (!addTrail) {
        addTrail = true;
      }
      prevLoc = loc;
    }//end if tracker in range
    else {
      if (addTrail) {
        Trails.add(new ArrayList());
        currentTrail++;
        addTrail = false;
        prevLoc.x = prevLoc.y = 0;
      }//end inner if
    }//end else
  }//end if kinect selected
  else {            //what to do with mouse/pad

    if (mousePressed) {
      loc.x = mouseX;
      loc.y = mouseY;
      println("Loc for mouse : " + loc);
      if (prevLoc.x == 0 && prevLoc.y == 0) {
        prevLoc = loc;
      }
      println("Current trail :" + currentTrail);
      println("Prevloc for mouse is : " + prevLoc);
      
      ArrayList Paths = (ArrayList)Trails.get(currentTrail);
      Paths.add(new Path(prevLoc, loc, thick, col));
      
      if (!addTrail) {
        addTrail = true;
      }
      prevLoc = loc;
    }
    else {
      if (addTrail) {
        Trails.add(new ArrayList());
        currentTrail++;
        addTrail = false;
      }// end if add trail
    }
  }// end else for mouse

    //draw all the stuff
  // println("Trails size: " + Trails.size()); //fo debuggin'
  for (int i=0; i<Trails.size(); i++) {          //run through all the trails in the big array list
    ArrayList tr = (ArrayList)Trails.get(i);    //every trail is an array list itself
   // println("Trail " + i + " size is " + tr.size());  //fo debuggin'
    for (int j = 0; j<tr.size(); j++) {          //run through all thr PVectors in the path
      Path p = (Path)tr.get(j);
      if (p.loc.x != 0 && p.loc.y != 0) { // for some reason loc is set to 0 when tracker.inRange goes from true to false. We dont want those lines going to upper left corner all the time!!
        p.drawPath();
      }
    }//end inner for loop
  }//end outer for loop
}//end draw

void keyPressed() {
  if (key == 'c') {
    clear();
  }
  if (key == 'q') {
    tracker.quit();
    super.stop();
  }
  if (key == 's') {
    String filename = "BrainDoodle" + minute() + hour() + day() + month() + year() + ".png";
    save(filename);
  }
}

void clear() {
  for (int i=0; i<Trails.size(); i++) {          //run through all the trails in the big array list
    Trails.remove(i);    //remove one by one
  }//end outer for loop
}

//radio button functions
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

