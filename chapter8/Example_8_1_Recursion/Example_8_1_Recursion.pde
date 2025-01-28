// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Simple Recursion

void setup() {
  size(640, 360);
}

void draw() {
  background(255);
  drawCircles(width / 2, height / 2, width / 2);
  noLoop();
}

// Very simple function that draws one circle
// and recursively calls itself
void drawCircles(int x, int y, float r) {
  stroke(0);
  strokeWeight(2);
  circle(x, y, r * 2);
  // Exit condition, stop when radius is too small
  if (r > 4) {
    r *= 0.75;
    // Call the function inside the function! (recursion!)
    drawCircles(x, y, r);
  }
}
