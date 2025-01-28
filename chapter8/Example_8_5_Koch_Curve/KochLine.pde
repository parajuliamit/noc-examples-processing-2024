// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Koch Curve
// A class to describe one line segment in the fractal
// Includes methods to calculate midPVectors along the line according to the Koch algorithm

class KochLine {
  // Two PVectors,
  // start is the "left" PVector and
  // end is the "right PVector
  PVector start, end;

  KochLine(PVector a, PVector b) {
    this.start = a.copy();
    this.end = b.copy();
  }

  void show() {
    stroke(0);
    strokeWeight(2);
    line(this.start.x, this.start.y, this.end.x, this.end.y);
  }

  PVector[] kochPoints() {
    // Just the first point!
    PVector a = this.start.copy();
    // Just the last point!
    PVector e = this.end.copy();

    // A vector pointing in the direction, 1/3rd the length
    PVector v = PVector.sub(this.end, this.start);
    v.mult(1 / 3f);

    // b is just 1/3 of the way
    PVector b = PVector.add(a, v);
    // d is just another 1/3 of the way
    PVector d = PVector.add(b, v);

    //{!1} Rotate by -PI/3 radians (negative angle so it rotates "up").
    v.rotate(-PI / 3);
    // Move along
    PVector c = PVector.add(b, v);

    // Return all five points in an array
    PVector[] points = {a, b, c, d, e};
    return points;
  }
}
