// The GPL License
// Copyright (c) 2013 Joan Perals Tresserra

import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

ArrayList<Wall> walls;
ArrayList<Ball> balls;
ArrayList<PVector> newPath;
color bgColor = 0;
color ballColor;
color wallColor;
int pointsPerPath;
Physics box2d;
float scroll;
int nextBallCountDown;
int addBallEvery;

void setup() {
  size(768, 768);
  bgColor = 0;
  ballColor = color(31, 255, 63);
  wallColor = color(110, 110, 100);
  box2d = new Physics(this, width, height, 0, -10, width*2, height*2, width, height, 100);
  box2d.setCustomRenderingMethod(this, "myCustomRenderer");
  box2d.setDensity(10.0);
  balls = new ArrayList<Ball>();
  walls = new ArrayList<Wall>();
  newPath = new ArrayList<PVector>();
  pointsPerPath = 10;
  scroll = 0;
  dScroll = 1;
  addBallEvery = 120;
  nextBallCountDown = addBallEvery;
  Ball ball = new Ball(width/2, scroll - 20, 10);
  balls.add(ball);
}

void draw() {
  background(bgColor);
  stroke(91, 91, 91);
  nextBallCountDown --;
  if(nextBallCountDown == 0) {
    Ball ball = new Ball(width/2, scroll - 20, 10);
    balls.add(ball);
    nextBallCountDown = addBallEvery;
  }
  scroll += dScroll;
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
  for(int i = 0; i < balls.size(); i++) {
    balls.get(i).display();
  }
  for(int i = 0; i < walls.size(); i++) {
    walls.get(i).display();
  }
}
