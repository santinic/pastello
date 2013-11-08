/*
 * StartMenu.fx
 *
 * Created on 28-apr-2009, 21.10.06
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
import javafx.scene.layout.VBox;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import javafx.scene.text.TextAlignment;
import javafx.stage.AppletStageExtension;
import javax.swing.JOptionPane;
import pastello.GamePlay;
import pastello.GameScene;
import pastello.PastelPaint;

/**
 * @author Claudio Santini
 */

public var aboutAuthorURL = "http://theorymatters.wordpress.com/about";

// The background paper picture
public var bg = ImageView {
	image: Image {
		url: "{__DIR__}resources/board.jpg"
	}
}

// The group with the starting menu nodes
public var menuGroup : Group = Group {

	var normalFont = Font {
		name: "SketchFont"
		size: 70
	}
	var boldFont =  Font {
		name: "SketchFont"
		size: 75
	}

	var goToGameMode = function() {
		ParallelTransition {
			content: [
				ScaleTransition {
					node: bg
					duration: 2s
					byX: 0.3
					byY: 0.3
					repeatCount: 1
				}
				FadeTransition {
					node: menuGroup
					duration: 2s
					fromValue: 1.0
					toValue: 0.0
					repeatCount: 1
				}
			]
			action: function() {
				GamePlay.getInstance().gameScene.gameMode();
			}
		}.play();
	};

	var zoomableBox = function(node : Node, act : function(e: MouseEvent)) : Group {
		return Group {
			onMouseEntered: function(e : MouseEvent) {
				ScaleTransition {
					node: e.node
					duration: 0.15s
					byX: 0.1
					byY: 0.1
					repeatCount: 2
					autoReverse: true
				}.play();
			}
			onMousePressed: act
			cursor: Cursor.HAND
			content: [
				node
				Rectangle {
					x: node.layoutBounds.minX
					y: node.layoutBounds.minY
					width: node.layoutBounds.width
					height: node.layoutBounds.height
					fill: Color.TRANSPARENT
				}
			]
		}
	};

//	var author = VBox {
//		opacity: 0
//		translateX: 20
//		translateY: 120
//		content: [
//			Text {
//				font: Font {
//					name: "SketchFont"
//					size: 36
//				}
//				//fill: ColorPaint.getInstance()
//				content: "by Claudio Santini\n"
//				"Source avaible under GNU Public license"
//			}
//		]
//	};

	var startGame = zoomableBox(
		Text {
			x: GameScene.WIDTH / 2 - 170
			y: GameScene.HEIGHT / 2 - 50
			font: normalFont
			textAlignment: TextAlignment.CENTER
			content: "Start Game"
			fill: PastelPaint.getInstance()
		},
		function(e: MouseEvent) {
			goToGameMode();
		}
	);

	var levelEditor = zoomableBox(
		Text {
			x: GameScene.WIDTH / 2 - 170
			y: GameScene.HEIGHT / 2 + 40
			font: normalFont
			textAlignment: TextAlignment.CENTER
			content: "Level editor"
			fill: PastelPaint.getInstance()
		},
		function(e: MouseEvent) {
			GameScene.isEditorMode = true;
			goToGameMode();
		}
	);

	var credits : Group = zoomableBox(
		Text {
			x: GameScene.WIDTH / 2 - 110
			y: GameScene.HEIGHT / 2 + 120
			font: normalFont
			textAlignment: TextAlignment.CENTER
			content: "CreditS"
			fill: PastelPaint.getInstance()
		},
		function(e: MouseEvent) : Void {
			AppletStageExtension.showDocument("http://theorymatters.wordpress.com/about", "_blank");
//			JOptionPane.showMessageDialog(null,
//				"<html>"
//				"Programmed in JavaFX by Claudio Santini (2009), http://theorymatters.wordpress.com<br>"
//				"Source avaible under GNU Public license<br><br>"
//				"Pastello is a game inspired by the original game \"Crayon Physics\" by Petri Purho<br>"
//				"and uses Phys2D, a 2D physics engine based on the work of Erin Catto<br>"
//				"The source of Phys2D is provided under the terms of the BSD License.<br><br>"
//				"Music: _ghost - Lullaby (used under the Creative Commons Attribution-NonCommercial 2.5 license)<br>"
//				"The graphics of the game are under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 license<br>"
//				"The background texture is based on Felipe Skroski’s photo \"One for SXC\" licensed<br>"
//				"under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 license",
//				"Author",
//				JOptionPane.INFORMATION_MESSAGE);
		}
	);

	var buttonGroup : Group = Group {
		content: [
			Text {
				x: GameScene.WIDTH / 2 - 150
				y: 100
				font: Font {
					name: "SketchFont"
					size: 96
				}
				content: "Pastello"
				fill: PastelPaint.getInstance()
			}
			Text {
				x: GameScene.WIDTH / 2 - 100
				y: 150
				font: Font {
					name: "SketchFont"
					size: 60
				}
				content: "preview"
				fill: PastelPaint.getInstance()
			}
			startGame
			levelEditor
			credits
		]
	}

	content:  [
		buttonGroup
//		author
	]
}