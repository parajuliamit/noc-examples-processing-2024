// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Koch Curve
// Renders a simple fractal, the Koch snowflake
// Each recursive level drawn in sequence

import java.util.List;

// An array for all the line segments
List<KochLine> segments = new ArrayList();

void setup() {
  size(640, 360);
  // Left side of canvas
  PVector start = new PVector(0, 300);
  // Right side of canvas
  PVector end = new PVector(width, 300);

  //{!1} The first KochLine object
  segments.add(new KochLine(start, end));

  //{!3} Apply the Koch rules five times.
  for (int i = 0; i < 5; i++) {
    generate();
  }
}

void draw() {
  background(255);
  for (KochLine segment : segments) {
    segment.show();
  }
  noLoop();
}

void generate() {
  // Create the next array
  List<KochLine> next = new ArrayList();
  // For every segment
  for (KochLine segment : segments) {
    // Calculate 5 koch PVectors (done for us by the line object)
    PVector[] kochPoints = segment.kochPoints();
    PVector a = kochPoints[0];
    PVector b = kochPoints[1];
    PVector c = kochPoints[2];
    PVector d = kochPoints[3];
    PVector e = kochPoints[4];
    // Make line segments between all the vectors and add them
    next.add(new KochLine(a, b));
    next.add(new KochLine(b, c));
    next.add(new KochLine(c, d));
    next.add(new KochLine(d, e));
  }
  // The next segments!
  segments = next;
}
