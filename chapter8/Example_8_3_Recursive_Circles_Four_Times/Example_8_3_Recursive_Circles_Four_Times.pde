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

void drawCircles(float x, float y, float radius) {
  stroke(0);
  noFill();
  circle(x, y, radius * 2);
  if (radius > 16) {
    //{!4} drawCircle() calls itself four times.
    drawCircles(x + radius / 2, y, radius / 2);
    drawCircles(x - radius / 2, y, radius / 2);
    drawCircles(x, y + radius / 2, radius / 2);
    drawCircles(x, y - radius / 2, radius / 2);
  }
}
