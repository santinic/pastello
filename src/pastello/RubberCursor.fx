/*
 * RubberCursor.fx
 *
 * Created on 26-apr-2009, 15.29.58
 */

package pastello;
import java.awt.Toolkit;
import pastello.Bar;

/**
 * @author Claudio Santini
 */
 
public class RubberCursor extends javafx.scene.Cursor {
    public override function impl_getAWTCursor(): java.awt.Cursor {
        var img = Bar.rubberImg32.bufferedImage;
        var p = new java.awt.Point(0,15);
		var tk = Toolkit.getDefaultToolkit();
        var cursor = tk.createCustomCursor(img, p, "rubber");
        return cursor;
    } 
}
