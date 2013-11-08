/*
 * Box.fx
 *
 * Created on 12-feb-2009, 21.08.28
 */

package pastello;

import java.lang.Float;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.shape.Polygon;
import javafx.scene.shape.StrokeLineJoin;
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

public class Box extends PhysicalObject {
	
    public var w : Number;
    public var h : Number;
	public var rotation : Number = 0;
	
	var rawShape : net.phys2d.raw.shapes.Box;
	var vertices : Vector2f[];

	// Note: javafx draws rectangles as awt starting from the top left corner, 
	// while phys2d starts from the central point.
    public override function create() : Node {
		rawShape = new net.phys2d.raw.shapes.Box(new Float(w), new Float(h));
        
		if(isStatic) {
			body = new StaticBody(rawShape);
		}
        else {
			body = new Body(rawShape, w*h*PhysicalScene.MASS_FACTOR);
		}

		body.setRotation(rotation);
		
		body.setPosition(new Float(x), new Float(y));
        shape = Polygon {
//            x: bind x - w / 2
//            y: bind y - h / 2
//            width: bind w
//            height: bind h
			points: 
				bind for(v in vertices) {
					[v.getX(), v.getY()]
				}
			fill: Color.TRANSPARENT
			stroke: 
				if(isStatic) ColorPaint.getStaticInstance()
				else ColorPaint.getInstance()
			strokeWidth: PastelPaint.STROKE_WIDTH
			strokeLineJoin: StrokeLineJoin.ROUND
			rotate: rotation
        }
		return shape;
    }

	public override function update() : Void {
        x = body.getPosition().getX();
        y = body.getPosition().getY();
		vertices = rawShape.getPoints(body.getPosition(), body.getRotation());
    }
}
