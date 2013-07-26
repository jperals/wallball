// The GPL License
// Copyright (c) 2013 Joan Perals Tresserra

import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

ArrayList<Wall> walls;
ArrayList<Ball> balls;
ArrayList<PVector> newPath;
color bgColor = 0;
color[] ballColors;
color nextBallColor;
color wallColor;
int pointsPerPath;
Physics box2d;
float scroll;
int nextBallPosition;
int nextBallCountDown;
int addBallEvery;

void setup() {
  size(640, 800);
  frameRate(30);
  addBallEvery = 60;
  bgColor = 0;
  ballColors = new color[]{#FF0000, #00FF00, #0000FF};
  wallColor = color(110, 110, 100);
  pointsPerPath = 150;
  scroll = 0;
  dScroll = 1;
  nextBallPosition = random(width);
  nextBallCountDown = addBallEvery;
  nextBallColor = getRandomBallColor();
  box2d = new Physics(this, width, height, 0, -10, width*2, height*2, width, height, 100);
  box2d.setCustomRenderingMethod(this, "myCustomRenderer");
  box2d.setDensity(10.0);
  balls = new ArrayList<Ball>();
  walls = new ArrayList<Wall>();
  newPath = new ArrayList<PVector>();
  addNewBall();
}

void draw() {
  background(bgColor);
  nextBallCountDown --;
  if(nextBallCountDown == 0) {
    nextBallColor = getRandomBallColor();
    nextBallPosition = random(width);
    addNewBall();
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
  noStroke();
  for(int i = 0; i < balls.size(); i++) {
    balls.get(i).display();
  }
  fill(wallColor);
  stroke(wallColor);
  for(int i = 0; i < walls.size(); i++) {
    walls.get(i).display();
  }
}

void addNewBall() {
  Ball ball = new Ball(nextBallPosition, scroll - 20, 10, nextBallColor);
  balls.add(ball);
}

color getRandomBallColor() {
  int index = int(random(ballColors.length));
  index = min(index, ballColors.length - 1);
  return ballColors[index];
}
