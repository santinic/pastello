/*
 * Ball.fx
 *
 * Created on 11-feb-2009, 17.17.03
 */

package pastello;

import javafx.scene.Node;
import javafx.scene.shape.Circle;
import javafx.scene.shape.Shape;
import pastello.PhysicalObject;

/**
 * @author Claudio Santini
 */

public class Point extends PhysicalObject {

    public override function create() : Node {
        shape = createCircle();
        return shape;
    }

    function createCircle() : Shape {
        return Circle {
            centerX: bind x
            centerY: bind y
            radius: bind 5
        };
    }
}
