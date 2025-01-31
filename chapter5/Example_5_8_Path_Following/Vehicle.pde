// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// The "Vehicle" class

class Vehicle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxspeed;
  float maxforce;
  
  Vehicle(float x, float y, float ms, float mf) {
    this.position = new PVector(x, y);
    this.acceleration = new PVector(0, 0);
    this.velocity = new PVector(2, 0);
    this.r = 4;
    this.maxspeed = ms; // || 4;
    this.maxforce = mf; // || 0.1;
  }

  void run() {
    this.update();
    this.show();
  }

  // This function implements Craig Reynolds' path following algorithm
  // http://www.red3d.com/cwr/steer/PathFollow.html
  void follow(Path path) {
    // Predict location 50 (arbitrary choice) frames ahead
    // This could be based on speed
    PVector future = this.velocity.copy();
    future.setMag(50);
    future.add(this.position);

    // Now we must find the normal to the path from the predicted location
    // We look at the normal for each line segment and pick out the closest one
    PVector target = null;
    PVector normal = null;
    float worldRecord = Float.MAX_VALUE; // Start with a very high record distance that can easily be beaten

    // Loop through all points of the path
    for (int i = 0; i < path.points.size() - 1; i++) {
      // Look at a line segment
      PVector a = path.points.get(i);
      PVector b = path.points.get(i + 1);

      // Get the normal point to that line
      PVector normalPoint = getNormalPoint(future, a, b);
      // This only works because we know our path goes from left to right
      // We could have a more sophisticated test to tell if the point is in the line segment or not
      if (normalPoint.x < a.x || normalPoint.x > b.x) {
        // This is something of a hacky solution, but if it's not within the line segment
        // consider the normal to just be the end of the line segment (point b)
        normalPoint = b.copy();
      }

      // How far away are we from the path?
      float distance = PVector.dist(future, normalPoint);
      // Did we beat the record and find the closest line segment?
      if (distance < worldRecord) {
        worldRecord = distance;
        // If so the target we want to steer towards is the normal
        normal = normalPoint;
        target = normalPoint.copy();

        // Look at the direction of the line segment so we can seek a little bit ahead of the normal
        PVector dir = PVector.sub(b, a);
        // This is an oversimplification
        // Should be based on distance to path & velocity
        dir.setMag(10);
        target.add(dir);
      }
    }

    // Only if the distance is greater than the path's radius do we bother to steer
    if (worldRecord > path.radius && target != null) {
      this.seek(target);
    }

    // Draw the debugging stuff
    if (debug) {
      // Draw predicted future location
      stroke(0);
      fill(127);
      line(this.position.x, this.position.y, future.x, future.y);
      ellipse(future.x, future.y, 4, 4);

      // Draw normal location
      if(normal!= null){
        stroke(0);
        fill(127);
        circle(normal.x, normal.y, 4);
        // Draw actual target (red if steering towards it)
        line(future.x, future.y, normal.x, normal.y);
        if (worldRecord > path.radius) fill(255, 0, 0);
        noStroke();
        if(target != null){
          circle(target.x, target.y, 8);
        }
      }
    }
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    this.acceleration.add(force);
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  void seek(PVector target) {
    PVector desired = PVector.sub(target, this.position); // A vector pointing from the position to the target

    // If the magnitude of desired equals 0, skip out of here
    // (We could optimize this to check if x and y are 0 to avoid mag() square root
    if (desired.mag() == 0) return;

    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(this.maxspeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, this.velocity);
    steer.limit(this.maxforce); // Limit to maximum steering force

    this.applyForce(steer);
  }

  // Method to update position
  void update() {
    // Update velocity
    this.velocity.add(this.acceleration);
    // Limit speed
    this.velocity.limit(this.maxspeed);
    this.position.add(this.velocity);
    // Reset accelerationelertion to 0 each cycle
    this.acceleration.mult(0);
  }

  // Wraparound
  void borders(Path path) {
    if (this.position.x > path.getEnd().x + this.r) {
      this.position.x = path.getStart().x - this.r;
      this.position.y = path.getStart().y + (this.position.y - path.getEnd().y);
    }
  }

  void show() {
    // Draw a triangle rotated in the direction of velocity
    float theta = this.velocity.heading();
    fill(127);
    stroke(0);
    strokeWeight(2);
    push();
    translate(this.position.x, this.position.y);
    rotate(theta);
    beginShape();
    vertex(this.r * 2, 0);
    vertex(-this.r * 2, -this.r);
    vertex(-this.r * 2, this.r);
    endShape(CLOSE);
    pop();
  }
}

// A function to get the normal point from a point (p) to a line segment (a-b)
// This function could be optimized to make fewer new Vector objects
PVector getNormalPoint(PVector p, PVector a, PVector b) {
  // Vector from a to p
  PVector ap = PVector.sub(p, a);
  // Vector from a to b
  PVector ab = PVector.sub(b, a);
  ab.normalize(); // Normalize the line
  // Project vector "diff" onto line by using the dot product
  ab.mult(ap.dot(ab));
  PVector normalPoint = PVector.add(a, ab);
  return normalPoint;
}
