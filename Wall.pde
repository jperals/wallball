class Wall {
  
  Body body;
  
  Wall(PVector[] path) {
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(path[0].x, path[0].y));
    body = box2d.createBody(bd);
    if(path.length > 0) {
      PVector oldPoint = path[0];
      for(int i = 1; i < path.length; i++) {
        PVector newPoint = path[i];
        PolygonShape ps = new PolygonShape();
        float distance = box2d.scalarPixelsToWorld(oldPoint.dist(newPoint));
        float w = distance*.5, h = box2d.scalarPixelsToWorld(1);
        float rotation = getAngle(oldPoint, newPoint);
        float pixelPosX = (oldPoint.x + newPoint.x)/2 - path[0].x;
        float pixelPosY = (oldPoint.y + newPoint.y)/2 - path[0].y;
        Vec2 center = new Vec2(box2d.scalarPixelsToWorld(pixelPosX), -box2d.scalarPixelsToWorld(pixelPosY));
        ps.setAsBox(w, h, center, -rotation);
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
    Vec2 bodyPosition = box2d.getBodyPixelCoord(body);
    for(Fixture f = body.getFixtureList(); f != null; f = f.getNext()) {
      PolygonShape shape = (PolygonShape)(f.getShape());
      Vec2[] vertices = shape.getVertices();
      beginShape();
      pushMatrix();
      translate(bodyPosition.x, bodyPosition.y);
      for(int i = 0; i < 4; i++) {
        Vec2 pos = new Vec2(box2d.scalarWorldToPixels(vertices[i].x), -box2d.scalarWorldToPixels(vertices[i].y));
        float x = pos.x;
        float y = pos.y;
        vertex(x, y);
      }
      endShape(CLOSE);
      popMatrix();
    }
  }
}
