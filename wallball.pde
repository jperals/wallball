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

Maxim maxim;

void setup() {
  size(640, 800);
  frameRate(30);
  addBallEvery = 80;
  bgColor = 0;
  ballColors = new color[]{#FF0000, #00FF00, #0000FF};
  pointsPerPath = 30;
  scroll = 0;
  dScroll = 0.1;
  ddScroll = 0.0001;
  score = 0;
  maxim = new Maxim(this);
  ballSound = maxim.loadFile("ball.wav");
  ballSound.setLooping = false;
  wallSound = maxim.loadFile("crash1.wav");
  wallSound.setLooping = false;
  prepareNextBall();
  box2d = new Physics(this, width, height, 0, -5, width*2, height*2, width, height, 100);
  box2d.setCustomRenderingMethod(this, "myCustomRenderer");
  box2d.setDensity(10.0);
  balls = new ArrayList<Ball>();
  walls = new ArrayList<Wall>();
  newPath = new ArrayList<PVector>();
  detector = new CollisionDetector (box2d, this);
}

void draw() {
  background(bgColor);
  fill(255);
  text("Score: " + score, 20, 20);
  if(addBallEvery - nextBallCountDown > 60) {
    drawNextBallIndicator();
  }    
  if(nextBallCountDown == 0) {
    addNewBall();
    //nextBallCountDown = addBallEvery;
  }
  nextBallCountDown --;
  scroll += dScroll;
  dScroll += ddScroll;
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
    Ball ball = balls.get(i);
    if(ball.toBeRemoved) {
      box2d.removeBody(ball.body);
      balls.remove(ball);
    }
    else {
      ball.display();
    }
  }
  for(int i = 0; i < walls.size(); i++) {
    Wall wall = walls.get(i);
    if(wall.toBeRemoved) {
      //wall.body.type = Body.b2_dynamicBody;
      box2d.removeBody(wall.body);
      walls.remove(wall);
    }
    else {
      wall.display();
    }
  }
}

void addNewBall() {
  Ball ball = new Ball(nextBallPosition, scroll - 7, 7, nextBallColor);
  balls.add(ball);
  prepareNextBall();
}

void collision(Body b1, Body b2, float impulse) {
  if((b1.getMass() != 0 && b2.getMass() == 0) || (b1.getMass() == 0 && b2.getMass() != 0)) {
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
    playBallSound(impulse);
    color ballColor = ball.ballColor;
    wall.combineColor(ballColor);
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

