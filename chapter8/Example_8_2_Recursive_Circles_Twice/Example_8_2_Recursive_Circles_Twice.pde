// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Simple Recursion

void setup() {
  size(640, 360);
}

void draw() {
  background(255);
  drawCircles(width / 2, height / 2, 320);
  noLoop();
}

void drawCircles(float x, int y, float radius) {
  stroke(0);
  strokeWeight(2);
  noFill();
  circle(x, y, radius * 2);
  if (radius > 4) {
    //{!2} drawCircles() calls itself twice. For every circle, a smaller circle is drawn to the left and the right.
    drawCircles(x + radius / 2, y, radius / 2);
    drawCircles(x - radius / 2, y, radius / 2);
  }
}
