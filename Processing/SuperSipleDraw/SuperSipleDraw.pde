//Variables
int y = 20;


void setup() 
{
  //Set the size of the sketch
  size(500, 500);
  //Set the background color
  background(255);
  smooth();
}

void draw() 
{
  
  stroke(0);
  strokeWeight(5);
  if(mousePressed) 
  {
    line(mouseX, mouseY, pmouseX, pmouseY);
  }
}
