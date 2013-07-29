class Ball {
  
  Body body;
  color ballColor;
  int radius;
  boolean toBeRemoved;
  
  // constructor
  Ball(float x, float y, int r, color c) {
    ballColor = c;
    radius = r;
    toBeRemoved = false;
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
    body.ballColor = ballColor;
  }
  
  void display(float scroll) {
    Vec2 bodyPosition = body.getPosition();
    Vec2 bodyPixelsPosition = box2d.worldToScreen(bodyPosition);
    ellipseMode(CENTER);
    fill(ballColor);
    ellipse(bodyPixelsPosition.x, bodyPixelsPosition.y - scroll, radius*2, radius*2);
    boolean isOutside = bodyPixelsPosition.y - scroll < -radius*2;
    return isOutside; // if the ball has "fallen" to the top of the screen, the game will end
  }
  
}

// given a body, return the ball it belongs to
Ball getBall(ArrayList<Ball> balls, Body body) {
  Ball matchedBall; 
  for(int i = 0; i < balls.size(); i++) {
    Ball ball = balls.get(i);
    if(ball.body == body) {
      matchedBall = ball;
    }
  }
  return matchedBall;
}

