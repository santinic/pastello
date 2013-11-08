/*
 * PhysicalScene.fx
 *
 * Created on 11-feb-2009, 2.14.11
 */

package pastello;

import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.scene.layout.Container;
import net.phys2d.math.Vector2f;
import net.phys2d.raw.Body;
import net.phys2d.raw.CollisionEvent;
import net.phys2d.raw.CollisionListener;
import net.phys2d.raw.World;
import pastello.PhysicalObject;

/**
 * @author Claudio Santini
 */

public def MASS_FACTOR = 1000;

public abstract class PhysicalScene extends Container {
	
	/** Physical/Graphical objects sequence */
    public var objects : PhysicalObject[] = [];
	/** The animator which moves physical objects */
    protected var animator: Timeline;
	/** Gravity vector */
	var gravity : Vector2f = new Vector2f(0, 1000);
	/** World of the model */
	protected var world : World = new World(gravity, 30);
	/** A Link to the body of the ball of this level (for the collision listener) */
	protected var theBall : Body;

	/** Starts the animation */
    public function start() : Void {
        animator = Timeline {
            repeatCount: Timeline.INDEFINITE
            keyFrames: [
                KeyFrame {
                    time: .01s
                    canSkip: true
                    action: animate
                }
            ]
        }
        for(c in objects) {
            world.add(c.body);
        }
        animator.play();
    }

    /**
	 * Another istant in the world passes: I call all the objects and make them
     * update with the world model
     */
    function animate() : Void {
        // <<this>> means I'm using the language keyword "this" as method name
        world.<<step>>();
        for(c in objects) {
			var bounds = c.body.getShape().getBounds();
			if(c.body.getPosition().getX() > width + bounds.getWidth() or
				c.body.getPosition().getY() > height + bounds.getHeight())
			{
				if(c.body == theBall) {
					ballExitedFromScene();
				}
				deleteObject(c);
			}
			else {
				c.update();
			}
        }
    }
	
    public function addObject(o: PhysicalObject) : Void {
        if(o.body != null) {
			world.add(o.body);
		}
        insert o into objects;
    }

	public function deleteObject(o: PhysicalObject) : Void {
		world.remove(o.body);
		delete o from objects;
	}

	public abstract function ballExitedFromScene() : Void;

//	public function getObjectAt(p : Vector2f) : Shape {
//		var list = world.getBodies();
//		var b : Body;
//		for(i in [0..list.size()-1]) {
//			b = list.get(i);
//			if(b instanceof Polygon) {
//				var poly = b as Polygon;
//				if(poly.contains(p)) {
//					return poly;
//				}
//			}
//			else if(b instanceof Box) {
//				var box = b as Box;
//				box.
//			}
//		}
//		return null;
//	}
}

