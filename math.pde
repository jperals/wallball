// Calculation stuff is done here

// Simplifies a path to a given number of points (defined by pointsPerPath)
// It just selects a number of the existing points in the original path while leaving others out
// Original path is an ArrayList, whilst the returned simplified path is an Array
PVector[] simplifyPath(ArrayList<PVector> originalPath) {
  int simplifiedPathSize = Math.min(originalPath.size(), pointsPerPath);
  PVector[] simplifiedPath = new PVector[simplifiedPathSize];
  int jump = Math.round(originalPath.size()/(float)simplifiedPathSize);
  println("Math.round(" + originalPath.size() + "/" + simplifiedPathSize + ") = " + jump);
  int simplifiedPathIndex = 0;
  for(int originalPathIndex = 0; simplifiedPathIndex < simplifiedPathSize; originalPathIndex += jump) {
    simplifiedPath[simplifiedPathIndex] = originalPath.get(Math.min(originalPathIndex, originalPath.size()));
    simplifiedPathIndex++;
  }
  return simplifiedPath;
}
