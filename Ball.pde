class Ball {
  
  Body body;
  int radius;
  
  Ball(float x, float y, int r) {
    radius = r;
    BodyDef bd = new BodyDef();
    bd.type = Body.b2_dynamicBody;
    bd.position.set(box2d.screenToWorld(x, y));
    body = box2d.m_world.CreateBody(bd);
    Vec2 bodyPosition = body.getPosition();
    Vec2 pos = box2d.screenToWorld(bodyPosition);
    float posX = pos.x;
    float posY = pos.y;
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.screenToWorld(radius);
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;
    body.createFixture(fd);
  }
  void display() {
    Vec2 bodyPosition = body.getPosition();
    Vec2 bodyPixelsPosition = box2d.worldToScreen(bodyPosition);
    ellipseMode(CENTER);
    fill(ballColor);
    ellipse(bodyPixelsPosition.x, bodyPixelsPosition.y - scroll, radius*2, radius*2);
  }
}
