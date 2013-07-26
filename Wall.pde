class Wall {
  
  Body body;
  
  Wall(PVector[] path) {
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
  void display() {
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
