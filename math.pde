// Simplifies a path to a given number of points (defined by pointsPerPath)
// It just selects a number of the existing points in the original path while leaving others out
// Original path is an ArrayList, whilst the returned simplified path is an Array
PVector[] simplifyPath(ArrayList<PVector> originalPath) {
  int simplifiedPathSize = Math.min(originalPath.size(), pointsPerPath);
  PVector[] simplifiedPath = new PVector[simplifiedPathSize];
  println("simplifiedPathSize: " + simplifiedPathSize);
  int jump = Math.round(originalPath.size()/(float)simplifiedPathSize);
  println("Math.round(" + originalPath.size() + "/" + simplifiedPathSize + ") = " + jump);
  int simplifiedPathIndex = 0;
  for(int originalPathIndex = 0; simplifiedPathIndex < simplifiedPathSize; originalPathIndex += jump) {
    simplifiedPath[simplifiedPathIndex] = originalPath.get(Math.min(originalPathIndex, originalPath.size() - 1));
    simplifiedPathIndex++;
  }
  return simplifiedPath;
}

// Our walls
class Wall {
  
  Body body;
  
  Wall(PVector[] path) {
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.scalarPixelsToWorld(path[0].x), box2d.scalarPixelsToWorld(path[0].y));
    println("path[0].x: " + path[0].x + ", path[0].y: " + path[0].y);
    body = box2d.createBody(bd);
    Vec2 bodyPosition = body.getPosition();
    float posX = box2d.scalarWorldToPixels(bodyPosition.x);
    float posY = box2d.scalarWorldToPixels(bodyPosition.y);
    println("posX: " + posX);
    println("posY: " + posY);
    if(path.length > 0) {
      PVector oldPoint = path[0];
      for(int i = 1; i < path.length; i++) {
        PVector newPoint = path[i];
        PolygonShape ps = new PolygonShape();
        float distance = box2d.scalarPixelsToWorld(oldPoint.dist(newPoint));
        float w = distance*0.75, h = box2d.scalarPixelsToWorld(5);
        float rotation;
        float dx = newPoint.x - oldPoint.x;
        float dy = newPoint.y - oldPoint.y;
        if(dx == 0) {
          if(dy > 0) {
            rotation = PI*3/2;
          }
          else {
            rotation = PI/2;
          }
        }
        else {
         rotation = atan(dy/dx);
        }
        Vec2 center = new Vec2(box2d.scalarPixelsToWorld(oldPoint.x + newPoint.x/2), box2d.scalarPixelsToWorld(oldPoint.y + newPoint.y/2));
        println("w: " + w + ", " + "h: " + h + ", center: " + center + ", rotation: " + rotation); 
        ps.setAsBox(w, h, center, rotation);
        FixtureDef fd = new FixtureDef();
        fd.shape = ps;
        fd.density = 1;
        fd.friction = 0.3;
        fd.restitution = 0.5;
        //println("createFixture");
        body.createFixture(fd);
        //println("created Fixture");
        oldPoint = newPoint;
      }
    }
  }
  void display() {
    Vec2 bodyPosition = body.getPosition();
    pushMatrix();
    //rectMode(CENTER);
    float posX = box2d.scalarWorldToPixels(bodyPosition.x);
    float posY = box2d.scalarWorldToPixels(bodyPosition.y);
    //println("posX: " + posX);
    //println("posY: " + posY);
    //translate(-posX/2, -posY/2);
    for(Fixture f = body.getFixtureList(); f != null; f = f.getNext()) {
      PolygonShape shape = (PolygonShape)(f.getShape());
      Vec2[] vertices = shape.getVertices();
      beginShape();
      //println("vertices.length: " + vertices.length);
      for(int i = 0; i < 4; i++) {
      //for(int i = 0; i < vertices.length; i++) {
        //println("vertices[i].x: " + vertices[i].x + ", vertices[i].y: " + vertices[i].y);
        float x = box2d.scalarWorldToPixels(vertices[i].x)*0.66667;
        float y = box2d.scalarWorldToPixels(vertices[i].y)*0.66667;
        vertex(x, y);
        //vertex(vertices[i].x, vertices[i].y);
      }
      endShape(CLOSE);
    }
    popMatrix();
  }
}
