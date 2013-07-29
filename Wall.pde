class Wall {

  Body body;
  color wallColor;
  color emptyColor;
  boolean toBeRemoved;
  boolean broken;
  PVector[] points;
  ArrayList<PVector[]> brokenLines;
  int fadeOutDuration;
  int fadeOutTimeout;

  // constructor
  Wall(PVector[] path) {

    points = path;
    emptyColor = color(100, 100, 100);
    wallColor = color(0);
    toBeRemoved = false;
    brokenLines = new ArrayList<PVector[]>();
    fadeOutDuration = 30;
    fadeOutTimeout = fadeOutDuration;

    BodyDef bd = new BodyDef();
    bd.type = Body.b2_staticBody;
    bd.position.set(box2d.screenToWorld(path[0].x, path[0].y));
    body = box2d.m_world.CreateBody(bd);
    if (path.length > 0) {
      PVector oldPoint = path[0];
      for (int i = 1; i < path.length; i++) {
        PVector newPoint = path[i];
        PolygonShape ps = new PolygonShape();
        float distance = box2d.screenToWorld(oldPoint.dist(newPoint));
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
        PVector[] brokenLine = new PVector[2];
        brokenLine[0] = oldPoint;
        brokenLine[1] = newPoint;
        brokenLines.add(brokenLine);
        oldPoint = newPoint;
      }
    }
  }

  void breakWall(Physics box2d) {
    box2d.removeBody(body);
    //walls.remove(wall);
    toBeRemoved = false;
    broken = true;
  }

  void combineColor(color newColor) {
    float oldRed = wallColor >> 16 & 0xFF;
    float oldGreen = wallColor >> 8 & 0xFF;
    float oldBlue = wallColor & 0xFF;
    float newRed = newColor >> 16 & 0xFF;
    float newGreen = newColor >> 8 & 0xFF;
    float newBlue = newColor & 0xFF;
    float redValue = oldRed | newRed;
    float greenValue = oldGreen | newGreen;
    float blueValue = oldBlue | newBlue;
    boolean wallBreaks = false;
    wallColor = color(redValue, greenValue, blueValue);
    if (redValue == 255 && greenValue == 255 && blueValue == 255) {
      remove();
      wallBreaks = true;
    }
    return wallBreaks;
  }

  void display(float scroll) {
    if (brightness(wallColor) == 0) {
      fill(emptyColor);
      stroke(emptyColor);
    }
    else {
      fill(wallColor);
      stroke(wallColor);
    }
    if(broken) {
      if(fadeOutDuration > 0) {
        wallColor = color(red(wallColor), green(wallColor), blue(wallColor), 255*fadeOutTimeout/fadeOutDuration);
        for(var i = 1; i < brokenLines.size(); i++) {
          PVector p1 = points[i-1];
          PVector p2 = points[i];
          line(p1.x, p1.y - scroll, p2.x, p2.y - scroll);
        }
      }
      fadeOutTimeout--;
    }
    else {
      Vec2 bodyPosition = box2d.worldToScreen(body.getWorldCenter());
      for (Fixture f = body.getFixtureList(); f != null; f = f.GetNext()) {
        PolygonShape shape = (PolygonShape)(f.GetShape());
        Vec2[] vertices = shape.GetVertices();
        beginShape();
        pushMatrix();
        translate(bodyPosition.x, bodyPosition.y - scroll);
        for (int i = 0; i < 4; i++) {
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

  void remove() {
    wallSound.cue(0);
    wallSound.play();
    toBeRemoved = true; // the body will be removed on the next iteration
  }
}

// given a body, return the wall it belongs to
Wall getWall(ArrayList<Wall> walls, Body body) {
  Wall matchedWall; 
  for (int i = 0; i < walls.size(); i++) {
    Wall wall = walls.get(i);
    if (wall.body == body) {
      matchedWall = wall;
    }
  }
  return matchedWall;
}

