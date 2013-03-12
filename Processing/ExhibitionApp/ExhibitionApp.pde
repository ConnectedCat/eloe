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

//---------------------Done with Libraries--------------------//

//Kinect:
Kinect kinect;
KinectTracker tracker;
//Network connection for JSON stream:
Client client;
//Drawing canvas
Canvas canvas;
//MovieMaker mainMovie;  // Declare MovieMaker object
MovieMaker spyMovie;

boolean connect;
boolean disconnect;

boolean Input; //true is Kinect, false is mouse/drawing tablet
boolean kinectSelected;
PVector pointer;
int currentT, startT, wholeT;
int thick; 
int col;
int backColor;

//for MindSet
int meditation, attention;
double lowAlpha, highAlpha, lowBeta, highBeta, lowGamma, highGamma, delta, theta;
int BadSignal;

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
  
  connect = false;
  
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
  //uiControl.addSlider(sliderRName, sliderRMin, sliderRMax, range, sliderX - 70, sliderY, sliderW, sliderH);

  // }//set up for kinnect

  uiControl.addToggle("Input", false, 695, height - 220, 85, 20).setMode(ControlP5.SWITCH);
  uiControl.addToggle("Blah", false, 695, height - 180, 50, 20);

  canvas = new Canvas(0, 0, 640, 480);

  currentT = 0;
  startT = 0;
  wholeT = 1000;

  filename = "Drawing" + minute() + hour() + day() + month() + year();
  spyMovie = new MovieMaker(this, width, height, filename + "Spy.mov", 30, MovieMaker.ANIMATION, MovieMaker.LOW);
}//end set up

void draw() {
  background(40);
  if(connect){
  client = new Client(this, "127.0.0.1", 13854);// connect to ThinkGearConnector
  String config = "{\"enableRawOutput\": true, \"format\": \"Json\"}"; //Command for the TGC to send JSON instead of raw bytes
  client.write(config); //send this command to TGC
  connect = false;
  println("Connected!");
  }
  else if(disconnect){
    client.stop();
    disconnect = false;
    println("Disconnected!");
  }

  //set color and thickness of the line
  col = int(map(meditation, 0, 100, -16777216, -1));
  thick = int(map(attention, 0, 100, 30, 1));
  //show the current state to the user
  text("Attention value is: " + attention, 660, height - 80);
  text("Thickeness is: " + thick, 660, height-60);
  text("Meditation value is: " + meditation, 660, height-120);
  text("Color is: ", 660, height-100);
  fill(col);
  rect(720, height-115, 40, 20);
  noFill();
  //end color and thickness

  if (BadSignal == 0) {
    if (Input) {
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
  }//end if 
  else {
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
  if (key == 'r'){
    connect = !connect;
  }
  if (key == 't'){
    disconnect = !disconnect;
  }
}

void saveFile() {
  spyMovie.finish();
  // mainMovie.finish();
  save(filename+".png");
}

void exit() {
  tracker.quit();
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
            BadSignal = entry.getInt("poorSignalLevel");
            if (BadSignal == 0) {
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

