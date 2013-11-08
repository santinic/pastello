/*
 * Bar.fx
 *
 * Created on 28-apr-2009, 20.58.08
 */

package pastello;
import java.io.FileInputStream;
import javafx.animation.transition.ScaleTransition;
import javafx.ext.swing.SwingButton;
import javafx.ext.swing.SwingToggleButton;
import javafx.scene.Cursor;
import javafx.scene.Group;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.HBox;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.shape.Line;
import javafx.scene.shape.Rectangle;
import javax.swing.JFileChooser;
import pastello.Bar;
import pastello.Bar.JSONFileFilter;
import pastello.GamePlay;
import pastello.GameScene;
import pastello.PastelPaint;
import pastello.RubberCursor;

/**
 * @author Claudio Santini
 */

// The rubber cursor stuff
public def rubberImg = Image {
	url: "{__DIR__}resources/rubber.png"
}
public def rubberImg32 = Image {
	url: "{__DIR__}resources/rubber32.png"
}
public def rubberCursor = RubberCursor {};

public def flagImg32 = Image {
	url: "{__DIR__}resources/flag32.png"
}

public def cross : Node[] = [
	Line {
		startX: 0
		startY: 10
		endX: 10
		endY: 0
		stroke: Color.GREEN
		strokeWidth: 2
	}
	Line {
		startX: 0
		startY: 0
		endX: 10
		endY: 10
		stroke: Color.GREEN
		strokeWidth: 2
	}
];

public def crossNode = Group {
	content: cross
};

function doRubber() : Void {
	if(GameScene.status == GameScene.rubber) {
		GamePlay.getInstance().gameScene.rubberMode(true);
	}
	else {
		GamePlay.getInstance().gameScene.rubberMode(false);
	}
}

// Creates a clickable rectangle with a node inside, a tooltip, and an associated state
var groupWithRectangle = function(tooltip : String, newStatus : Integer, n : Node) {
//	var tooltipLabel = Group {
//		content: [
//			Text {
//				x: n.boundsInParent.minX //+ n.boundsInScene.width/2 - this.boundsInScene.width/2;
//				y: n.boundsInParent.minY + 40
//				content: tooltip
//			}
//		]
//		visible: false;
//	}
	var scale = ScaleTransition {
		duration: 0.15s
		node: n
		byX: 1.005
		byY: 1.005
		repeatCount: 2
		autoReverse: true
	};
	return Group {
		cursor: Cursor.HAND
		content: [
			Rectangle {
				x: n.layoutBounds.minX
				y: n.layoutBounds.minY
				width: n.layoutBounds.width
				height: n.layoutBounds.height
				fill: Color.TRANSPARENT
			}
			n
		]
		onMouseEntered: function(e : MouseEvent) {
			scale.play();
			GamePlay.getInstance().gameScene.msg = tooltip;
		}
		onMouseExited: function(e : MouseEvent) {
			GamePlay.getInstance().gameScene.msg = "";
		}
		onMouseClicked: function(e : MouseEvent) {
			GameScene.status = newStatus;
			//doRubber();
		}
	};
}

// The tool bar on the top
public var barNode = HBox {
	translateX: 10
	translateY: 10
	spacing: 10
	visible: bind if(GameScene.isGameMode) true else false
	content: bind [
		groupWithRectangle("Circle (key A)", GameScene.circle, javafx.scene.shape.Circle {
			centerX: 13
			centerY: 13
			radius: 13
			fill: null
			stroke: PastelPaint.getInstance()
			strokeWidth: 3
			opacity: bind if(GameScene.status == GameScene.circle) 1 else 0.3
		})
		groupWithRectangle("Triangle (key S)", GameScene.triangle, javafx.scene.shape.Polygon {
			translateX: 0
			translateY: 0
			points: [
				25, 25,
				0, 25,
				0, 0,
			]
			fill: null
			stroke: PastelPaint.getInstance()
			strokeWidth: 3
			opacity: bind if(GameScene.status == GameScene.triangle) 1 else 0.3
		})
		groupWithRectangle("Box (key d)", GameScene.box, Rectangle {
			translateY: 5
			width: 30
			height: 20
			fill: null
			stroke: PastelPaint.getInstance()
			strokeWidth: 3
			opacity: bind if(GameScene.status == GameScene.box) 1 else 0.3
		})
//		groupWithRectangle("An inclined box (key F)", GameScene.line, javafx.scene.shape.Polygon {
//			translateX: 0
//			translateY: 0
//			points: [
//				0, 20,
//				30, 0,
//				35, 5,
//				5, 25
//			]
//			fill: null
//			stroke: PastelPaint.getInstance()
//			strokeWidth: 3
//			opacity: bind if(GameScene.status == GameScene.line) 1 else 0.3
//		})
		groupWithRectangle("Pivot (soon avaible!)", GameScene.join, javafx.scene.shape.Circle {
			centerX: 6
			centerY: 14
			radius: 7
			fill: null
			stroke: Color.BLUEVIOLET
			strokeWidth: 2
			opacity: bind if(GameScene.status == GameScene.join) 1 else 0.3
		})
		groupWithRectangle("Cross: joint between two bodies (next release!)", GameScene.cross, Group {
			translateY: 10
			translateX: 5
			content: cross
			opacity: bind if(GameScene.status == GameScene.cross) 1 else 0.3
		})
		groupWithRectangle("Rubber: delete a shape (key R)", GameScene.rubber, ImageView {
			image: Bar.rubberImg
			opacity: bind if(GameScene.status == GameScene.rubber) 1 else 0.3
		})

		if(GameScene.isEditorMode) { [
			groupWithRectangle("Star", GameScene.flag, ImageView {
				image: flagImg32
				opacity: bind if(GameScene.status == GameScene.flag) 1 else 0.3
			})
			SwingToggleButton {
				text: "Static shape"
				selected: GameScene.isStaticMode
				action: function() {
					GameScene.isStaticMode = not GameScene.isStaticMode;
				}
			}
			SwingButton {
				text: "Save level"
				action: function() {
					var fc = getFileChooser(false);
					if(fc.showSaveDialog(null) == javax.swing.JFileChooser.APPROVE_OPTION) {
						var file = fc.getSelectedFile();
						GamePlay.getInstance().saveJSON(file);
					}
				}
			}
			SwingButton {
				text: "Open level"
				action: function() {
					var fc = getFileChooser(true);
					if(fc.showOpenDialog(null) == javax.swing.JFileChooser.APPROVE_OPTION) {
						var file = fc.getSelectedFile();
						GamePlay.getInstance().loadJSON(new FileInputStream(file)); //"src/pastello/levels/1.json"
					}
				}
			}
		]}
		else []
	]
};

class JSONFileFilter extends javax.swing.filechooser.FileFilter {
    override public function getDescription() : String {
        return "json files";
    }

    override public function accept(f: java.io.File) : Boolean {
        return f.isDirectory() or f.getName().endsWith(".json");
    }
}

public var fileChooser: javax.swing.JFileChooser;

function getFileChooser(open: Boolean) : javax.swing.JFileChooser {
	if(fileChooser == null) {
		fileChooser = javax.swing.JFileChooser {};
	}
	var filter = if(open) JSONFileFilter {} else JSONFileFilter {};
	fileChooser.setFileFilter(filter);
	return fileChooser;
}

