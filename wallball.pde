ArrayList<PVector> newPath;
int pointsPerPath;

void setup() {
  size(512, 512);
  newPath = new ArrayList<PVector>();
  pointsPerPath = 5;
}

void draw() {
}

void mousePressed() {
  newPath.add(new PVector(mouseX, mouseY));
}

void mouseDragged() {
  PVector lastPoint = newPath.get(newPath.size() - 1);
  newPath.add(new PVector(mouseX, mouseY));
  line(lastPoint.x, lastPoint.y, mouseX, mouseY);
}

void mouseReleased() {
  PVector[] simplifiedPath = simplifyPath(newPath);
  newPath = new ArrayList<PVector>();
  PVector oldPoint = simplifiedPath[0];
  for(int i = 1; i < simplifiedPath.length; i++) {
    PVector newPoint = simplifiedPath[i];
    line(oldPoint.x, oldPoint.y, newPoint.x, newPoint.y);
  }
}

