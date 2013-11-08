/*
 * Polygon.fx
 *
 * Created on 17-feb-2009, 2.14.09
 */

package pastello;
import java.lang.Math;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.shape.StrokeLineCap;
import net.phys2d.math.Vector2f;
import net.phys2d.raw.Body;
import net.phys2d.raw.StaticBody;
import pastello.ColorPaint;
import pastello.PastelPaint;
import pastello.PhysicalObject;
import pastello.PhysicalScene;

/**
 * @author Claudio Santini
 */
public class Polygon extends PhysicalObject {

	//public var isFake = false;
	public var vertices: Vector2f[];
	public var originalVertices: Vector2f[];
	public var mass : Float;
	var rawShape : net.phys2d.raw.shapes.Polygon;

    public override function create() : Node {

		rawShape = new net.phys2d.raw.shapes.Polygon(vertices);
		mass = rawShape.getArea() * PhysicalScene.MASS_FACTOR;
		if(isStatic) {
			body = new StaticBody(rawShape);
		}
		else {
			body = new Body(rawShape, mass);
		}
		body.setPosition(x, y);
		body.setGravityEffected(true);
		vertices = rawShape.getVertices(body.getPosition(), body.getRotation());

//        visualShape = Group {
//			content: [
//
//				Circle {
//					centerX: bind computeCentroid(vertices).getX();
//					centerY: bind computeCentroid(vertices).getY();
//					radius: 5
//				}

		shape = javafx.scene.shape.Polygon {
			points:
				bind
					for(p in vertices) {
						[p.getX(), p.getY()];
					}
			fill: Color.TRANSPARENT
			stroke:
				if(isStatic) ColorPaint.getStaticInstance()
				else ColorPaint.getInstance()
			strokeWidth: PastelPaint.STROKE_WIDTH
			strokeLineCap: StrokeLineCap.ROUND
		}

		return shape;
    }

	public override function update() : Void {
		// Returns a translated and rotated copy of this poly's vertices
		vertices = rawShape.getVertices(body.getPosition(), body.getRotation());
	}
}

/**
 * Given polygon vertices as (x,y) coordinates, traslates the vertices using
 * the centroid of the polygon as axis origin.
 */
public function xyToCentroidVertices(vertices: Vector2f[], centroid: Vector2f) : Vector2f[] {
	//var centroid = computeCentroid(vertices);
	println("centroid {centroid.x} {centroid.y}");
	for(v in vertices) {
		println("{v.x} {v.y}");
		v.set(v.x + centroid.x, v.y+ centroid.y);
		println("{v.x} {v.y}");
	}
	return vertices;
}

/**
 * Takes a sequence of vertices and returns the centroid of the given polygon.
 * For the original code look in net.phys2d.raw.shapes.Polygon.
 */
public function computeCentroid(vertices: Vector2f[]) : Vector2f {
	var area = computeArea(vertices);
	println("area {area}");
	var x = 0;
	var y = 0;
	var v1 : Vector2f;
	var v2 : Vector2f;

	for (i in [0..vertices.size()-1]) {
		v1 = vertices[i];
		v2 = vertices[(i+1) mod vertices.size()];

		x += (v1.x + v2.x) * (v1.x * v2.y - v2.x * v1.y);
		y += (v1.y + v2.y) * (v1.x * v2.y - v2.x * v1.y);
	}
	return new Vector2f(x / (6 * area), y / (6 * area));
}

/**
 * Takes a sequence of vertces and returns the area of the given polygon.
 * For the original code look in net.phys2d.raw.shapes.Polygon.
 */
public function computeArea(vertices: Vector2f[]) : Integer {
	var area = 0;
	var v1 : Vector2f;
	var v2 : Vector2f;

	for(i in [0..vertices.size()-1]) {
		v1 = vertices[i];
		v2 = vertices[(i+1) mod vertices.size()];

		area += v1.x * v2.y;
		area -= v2.x * v1.y;
	}
	return Math.abs(area / 2);
}
