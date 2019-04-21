import java.util.ListIterator;

final static float canvasOffset = 124;
final static int canvasSize = 1024;
   
class Canvas {
   
  ArrayList<GraphicObject> graphicObjects;
  PVector startPoint;
  PVector size;
 
  public Canvas(PVector size) {
    graphicObjects = new ArrayList<GraphicObject>();
    this.startPoint = new PVector(0, 0);
    this.size = size;
  }
  
  public void drawAll() {
    for (GraphicObject object : graphicObjects) {
      object.draw();
    }
  }
  
  public void addObject(GraphicObject object) {
    graphicObjects.add(object);
  }
  
  public void save() {
    for (GraphicObject object : graphicObjects) {
      println(object.startPoint.x);
    }
  }

  public GraphicObject currentlyHovering() {

    println(graphicObjects.size());

    ListIterator<GraphicObject> it = graphicObjects.listIterator(graphicObjects.size());

    while (it.hasPrevious()) {

      final GraphicObject obj = it.previous();

      if (obj._hasMouseOver()) {
        return obj;
      }
    }

    return null;
  }
}
