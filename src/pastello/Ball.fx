/*
 * Ball.fx
 *
 * Created on 11-feb-2009, 17.17.03
 */

package pastello;

import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.shape.Circle;
import javafx.scene.shape.Shape;
import net.phys2d.raw.Body;
import net.phys2d.raw.StaticBody;
import pastello.ColorPaint;
import pastello.PastelPaint;
import pastello.PhysicalObject;
import pastello.PhysicalScene;

/**
 * @author Claudio Santini
 */

public class Ball extends PhysicalObject {

    public var radius : Number = 20;
	/** Whether or not is the red ball of the game: true by default */
	public var isRedBall = true;
	public var isFake = false;

    public override function create() : Node {
        shape = createCircle();
        return shape;
    }

    function createCircle() : Shape {
		var rawShape = new net.phys2d.raw.shapes.Circle(radius);
		if(isStatic) {
			body = new StaticBody(rawShape);
		}
		else {
			body = new Body(rawShape, radius*radius*3.14*PhysicalScene.MASS_FACTOR);
		}
        body.setPosition(x, y);
        return Circle {
            centerX: bind x
            centerY: bind y
            radius: bind radius
			fill: Color.TRANSPARENT
            stroke: if(isRedBall) ColorPaint.getRedInstance()
					else ColorPaint.getInstance()
			strokeWidth: 
					if(isRedBall) PastelPaint.STROKE_WIDTH + 3
					else PastelPaint.STROKE_WIDTH
        };
    }
}
