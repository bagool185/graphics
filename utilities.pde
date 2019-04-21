boolean doubleEqual(double x, double y) {
  
  double epsilon = 0.001;
  return (y - x <= epsilon && y - x >= -epsilon);
}
