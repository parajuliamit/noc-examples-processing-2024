// Bob object, just like our regular Mover (location, velocity, acceleration, mass)

class Bob {
  PVector position, velocity, acceleration;
  float mass, damping;
  PVector dragOffset;
  boolean dragging;
  
  Bob(float x, float y) {
    this.position = new PVector(x, y);
    this.velocity = new PVector();
    this.acceleration = new PVector();
    this.mass = 24;
    // Arbitrary damping to simulate friction / drag
    this.damping = 0.98;
    // For user interaction
    this.dragOffset = new PVector();
    this.dragging = false;
  }

  // Standard Euler integration
  void update() {
    this.velocity.add(this.acceleration);
    this.velocity.mult(this.damping);
    this.position.add(this.velocity);
    this.acceleration.mult(0);
  }

  // Newton's law: F = M * A
  void applyForce(PVector force) {
    PVector f = force.copy();
    f.div(this.mass);
    this.acceleration.add(f);
  }

  // Draw the bob
  void show() {
    stroke(0);
    strokeWeight(2);
    fill(127);
    if (this.dragging) {
      fill(200);
    }
    circle(this.position.x, this.position.y, this.mass * 2);
  }

  void handleClick(float mx, float my) {
    float d = dist(mx, my, this.position.x, this.position.y);
    if (d < this.mass) {
      this.dragging = true;
      this.dragOffset.x = this.position.x - mx;
      this.dragOffset.y = this.position.y - my;
    }
  }

  void stopDragging() {
    this.dragging = false;
  }

  void handleDrag(float mx, float my) {
    if (this.dragging) {
      this.position.x = mx + this.dragOffset.x;
      this.position.y = my + this.dragOffset.y;
    }
  }
}
