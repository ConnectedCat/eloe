//improt library for controls
import controlP5.*;
//import library for 
import librarytests.*;
import org.openkinect.*;
import org.openkinect.processing.*;
//import library for socket connection
import processing.net.*;
//import JSON parser library
import org.json.*;

//import moviemaking library
import processing.video.*;

Client client;

// Showing how we can farm all the kinect stuff out to a separate class
KinectTracker tracker;
// Kinect Library object
Kinect kinect;

Canvas canvas;

//MovieMaker mainMovie;  // Declare MovieMaker object
MovieMaker spyMovie;

boolean kinectConnected;
boolean kinectSelected;
PVector pointer;
int currentT, startT, wholeT;
int thick; 
int col;
int backColor; //in grayscale

int meditation, attention;
double lowAlpha, highAlpha, lowBeta, highBeta, lowGamma, highGamma, delta, theta;
boolean connection;
boolean randomize;

//controlP5 varailbles
ControlP5 uiControl;
float sliderDMin, sliderDMax;
float sliderRMin, sliderRMax;
int sliderX, sliderY, sliderW, sliderH;
String sliderDName;
String sliderRName;
RadioButton InputSelect;
int radioX, radioY;

int deg;
int range;
String filename;

void setup() {
  size(840, 480);
  smooth();

  client = new Client(this, "127.0.0.1", 13854);// connect to ThinkGearConnector
  String config = "{\"enableRawOutput\": true, \"format\": \"Json\"}"; //Command for the TGC to send JSON instead of raw bytes
  client.write(config); //send this command to TGC

  kinect = new Kinect(this);
  /*
  try {   
   kinect.enableDepth(true);
   kinectConnected = true;
   }  
   catch (NullPointerException ex) {
   kinectConnected = false;
   text("Kinect is not available", 660, height-20);
   }
   if (kinectConnected) {
   */
  tracker = new KinectTracker();

  deg = -7;
  range = tracker.threshold;
  backColor = 200;

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
  sliderY = 25;

  uiControl.addSlider(sliderDName, sliderDMin, sliderDMax, sliderX, sliderY, sliderW, sliderH);
  uiControl.addSlider(sliderRName, sliderRMin, sliderRMax, range, sliderX - 70, sliderY, sliderW, sliderH);

  radioX = 680;
  radioY = height-260;

  InputSelect = uiControl.addRadioButton("InputSelect", radioX, radioY+40);
  InputSelect.setColorBackground(color(0, 85, 122));
  InputSelect.setColorActive(color(255));
  InputSelect.setColorLabel(color(255));
  InputSelect.setItemsPerRow(2);
  InputSelect.setSpacingColumn(63);

  addToRadioButton(InputSelect, "Kinect", 1);
  addToRadioButton(InputSelect, "Mouse/Pad", 2);
  // }//set up for kinnect

  canvas = new Canvas(0, 0, 640, 480);
  
  connection = false;
  randomize = false;

  currentT = 0;
  startT = 0;
  wholeT = 1000;

  filename = "Drawing" + minute() + hour() + day() + month() + year();
 // mainMovie = new MovieMaker(this, width, height, filename + ".mov", 30, MovieMaker.ANIMATION, MovieMaker.LOW);
  spyMovie = new MovieMaker(this, width, height, filename + "Spy.mov", 30, MovieMaker.ANIMATION, MovieMaker.LOW);
}//end set up

void draw() {
  background(40);
  if(meditation > 0 || attention > 0){
    connection = true;
  }
  else {
    connection = false;
  }
  
  
  //random color and thickness every second
  if(randomize){
   currentT = millis();
   if (currentT-startT > wholeT) {
   startT = currentT;
   thick = int(random(3, 30));
   col = color(int(random(0, 255)), int(random(0, 255)), int(random(0, 255)));
   }
  }
  else{
  col = int(map(meditation, 0, 100, -16777216, -1));
  thick = int(map(attention, 0, 100, 30, 1));
  }
  text("Attention value is: " + attention, 660, height - 100);
  text("Thickeness is: " + thick, 660, height-60);
  text("Meditation value is: " + meditation, 660, height-180);
  text("Color is: " + col, 660, height-140);
  //end color and thickness
  if(connection){

  if (kinectSelected) {
    tracker.track();
    tracker.display(backColor);
    PVector l = tracker.getPos();
    if (l.x != 0 && l.y != 0) {
      fill(125, 0, 225, 80);
      noStroke();
      ellipse(l.x, l.y, 30, 30);
    }
    canvas.drawLines(tracker.getPos(), thick, col);
  }//end if kinect selected
  else {

    fill(backColor);
    rect(0, 0, 640, 480);
    noFill();

    canvas.drawLines(pointer, thick, col);
  }//end else for mouse

  canvas.display();

  kinect.tilt(deg);
  tracker.setThreshold(range);
  
  PImage vid = tracker.getVideo();
  vid.loadPixels();
  spyMovie.addFrame(vid.pixels, 640, 480);
  
 // mainMovie.addFrame();
  }//end if connection
  else{
    fill(155, 70);
    noStroke();
    rect(canvas.Cx, canvas.Cy, canvas.Cwidth, canvas.Cheight);
    noFill();
    fill(255);
    text("Please wait for MindSet connection", canvas.Cwidth/2 - 100, canvas.Cheight/2);
    noFill();
  }//end else for if connection
 
}//end draw

void mousePressed() {
  pointer = new PVector(float(mouseX), float(mouseY));
}
void mouseDragged() {
  pointer = new PVector(float(mouseX), float(mouseY));
}

void keyPressed() {
  if (key == 'c') {
    canvas.clear();
  }
  if (key == 'q') {
    saveFile();
    tracker.quit();
    exit();
  }
  if (key == 's') {
    saveFile();
  }
  if (key == 'r') {
    randomize = !randomize;
  }
}

void saveFile() {
  spyMovie.finish();
 // mainMovie.finish();
  save(filename+".png");
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
  default:
    kinectSelected = false;
    break;
  }
}

void clientEvent (Client client) { //whenever we read something from TGC

  String response = client.readString(); //put whatever we read into a string
  client.clear(); //recommanded for non-Unix systems, clears the buffer for the next reading

  if (response != null) { // if our reading is not empty
    //println("we have response"); //fo' debuggin'
    String[] packets = split(response, "\r"); //split this long string into separate packets to be converted to JSON

    for (String packet:packets) { //foreach loop in Processing
      if (!packet.equals("")) { //check for empty packets
        // println(packet); //fo' debuggin'
        packet = "{ \"data\": [" + packet + "]}"; // formatting that ensures that data is wrapped in correct JSON - packet is pushed inside "data"
        try {
          JSONObject data = new JSONObject(packet); //creat a JSON object
          // println(data); //fo' debuggin'
          JSONArray results = data.getJSONArray("data"); // unwrapping the packet from "data" and putting it into JSON Array
          int numberOfElements = results.length(); // find the length of that array
          // loop through array
          for (int i = 0; i < numberOfElements; i++) { // go through this array
            JSONObject entry = results.getJSONObject(i);
            if (entry.getInt("poorSignalLevel") == 0) {
              // println (entry.getInt("poorSignalLevel")); //fo' debuggin'
              JSONObject eSense = entry.getJSONObject("eSense");
              meditation = eSense.getInt("meditation");
              attention =  eSense.getInt("attention");
              JSONObject eegPower = entry.getJSONObject("eegPower");
              highGamma = eegPower.getDouble("highGamma");
              lowGamma = eegPower.getDouble("lowGamma");
              theta = eegPower.getDouble("theta");
              highAlpha = eegPower.getDouble("highAlpha");
              lowBeta = eegPower.getDouble("lowBeta");
              delta = eegPower.getDouble("delta");
              highBeta = eegPower.getDouble("highBeta");
              lowAlpha = eegPower.getDouble("lowAlpha");
            }//end if Poor Signal Level is 0
          } // for
        }
        catch (JSONException e) {
          println ("There was an error parsing the JSONObject.");
        } // catch
      }//end of if packet != null
    }//end of foreach
  }// end if request != null
}

