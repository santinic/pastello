/*
 * GameScene.fx
 *
 * Created on 11-feb-2009, 2.37.50
 */

package pastello;

import java.lang.Math;
import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.animation.transition.FadeTransition;
import javafx.animation.transition.ScaleTransition;
import javafx.animation.transition.SequentialTransition;
import javafx.scene.Cursor;
import javafx.scene.Group;
import javafx.scene.image.Image;
import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyEvent;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.VBox;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.shape.Shape;
import javafx.scene.text.Text;
import javafx.scene.transform.Transform;
import net.phys2d.math.Vector2f;
import net.phys2d.raw.Body;
import net.phys2d.raw.CollisionEvent;
import net.phys2d.raw.CollisionListener;
import net.phys2d.raw.FixedJoint;
import net.phys2d.raw.shapes.Circle;
import pastello.Ball;
import pastello.Bar;
import pastello.Box;
import pastello.ColorPaint;
import pastello.Flag;
import pastello.GamePlay;
import pastello.GameScene;
import pastello.GameScene.FlagCollisionListener;
import pastello.PastelPaint;
import pastello.PhysicalObject;
import pastello.PhysicalScene;
import pastello.Polygon;
import pastello.Postit;
import pastello.StartMenu;

/**
 * @author Claudio Santini
 */

public def WIDTH = 800;
public def HEIGHT = 610;

public def circle = 1;
public def triangle = 2;
public def box = 3;
public def line = 4;
public def join = 5;
public def cross = 6;
public def rubber = 7;
public def flag = 8;
public var status = 0;	// State before animation start

public var isGameMode = false;
public var isEditorMode = false;
public var isStaticMode = false;

public class GameScene extends PhysicalScene {

	/** Current level */
	public var level : Integer = 1;
	/** Shapes created till now */
	public var moves : Integer = 0;

	/** Paper background image */
	def paper = Image {
		url: "{__DIR__}resources/paper.jpg"
	}

	/** Graphical only nodes */
	public var nodes : Node[];

	var firstPick: MouseEvent;
	var secondPick: MouseEvent;
	var curPick: MouseEvent;

    var pickBall: Ball;
	var creatingBall = false;
	var pickBallCount = 0;

	var creatingShape = false;
	var defineShape = false;

	var lineWidth : Float;
	var lineHeight : Float = 10;
	var lineAngle : Float;

	var visualPolygon : Shape = null;
	public var visualPolygons : Node[];

	var barNode : Node;
	var barHeight = 45;
	var barWidth = 300;

	/** Remember the last body added for joint */
	var jointBody : Body;

	/** Editor mode flags */
	var ballAdded = false;
	
	/** Links to the bodies of the flags of the current level */
	var flags : Flag[];

	var levelChanging = false;

	/** The post-it graphical node */
	public var postit : Postit = Postit {
		nodes: [
			VBox {
				translateX: 10
				translateY: 90
				spacing: 40
				content: [
					Text {
						translateX: 45
						font: Postit.sizedFont
						content: "Level finished !"
					}
					Text {
						translateX: 45
						font: Postit.sizedFont
						content: bind
							if(moves == 1) "with one Shape"
							else "with {moves} ShapeS"
					}
					Group {
						cursor: Cursor.HAND
						translateX: 70
						var txt = Text {
							fill: Color.web("#508dcb")
							font: Postit.sizedFont
							content: "next one !"
						}
						onMouseClicked: function(e : MouseEvent) {
							animator.play();
							GamePlay.getInstance().loadNextLevel();
						}
						content: [
							txt
							Rectangle {
								fill: Color.TRANSPARENT
								x: txt.layoutBounds.minX
								y: txt.layoutBounds.minY
								width: txt.boundsInLocal.width
								height: txt.boundsInLocal.height
							}
						]
					}
				]
			}
		]
		action: function() {
			moves = 0;
			levelChanging = false;
			delete postit from nodes;
		}
	};

	var levelLabel = Text {
		visible: bind if(isGameMode and not isEditorMode) true else false
		font: Postit.sizedFont
		content: bind {"Level {level}"}
		fill: ColorPaint.getInstance()
		x: WIDTH - 150
		y: 30
	}

	public var msg = "";

	var msgLabel = Text {
		visible: true
		font: Postit.sizedFont
		fill: ColorPaint.getInstance()
		content: bind msg
		y: HEIGHT - 40
		x: 10
	}

//	var vertices: Vector2f[];
//	var vertexn = 0;
//	var creatingPolygon = false;
//	var visualPolygon: Polyline = null;
//	var visualVertices: Number[];

    /* The timer that makes the ball grow when you keep pressing */
    var pickBallTimer = Timeline {
        repeatCount: 100
        keyFrames: [
            KeyFrame {
                time: .01s
                action: function() {
					if(creatingBall) {
						pickBall.radius++;
						// Make the ball bigger
						var r2 = pickBall.radius * pickBall.radius;
						var mass = r2 * Math.PI * PhysicalScene.MASS_FACTOR;
						pickBall.body.setOnTheFly(new Circle(pickBall.radius), mass);
					}
					else {
						// After 5 repeats it starts growing the ball
						if(pickBallCount >= 5) {
							creatingBall = true;
							pickBall = Ball {
								radius: 1
								x: firstPick.x
								y: firstPick.y
								isRedBall: false
								isStatic: isStaticMode
							};
							pickBall.body.setGravityEffected(false);
							moves++;
							addObject(pickBall);
							pickBallCount = 0;
						}
						else {
							pickBallCount++;
						}
					}
				}
			}
		]
	}

	/** A node as big as the top container which catches mouse events */
	var pickBox = Rectangle {
		width: WIDTH
		height: HEIGHT
		fill: Color.TRANSPARENT
		onMousePressed: function(e: MouseEvent) {

			if(levelChanging) return;

			// the top bar doesn't pick
			if(isEditorMode and e.y <= barHeight) {
				return;
			}
			else if(e.y <= barHeight and e.x <= barWidth) {
				return;
			}
			
			else if(status == circle and not creatingBall) {
				firstPick = e;
				if(isEditorMode) {
					if(not ballAdded) {
						moves++;
						addObject(Ball {
							isStatic: false
							x: e.x
							y: e.y
						});
						ballAdded = true;
					}
				}
				else {
					pickBallTimer.play();
				}
			}
			else if(status == triangle) {
				creatingShape = true;
				firstPick = e;
				curPick = e;

				visualPolygon = javafx.scene.shape.Polygon {
					points: bind [
						firstPick.x, firstPick.y,
						curPick.x, curPick.y,
						if(curPick.y > firstPick.y) [firstPick.x, curPick.y]
						else [curPick.x, firstPick.y]
					]
					fill: Color.TRANSPARENT
					stroke: ColorPaint.getInstance()
					strokeWidth: PastelPaint.STROKE_WIDTH
				}
				addVisual(visualPolygon);
			}
			else if(status == box) {
				creatingShape = true;
				firstPick = e;
				curPick = e;
				visualPolygon = Rectangle {
					x: bind Math.min(curPick.x, firstPick.x)
					y: bind Math.min(curPick.y, firstPick.y)
					width: bind Math.abs(curPick.x - firstPick.x)
					height: bind Math.abs(curPick.y - firstPick.y)
					fill: Color.TRANSPARENT
					stroke: ColorPaint.getInstance()
					strokeWidth: PastelPaint.STROKE_WIDTH
				}

				addVisual(visualPolygon);
			}
			else if(status == line) {
				creatingShape = true;
				firstPick = e;
				curPick = e;

				// The centre of the box
//					var cx = Math.min(curPick.x, firstPick.x) + a/2;
//					var cy = Math.min(curPick.y, firstPick.y) + b/2;

				addVisual(Rectangle {
						x: bind firstPick.x
						y: bind firstPick.y
						width: bind lineWidth
						height: bind lineHeight
						transforms: bind Transform.rotate(lineAngle, firstPick.x, firstPick.y)
						fill: null
						stroke: ColorPaint.getInstance()
						strokeWidth: PastelPaint.STROKE_WIDTH
				});
			}
			else if(status == flag) {
				addObject(Flag {
					x: e.x
					y: e.y
				});
			}
		}
		onMouseReleased: function(e: MouseEvent) {
			if(status == circle and creatingBall) {
				pickBall.body.setGravityEffected(true);
				pickBall = null;
				pickBallTimer.stop();
				creatingBall = false;
			}
			else if(status == triangle and creatingShape) {
				delete visualPolygon from visualPolygons;

				var f = firstPick;
				var t = new Vector2f();

				var v : Vector2f[];
				var dx = (e.x-firstPick.x)/2;
				var dy = (e.y-firstPick.y)/2;
				var adx = Math.abs(dx);
				var ady = Math.abs(dy);

				if(e.y < f.y and e.x > f.x) {
					insert new Vector2f(adx, ady) into v;
					insert new Vector2f(-adx, ady) into v;
					insert new Vector2f(adx, -ady) into v;
				}
				else if(e.y < f.y and e.x < f.x) {
					insert new Vector2f(-adx, ady) into v;
					insert new Vector2f(-adx, -ady) into v;
					insert new Vector2f(adx, ady) into v;
				}
				else if(e.y > f.y and e.x < f.x) {
					insert new Vector2f(adx, ady) into v;
					insert new Vector2f(-adx, ady) into v;
					insert new Vector2f(adx, -ady) into v;
				}
				else if(e.y > f.y and e.x > f.x) {
					insert new Vector2f(-adx, ady) into v;
					insert new Vector2f(-adx, -ady) into v;
					insert new Vector2f(adx, ady) into v;
				}
				moves++;
				addObject(Polygon {
					isStatic: isStaticMode
					vertices: v
					x: Math.min(e.x, f.x) + adx
					y: Math.min(e.y, f.y) + ady
				});
				creatingShape = false;
			}
			else if(status == box and creatingShape) {
				delete visualPolygon from visualPolygons;
				var w = Math.abs(e.x - firstPick.x);
				var h = Math.abs(e.y - firstPick.y);
				moves++;
				addObject(Box {
					isStatic: isStaticMode
					w: w
					h: h
					x: Math.min(e.x, firstPick.x) + w/2
					y: Math.min(e.y, firstPick.y) + h/2
				});
				creatingShape = false;
			}
			else if(status == line) {
				if(defineShape) {
					// Height of the box defined and mouse released (second step)
					creatingShape = false;
					defineShape = false;
					moves++;
					addObject(Box{
						isStatic: isStaticMode
						x: firstPick.x
						y: firstPick.y
						w: lineWidth
						h: lineHeight
						rotation: lineAngle*180
					});
					delete visualPolygon from visualPolygons;
				}
				else if(creatingShape) {
					// Direction of the box defined and mouse released (first step)
					defineShape = true;
					secondPick = e;
				}
			}
			else if(status == line) {
				firstPick = e;
			}

//				if(creatingPolygon.get()) {
//					if(pickBall == null and vertices.size() >= 3) {
//						var centroid = Polygon.computeCentroid(vertices);
////						addObject(Point {
////							x: centroid.x
////							y: centroid.y
////						});
//						var v = Polygon.xyToCentroidVertices(vertices, centroid);
//						var polygon = Polygon {
//							x: e.x
//							y: e.y
//							vertices: v
//						}
//						//polygon.body.setOnTheFly(polygon.body.getShape(), polygon.mass);
//						delete visualPolygon from content;
//						visualPolygon = null;
//						delete visualVertices;
//						addObject(polygon);
//					}
//					delete vertices;
//					creatingPolygon.set(false);
//				}
		}
		onMouseDragged: function(e: MouseEvent) {
			if(e.y <= barHeight) return;

			if(creatingShape) {
				if(status == box or status == triangle) {
					curPick = e;
				}
				else if(status == line) {
					curPick = e;

					if(not defineShape) {
						// Calculates the angle of rotation
						var a = e.x - firstPick.x;
						var b = e.y - firstPick.y;
						var c = Math.sqrt(Math.abs(a*a) + Math.abs(b*b));
						var alpha = Math.toDegrees(Math.atan(a/b));

						// Persistent variables
						lineWidth = c;
						lineHeight = 10;
						lineAngle = if(b > 0) -270 - alpha else -90 - alpha;
					}
				}
			}

//				if(visualPolygon != null) {
//					insert [e.x, e.y] into visualVertices;
//				}
//				else {
//					visualPolygon = Polyline {
//						points: bind visualVertices
//						stroke: PastelPaint{
//						}
//						strokeWidth: 5
//					}
//					//insert visualPolygon into content;
//				}
//				/* Every 10 mouse dragged events we pick a new vertex for the polygon */
//				if(vertexn == 5) {
//					creatingPolygon.set(true);
//					insert
//					new Vector2f(e.x, e.y) into vertices;
//					vertexn = 0;
//				}
//				else vertexn++;
		}
		onMouseMoved: function(e: MouseEvent) {
			if(defineShape) {
				curPick = e;
				lineHeight =
					if(e.y > secondPick.y+10) Math.abs(e.y - secondPick.y)
					else 10
			}
		}
		onKeyReleased: function(e: KeyEvent) {
			if(e.code == KeyCode.VK_SPACE) {
				if(not isEditorMode) {
					GamePlay.getInstance().loadLevel(level);
				}
			}
			else if(e.code == KeyCode.VK_A) {
				status = circle;
			}
			else if(e.code == KeyCode.VK_S) {
				status = triangle;
			}
			else if(e.code == KeyCode.VK_D) {
				status = box;
			}
			else if(e.code == KeyCode.VK_R) {
				status = rubber;
			}
		}

	};

    init {
		width = WIDTH;
		height = HEIGHT;

		world.addListener(new FlagCollisionListener());

		insert postit into nodes;
		insert Bar.barNode into nodes;
		insert levelLabel into nodes;
		insert msgLabel into nodes;
		insert pickBox into nodes;
		insert StartMenu.menuGroup into nodes;
    }

	/** Deletes the menu nodes and start the game animation */
	public function gameMode() {
		delete StartMenu.menuGroup from nodes;
		status = circle;
		isGameMode = true;

		var fadeTransition = FadeTransition {
			duration: 1s 
			node: Group { content: nodes }
			fromValue: 1
			toValue: 0
		}
		fadeTransition.play();

		if(not GameScene.isEditorMode) {
			GamePlay.getInstance().loadLevel(1);
		}

		start();
	}

	public function rubberMode(active : Boolean) {
		if(active) {
			pickBox.cursor = Bar.rubberCursor;
		}
		else {
			pickBox.cursor = Cursor.DEFAULT;
		}
	}

	/**
	 * Adds a graphical-only node to the scene
	 */
	function addVisual(node : Node) {
		insert node into visualPolygons;
	}

	/**
	 * Before adding the object to the physical scene, adds a mouse event
	 * listener to catch on body events
	 */
	public override function addObject(obj : PhysicalObject) {

		if(isEditorMode and isStaticMode) {
			obj.body.setGravityEffected(false);
			obj.isStatic = true;
		}

		if(isObjRedBall(obj)) {
			theBall = obj.body;
		}
		else if(obj instanceof Flag) {
			obj.body.setMoveable(false);
			insert (obj as Flag) into flags;
		}

		obj.shape.onMouseClicked = function(e: MouseEvent) {
			if(status == rubber) {
				if(isEditorMode) {
					deleteObject(obj);
					if(isObjRedBall(obj)) {
						ballAdded = false;
					}
				}
				else {
					if(not obj.isStatic and not isObjRedBall(obj)) {
						deleteObject(obj);
					}
				}
			}
//			else if(status == join) {
//				if(jointBody == null) {
//					jointBody = obj.body;
//				}
//				else {
//					if(jointBody != obj.body) {
////						var a = Math.abs(e.x - firstPick.x);
////						var b = Math.abs(e.y - firstPick.y);
////						var c = Math.sqrt(a*a + b*b);
//
//					}
//					jointBody = null;
//				}
//			}
//			else if(status == cross) {
//				if(jointBody == null) {
//					jointBody = obj.body;
//					insert Group {
//						content: Bar.cross
//						translateX: e.x
//						translateY: e.y
//					} into visualPolygons;
//				}
//				else {
//					if(jointBody != obj.body) {
//						world.add(new FixedJoint(jointBody, obj.body));
//					}
//					jointBody = null;
//				}
//			}
		}
		super.addObject(obj);
	}

	/** Removes all the physical objects into the model/view */
	public function cleanupObjects() {
		for(obj in objects) {
			if(obj instanceof PhysicalObject) {
				deleteObject(obj as PhysicalObject);
			}
		}
		delete objects;
		delete flags;
		world.clear();
	}

	/** Manages the change from a level to the next one */
	public function levelChange() {
		levelChanging = true;
		if(level>1) { insert postit into nodes; }
		animator.pause();
		delete visualPolygons;
		postit.show();
	}

	public override function deleteObject(o: PhysicalObject) : Void {
		if(isObjRedBall(o)) {
			
		}

		world.remove(o.body);
		delete o from objects;
	}

	public override function ballExitedFromScene() {
		if(isEditorMode) {
			ballAdded = false;
		}
		else {
			GamePlay.getInstance().loadLevel(level);
		}
	}
}

public var isObjRedBall = function(obj : PhysicalObject) : Boolean {
	if(obj instanceof Ball) {
		var ball = obj as Ball;
		if(ball.isRedBall) {
			return true;
		}
	}
	return false;
}

/** Listen for collisions between the ball and the flags */
class FlagCollisionListener extends CollisionListener {

	override function collisionOccured(event: CollisionEvent) {
		
		if(isEditorMode) return;

		var a = event.getBodyA();
		var b = event.getBodyB();
	
		if(theBall != null and flags.size() > 0) {
			var ball : Body;
			var flag : Flag;

			if((a == theBall and (flag = equalsAnyOf(b, flags)) != null) or
				(b == theBall and (flag = equalsAnyOf(a, flags)) != null))
			{
				world.remove(flag.body);
				SequentialTransition {
					node: flag.shape
					content: [
						ScaleTransition {
							duration: 0.3s
							byX: 1.3
							byY: 1.3
						}
						ScaleTransition {
							duration: 0.3s
							toX: 0
							toY: 0
						}
					]
					action: function() {
						delete flag from objects;
					}
				}.play();
				delete flag from flags;
				if(flags.size() == 0) {
					levelChange();
				}
			}
		}
	}
	
	function equalsAnyOf(obj : Body, arr : Flag[]) : Flag {
		for(f in arr) {
			if(obj == f.body) {
				return f;
			}
		}
		return null;
	}

//	public function animateFlag(x : Long, y : Long) {
//		var newf = ImageView {
//			x: x - Flag.flagImg.width/2
//			y: y - Flag.flagImg.height/2
//			image: Flag.flagImg
//		}
//		insert newf into GamePlay.getInstance().gameScene.nodes;
//		SequentialTransition {
//			node: newf
//			content: [
//				ScaleTransition {
//					duration: 0.3s
//					byX: 1.3
//					byY: 1.3
//				}
//				ScaleTransition {
//					duration: 0.3s
//					toX: 0
//					toY: 0
//				}
//			]
//			action: function() {
//				delete newf from nodes;
//			}
//		}.play();
//	}
}