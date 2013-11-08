/*
 * Flag.fx
 *
 * Created on 29-apr-2009
 */

package pastello;

import javafx.animation.transition.ScaleTransition;
import javafx.animation.transition.SequentialTransition;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.Node;
import net.phys2d.raw.Body;
import net.phys2d.raw.StaticBody;
import pastello.PhysicalObject;

/**
 * @author Claudio Santini
 */

public def flagImg = Image {
	url: "{__DIR__}resources/flag.png"
}


public class Flag extends PhysicalObject {
	
    public override function create() : Node {
		var rawShape = new net.phys2d.raw.shapes.Box(flagImg.width, flagImg.height);
		body = new StaticBody(rawShape);
		body.setPosition(x, y);
		body.setMoveable(false);
		// body.setEnabled(false);
		shape = ImageView {
			x: x - flagImg.width/2
			y: y - flagImg.height/2
			image: flagImg
		}
		return shape;
    }
}
