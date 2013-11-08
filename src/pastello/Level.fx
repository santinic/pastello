/*
 * levels.fx
 *
 * Created on 29-apr-2009, 11.45.48
 */

package pastello;
import pastello.Ball;
import pastello.Box;
import pastello.GameScene;
import pastello.PhysicalObject;

/**
 * @author Claudio Santini
 */

public class Level {
	public var objects : PhysicalObject[];
}

def w = GameScene.WIDTH;
def h = GameScene.HEIGHT;

public def levels : Level[] = [
	Level {
		objects: [
			Ball { x: 300, y: 300, isStatic: false }
			Box { x: (w-100)/2, y: h-100, w: w-100, h: 50 }
			Flag { x: w-120, y: h-100 }
		]
	}
	Level {
		objects: [
			Ball { x: 210, y: 400, radius: 20 }
			Box	{ x: 200, y: 500, w: 300, h: 60 }
			Box	{ x: 600, y: 500, w: 300, h: 60 }
			Box { x: 0, y: 500, w: 300, h: 40 }
		]
	}
];
