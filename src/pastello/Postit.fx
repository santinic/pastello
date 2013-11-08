/*
 * LevelSelect.fx
 *
 * Created on 3-mag-2009, 14.42.45
 */

package pastello;
import javafx.animation.transition.FadeTransition;
import javafx.animation.transition.ParallelTransition;
import javafx.animation.transition.ScaleTransition;
import javafx.scene.Cursor;
import javafx.scene.Group;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import pastello.GamePlay;
import pastello.GameScene;
import pastello.Postit;

/**
 * @author Claudio Santini
 */

def postit = ImageView {
	image: Image {
		url: "{__DIR__}resources/bigpostit.png"
	}
}

public def sizedFont = Font {
	name: "SketchFont"
	size: 39
};

//def emboldenFont = Font {
//	name: "SketchFont"
//	size: 41
//};

//public function okDialog(text: String) {
//	var postit = Postit {
//		nodes: [
//			Text {
//				font: sizedFont
//				content: text
//			}
//			Text {
//				font: sizedFont
//				fill: Color.BLUE
//				content: "OK"
//				cursor: Cursor.HAND
//				onMousePressed: function(e: MouseEvent) {
//					GamePlay.getInstance().gameScene.postit.hide();
//				}
//			}
//		]
//	}
//	return postit;
//}


public class Postit extends Group {

	public var nodes : Node[];
	public var action : function();

	init {
		opacity = 0;
		translateX = GameScene.WIDTH/2 - postit.boundsInLocal.width/2;
		translateY = GameScene.HEIGHT/2 - postit.boundsInLocal.height/2;
		content = [
			postit,
			nodes
		];
	}

	public function show() {
		disable = false;
		ParallelTransition {
			node: this
			content: [
				FadeTransition {
					duration: 1.0s
					fromValue: 0
					toValue: 1
					repeatCount:1
				},
				ScaleTransition {
					duration: 1.0s
					fromX: 0
					fromY: 0
					byX: 1
					byY: 1
					repeatCount: 1
				}
			]
		}.play();
	}

	public function hide() {
		disable = true;
		ParallelTransition {
			node: this
			content: [
				FadeTransition {
					duration: 1s
					toValue: 0
					repeatCount: 1
				},
				ScaleTransition {
					duration: 1s
					toX: 0
					toY: 0
					repeatCount: 1
				}
			]
			action: function() {
				opacity = 0;
				action();
			}
		}.play();
	}

}

//public var levelSelectGroup = Postit {
//	nodes: [
//		VBox {
//			translateX: 30
//			translateY: 60
//			spacing: 20
//			content: bind [
//				Text {
//					translateX: 45
//					font: sizedFont
//					content: "LevelS"
//				}
//				for(i in [0..2]) {
//					HBox {
//						spacing: 50
//						content: [
//							for(j in [1..4]) {
//								Text {
//									fill: PastelPaint.getInstance()
//									font: Font {
//										name: "SketchFont"
//										size: 39
//									}
//									content: "{j+i*4}"
//								}
//							}
//						]
//					}
//				}
//				Text {
//					translateX: 60
//					font: sizedFont
//					content: "next one !"
//				}
//			]
//		}
//	]
//}
//
//public var credits = Postit {
//	nodes: [
//		Text {
//			font: Font {
//				name: "SketchFont"
//				size: 20
//			}
//			//fill: ColorPaint.getInstance()
//			content: "by Claudio Santini\nSource avaible under GNU Public license"
//		}
//	]
//}

//var g = endLevelGroup(1, 43);
//Stage {
//	width: 500
//	height: 500
//	scene: Scene {
//		content: g
//	}
//}
//
//showPostit(g);

