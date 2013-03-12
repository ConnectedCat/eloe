//import library for socket connection
import processing.net.*;
//import JSON parser library
import org.json.*;


Client client;

Canvas canvas;

PVector pointer;
int currentT, startT, wholeT;
int thick; 
int col;
int backColor; //in grayscale

int meditation, attention;
double lowAlpha, highAlpha, lowBeta, highBeta, lowGamma, highGamma, delta, theta;
boolean connection;
boolean randomize;

String filename;

void setup() {
  size(840, 480);
  smooth();

  client = new Client(this, "127.0.0.1", 13854);// connect to ThinkGearConnector
  String config = "{\"enableRawOutput\": true, \"format\": \"Json\"}"; //Command for the TGC to send JSON instead of raw bytes
  client.write(config); //send this command to TGC

  canvas = new Canvas(0, 0, 640, 480);
  
  connection = false;
  randomize = false;

  currentT = 0;
  startT = 0;
  wholeT = 1000;
  
  backColor = 255;
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

    fill(backColor);
    rect(0, 0, 640, 480);
    noFill();

    canvas.drawLines(pointer, thick, col);

  canvas.display();
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
 // mainMovie.finish();
 filename = "Drawing" + minute() + hour() + day() + month() + year();
  save(filename+".png");
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

