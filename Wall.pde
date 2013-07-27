class Wall {
  
  Body body;
  color wallColor;
  color emptyColor;
  boolean toBeRemoved;
  
  Wall(PVector[] path) {
    emptyColor = color(100, 100, 100);
    wallColor = color(255);
    toBeRemoved = false;
    BodyDef bd = new BodyDef();
    bd.type = Body.b2_staticBody;
    bd.position.set(box2d.screenToWorld(path[0].x, path[0].y));
    body = box2d.m_world.CreateBody(bd);
    if(path.length > 0) {
      PVector oldPoint = path[0];
      for(int i = 1; i < path.length; i++) {
        PVector newPoint = path[i];
        PolygonShape ps = new PolygonShape();
        float distance = box2d.screenToWorld(oldPoint.dist(newPoint));
        //println(distance);
        //float wallWidth = 0.1 + min(3, 0.2/distance);
        float wallWidth = 0.5;
        float w = distance*.5, h = box2d.screenToWorld(wallWidth);
        float rotation = getAngle(oldPoint, newPoint);
        float pixelPosX = (oldPoint.x + newPoint.x)/2 - path[0].x;
        float pixelPosY = (oldPoint.y + newPoint.y)/2 - path[0].y;
        Vec2 center = box2d.screenToWorld(pixelPosX, pixelPosY);
        ps.SetAsOrientedBox(w, h, center, rotation);
        FixtureDef fd = new FixtureDef();
        fd.shape = ps;
        fd.density = 1;
        fd.friction = 0.3;
        fd.restitution = 0.5;
        body.createFixture(fd);
        oldPoint = newPoint;
      }
    }
  }
  
  void addColor(color newColor) {
    float oldRed = wallColor >> 16 & 0xFF;
    float oldGreen = wallColor >> 8 & 0xFF;
    float oldBlue = wallColor & 0xFF;
    float newRed = newColor >> 16 & 0xFF;
    float newGreen = newColor >> 8 & 0xFF;
    float newBlue = newColor & 0xFF;
    float redValue = oldRed & ~newRed;
    float greenValue = oldGreen & ~newGreen;
    float blueValue = oldBlue & ~newBlue;
    wallColor = color(redValue, greenValue, blueValue);
    if(redValue == 0 && greenValue == 0 && blueValue == 0) {
      toBeRemoved = true;
      score ++;
    }
  }
  
  void display() {
    if(brightness(wallColor) == 0) {
      fill(emptyColor);
      stroke(emptyColor);
    }
    else {
      fill(wallColor);
      stroke(wallColor);
    }
    Vec2 bodyPosition = box2d.worldToScreen(body.getWorldCenter());
    for(Fixture f = body.getFixtureList(); f != null; f = f.GetNext()) {
      PolygonShape shape = (PolygonShape)(f.GetShape());
      Vec2[] vertices = shape.GetVertices();
      beginShape();
      pushMatrix();
      translate(bodyPosition.x, bodyPosition.y - scroll);
      for(int i = 0; i < 4; i++) {
        Vec2 pos = box2d.worldToScreen(vertices[i].x, vertices[i].y);
        float x = pos.x;
        float y = pos.y;
        vertex(x, y);
      }
      endShape(CLOSE);
      popMatrix();
    }
  }
  
}

Wall getWall(ArrayList<Wall> walls, Body body) {
  Wall matchedWall; 
  for(int i = 0; i < walls.size(); i++) {
    Wall wall = walls.get(i);
    if(wall.body == body) {
      matchedWall = wall;
    }
  }
  return matchedWall;
}

