// The GPL License
// Copyright (c) 2013 Joan Perals Tresserra

import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

ArrayList<Wall> walls;
ArrayList<Ball> balls;
ArrayList<PVector> newPath;
color bgColor = 0;
int pointsPerPath;
PBox2D box2d;

void setup() {
  size(768, 768);
  box2d = new PBox2D(this);
  box2d.createWorld();
  balls = new ArrayList<Ball>();
  walls = new ArrayList<Wall>();
  newPath = new ArrayList<PVector>();
  pointsPerPath = 10;
}

void draw() {
  box2d.step();
  background(bgColor);
  fill(110, 110, 110);
  stroke(91, 91, 91);
  for(int i = 0; i < balls.size(); i++) {
    balls.get(i).display();
  }
  for(int i = 0; i < walls.size(); i++) {
    walls.get(i).display();
  }
}

void mousePressed() {
  newPath.add(new PVector(mouseX, mouseY));
}

void mouseDragged() {
  newPath.add(new PVector(mouseX, mouseY));
}

void mouseReleased() {
  PVector[] simplifiedPath = simplifyPath(newPath);
  newPath = new ArrayList<PVector>();
  Wall wall =  new Wall(simplifiedPath);
  walls.add(wall);
  Ball ball = new Ball(width/2, 20);
  balls.add(ball);
}

