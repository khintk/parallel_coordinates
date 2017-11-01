/**
 * Represents a bspline.
 * Based on code from: https://github.com/deric/curve-fit-demo/blob/master/src/main/java/org/clueminer/curve/fit/splines/BSpline.java
 */
class BSpline {

  ArrayList<PVector> controlPoints;
  ArrayList<PVector> curvePoints;
  static final int STEPS = 20;

  /**
   * Constructs a bSpline given a list of control points. The first and last control points are duplicated so that they actually appear on the line.
   */
  BSpline(ArrayList<PVector> controlPoints) {

    // Duplicate the first and last point so that they are actually points on the curve
    controlPoints.add(0, controlPoints.get(0));
    controlPoints.add(controlPoints.get(controlPoints.size()-1));

    this.controlPoints = controlPoints;
    curvePoints = curve(controlPoints, STEPS);
  }

  /**
   * Draws the spline as a smooth curve
   */
  void drawSpline() {
    beginShape();
    for (PVector pt : curvePoints) {
      vertex(pt.x, pt.y);
    }
    endShape();
  }

  // the basis function for a cubic B spline
  public double basis(int i, double t) {
    switch (i) {
    case -2:
      return (((-t + 3) * t - 3) * t + 1) / 6;
    case -1:
      return (((3 * t - 6) * t) * t + 4) / 6;
    case 0:
      return (((-3 * t + 3) * t + 3) * t + 1) / 6;
    case 1:
      return (t * t * t) / 6;
    }
    return 0; //we only get here if an invalid i is specified
  }

  /* evaluate a point on the B spline */
  PVector evaluate(ArrayList<PVector> thePoints, int i, float t) {
    PVector p = new PVector();
    for (int j = -2; j <= 1; j++) {
      p.x += basis(j, t) * thePoints.get(i + j).x;
      p.y += basis(j, t) * thePoints.get(i + j).y;
      //p.z += basis(j, t) * thePoints.get(i + j).z;
    }
    return p;
  }

  /** Gets a list of points lying on the curve **/
  ArrayList<PVector> curve(ArrayList<PVector> thePoints, int theSteps) {
    ArrayList<PVector> theResult = new ArrayList<PVector>();
    for (int i = 2; i < thePoints.size() - 1; i++) {
      for (int j = 1; j <= theSteps; j++) {
        theResult.add(evaluate(thePoints, i, j / (float) theSteps));
      }
    }
    return theResult;
  }
}