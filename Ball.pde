class Ball {
  
  Body body;
  
  Ball(float x, float y) {
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(x, y));
    println("x: " + x + ", y: " + y);
    body = box2d.createBody(bd);
    Vec2 bodyPosition = body.getPosition();
    Vec2 pos = box2d.coordWorldToPixels(bodyPosition);
    float posX = pos.x;
    float posY = pos.y;
    println("posX: " + posX);
    println("posY: " + posY);
    CircleShape cs = new CircleShape();
    cs.m_radius = 1;
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;
    body.createFixture(fd);
  }
  void display() {
    Vec2 bodyPosition = box2d.getBodyPixelCoord(body);
    ellipseMode(CENTER);
    ellipse(bodyPosition.x, bodyPosition.y, 20, 20);
  }
}
