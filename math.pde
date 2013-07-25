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
