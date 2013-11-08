/*
 * PhisicalObject.fx
 *
 * Created on 11-feb-2009, 1.32.53
 */

package pastello;

import javafx.scene.CustomNode;
import javafx.scene.Node;
import net.phys2d.raw.Body;

/**
 * @author Claudio Santini
 */
public abstract class PhysicalObject extends CustomNode {

    /** The object in the phys2d world (MODEL) */
    public var body : Body;
    /** The graphical rapresentation of the figure (VIEW) */
    public var shape : Node;
	/** position in the plane */
    public var x : Number = 0;
	/** position in the plane */
    public var y : Number = 0;
	/** Whether or not is affected by gravity: static by default */
	public var isStatic : Boolean = true;

	/** Update the view with the model changes */
    public function update() : Void {
        x = body.getPosition().getX();
        y = body.getPosition().getY();
    }
}
