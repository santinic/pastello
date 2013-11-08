/*
 *
 * PastelPaint.fx
 *
 * Created on 14-feb-2009, 14.25.10
 */

package pastello;

import javafx.scene.image.Image;
import javafx.scene.paint.Paint;
import javafx.scene.shape.Rectangle;
import pastello.PastelPaint;

/**
 * @author Claudio Santini
 */

public def STROKE_WIDTH = 5;
public def TEXTURES_NUMBER = 5;

var singletons : PastelPaint[] = null;
var colorCount = 0;

public function initTextures() {
	for(n in [1..TEXTURES_NUMBER+1]) {
		insert PastelPaint{ 
			image: Image {
				url: "{__DIR__}resources/p{n}.png";
			}
		} into singletons;
	}
}

public function getInstance() : PastelPaint {
	if(singletons == null) {
		initTextures();
	}
	var ret = singletons[colorCount];
	colorCount = (colorCount+1) mod TEXTURES_NUMBER;
	return ret;
}

public function getRedInstance() : PastelPaint {
	if(singletons == null) {
		initTextures();
	}
	return singletons[TEXTURES_NUMBER];
}

public class PastelPaint extends Paint {

	public var image : Image;
	public var anchorRect : Rectangle;

    public override function getAWTPaint() : java.awt.Paint {
		//		var dst : BufferedImage = new BufferedImage(image.bufferedImage.getWidth(),
		//		image.bufferedImage.getHeight(), image.bufferedImage.getType());
        var rect: java.awt.Rectangle = new java.awt.Rectangle();
//        rect.x = rx as Integer;
//        rect.y = ry as Integer;
        rect.width = image.width as Integer; //anchorRect.width as Integer;
        rect.height = image.height as Integer; //anchorRect.height as Integer;
		//var color = (PastelPaint.TEXTURES_NUMBER) * Math.random() as Integer;
        return new java.awt.TexturePaint(image.bufferedImage, rect);
		//return Color.BLACK.getAWTPaint();
//        var rect: java.awt.Rectangle = new java.awt.Rectangle();
//        rect.x = anchorRect.x as Integer;
//        rect.y = anchorRect.y as Integer;
//        rect.width = anchorRect.width as Integer;
//        rect.height = anchorRect.height as Integer;
//        return new java.awt.TexturePaint(image.bufferedImage, rect);
    }
}
