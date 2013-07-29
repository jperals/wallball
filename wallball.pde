// The GPL License
// Copyright (c) 2013 Joan Perals Tresserra

import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

ArrayList<Wall> walls;
ArrayList<Ball> balls;
ArrayList<PVector> newPath;
AudioPlayer ballSound;
AudioPlayer wallSound;
color bgColor = 0;
color[] ballColors;
color nextBallColor;
int pointsPerPath;
Physics box2d;
float scroll;
float dScroll;
float ddScroll;
int nextBallPosition;
int nextBallCountDown;
int addBallEvery;
int score;
CollisionDetector detector;
boolean gameOver;

Maxim maxim;

void setup() {

  size(640, 800);
  frameRate(30);
  
  ballRadius = 10;
  addBallEvery = 80;
  bgColor = 0;
  ballColors = new color[]{#FF0000, #00FF00, #0000FF};
  pointsPerPath = 30;
  scroll = 0;
  dScroll = 0.1;
  ddScroll = 0.0001;
  score = 0;
  gameOver = false;
  
  maxim = new Maxim(this);
  ballSound = maxim.loadFile("ball.wav");
  ballSound.setLooping = false;
  wallSound = maxim.loadFile("beam.wav");
  wallSound.setLooping = false;
    
  box2d = new Physics(this, width, height, 0, -5, width*2, height*2, width, height, 100);
  box2d.setCustomRenderingMethod(this, "myCustomRenderer");
  box2d.setDensity(10.0);
  detector = new CollisionDetector (box2d, this);
  
  balls = new ArrayList<Ball>();
  walls = new ArrayList<Wall>();
  newPath = new ArrayList<PVector>();
  prepareNextBall();

}

void draw() {
  
  background(bgColor);
  fill(255);
  
  if(gameOver) {
    textAlign(CENTER, CENTER);
    textSize(20);
    text("Game Over!\nScore: " + score, width/2, height/2);
  }
  else {
    text("score: " + score, 20, 20);
    if(addBallEvery - nextBallCountDown > 60) { // wait for the current ball to fall, otherwise it's confusing
      drawNextBallIndicator();
    }    
    if(nextBallCountDown == 0) {
      addNewBall();
    }
    nextBallCountDown --;
    scroll += dScroll;
    dScroll += ddScroll;
  }
  
}

void mousePressed() {
  newPath.add(new PVector(mouseX, mouseY + scroll));
}

void mouseDragged() {
  newPath.add(new PVector(mouseX, mouseY + scroll));
}

void mouseReleased() {
  PVector[] simplifiedPath = simplifyPath(newPath);
  newPath = new ArrayList<PVector>();
  Wall wall =  new Wall(simplifiedPath);
  walls.add(wall);
}

void myCustomRenderer(World world) {
  if(!gameOver) {
    noStroke();
    for(int i = 0; i < balls.size(); i++) {
      Ball ball = balls.get(i);
      if(ball.toBeRemoved) {
        box2d.removeBody(ball.body);
        balls.remove(ball);
      }
      else {
        gameOver = gameOver || ball.display(scroll); // if the ball has "fallen" to the top of the screen, the game will end
      }
    }
    for(int i = 0; i < walls.size(); i++) {
      Wall wall = walls.get(i);
      if(wall.toBeRemoved) {
        wall.breakWall(box2d);
      }
      else {
        wall.display(scroll);
      }
    }
  }
}

void addNewBall() {
  Ball ball = new Ball(nextBallPosition, scroll - ballRadius, ballRadius, nextBallColor);
  balls.add(ball);
  prepareNextBall();
}

void collision(Body b1, Body b2, float impulse) {
  if(!gameOver && (b1.getMass() != 0 || b2.getMass() != 0)) { // at least one of the two entities that collided is a ball
    playBallSound(impulse);
    if(b1.getMass() != 0 && b1.getMass() != 0) { // both entities are balls
      score += int(impulse*1000);
    }
    else { // one is a ball and the other is a wall
      Ball ball;
      Wall wall;
      if(b1.getMass() != 0) {
        ball = getBall(balls, b1);
        wall = getWall(walls, b2);
      }
      else {
        ball = getBall(balls, b2);
        wall = getWall(walls, b1);
      }
      color ballColor = ball.ballColor;
      if(wall.combineColor(ballColor)) {
        score += 1000;
      }
    }
  }
}

void drawNextBallIndicator() {
  fill(nextBallColor);
  noStroke();
  pushMatrix();
  translate(nextBallPosition, 10);
  triangle(0, 0, 10, 10, -10, 10);
  popMatrix();
}

color getRandomBallColor() {
  int index = int(random(ballColors.length));
  index = min(index, ballColors.length - 1);
  return ballColors[index];
}

void playBallSound(float volume) {
    ballSound.volume(volume);
    ballSound.cue(0);
    ballSound.play();
}

void prepareNextBall() {
  nextBallColor = getRandomBallColor();
  nextBallPosition = random(width);
  nextBallCountDown = addBallEvery;
}

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

// Simplifies a path to a given number of points (defined by pointsPerPath)
// It just selects a number of the existing points in the original path while leaving others out
// Original path is an ArrayList, whilst the returned simplified path is an Array
PVector[] simplifyPath(ArrayList<PVector> originalPath) {
  int simplifiedPathSize = Math.min(originalPath.size(), pointsPerPath);
  PVector[] simplifiedPath = new PVector[simplifiedPathSize];
  int jump = Math.round(originalPath.size()/(float)simplifiedPathSize);
  int simplifiedPathIndex = 0;
  for(int originalPathIndex = 0; simplifiedPathIndex < simplifiedPathSize; originalPathIndex += jump) {
    simplifiedPath[simplifiedPathIndex] = originalPath.get(Math.min(originalPathIndex, originalPath.size() - 1));
    simplifiedPathIndex++;
  }
  return simplifiedPath;
}

// Returns the angle of the vector that connects two given points in space
float getAngle(PVector oldPoint, PVector newPoint) {
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
  return rotation;
}

