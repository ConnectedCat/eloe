class KinectTracker {

  // Size of kinect image
  int kw = 640;
  int kh = 480;
  int threshold = 745;

  //anything in range?
  boolean inRange;

  // Raw location
  PVector loc;

  // Interpolated location
  PVector lerpedLoc;

  // Depth data
  int[] depth;


  PImage display;
  PImage video;

  KinectTracker() {
    kinect.start();
    kinect.enableDepth(true);
    kinect.enableRGB(true);

    // We could skip processing the grayscale image for efficiency
    // but this example is just demonstrating everything
    kinect.processDepthImage(true);

    display = createImage(kw, kh, PConstants.RGB);
    video = createImage(kw, kh, PConstants.RGB);

    inRange = false;

    loc = new PVector(0, 0);
    lerpedLoc = new PVector(0, 0);
  }

  void track() {
    // Get the raw depth as array of integers
    depth = kinect.getRawDepth();

    // Being overly cautious here
    if (depth == null) return;

    float sumX = 0;
    float sumY = 0;
    float count = 0;

    for (int x = 0; x < kw; x++) {
      for (int y = 0; y < kh; y++) {
        // Mirroring the image
        int offset = kw-x-1+y*kw;
        // Grabbing the raw depth
        int rawDepth = depth[offset];

        // Testing against threshold
        if (rawDepth < threshold) {
          sumX += x;
          sumY += y;
          count++;
        }//end if beyond threshold
      }//end for loop
    }//end outer for loop

    // As long as we found something
    if (count != 0) {
      loc = new PVector(sumX/count, sumY/count);
    }
    if (count > 20) {
      inRange = true;
    }
    else {
      inRange = false;
    }

    // Interpolating the location, doing it arbitrarily for now
    lerpedLoc.x = PApplet.lerp(lerpedLoc.x, loc.x, 0.3f);
    lerpedLoc.y = PApplet.lerp(lerpedLoc.y, loc.y, 0.3f);
  }

  PVector getLerpedPos() {
    return lerpedLoc;
  }

  PVector getPos() {
    return loc;
  }
  PImage getVideo() {
    video = kinect.getVideoImage();
    return  video;
  }

  void display(int _backColor) {
    PImage img = kinect.getDepthImage();

    // Being overly cautious here
    if (depth == null || img == null) return;

    // Going to rewrite the depth image to show which pixels are in threshold
    // A lot of this is redundant, but this is just for demonstration purposes
    display.loadPixels();
    for (int x = 0; x < kw; x++) {
      for (int y = 0; y < kh; y++) {
        // mirroring image
        int offset = kw-x-1+y*kw;
        // Raw depth
        int rawDepth = depth[offset];

        int pix = x+y*display.width;
        if (rawDepth < threshold) {
          // A red color instead
          display.pixels[pix] = color(200, 50, 50); //paint it red
        } 
        else {
          display.pixels[pix] = color(_backColor);  //paint it grey
        }
      }
    }
    display.updatePixels();

    // Draw the image
    image(display, 0, 0);
  }//end display

  void quit() {
    kinect.quit();
  }

  int getThreshold() {
    return threshold;
  }

  void setThreshold(int t) {
    threshold =  t;
  }
}

