/*
 * Prove.fx
 *
 * Created on 23-apr-2009, 1.43.12
 */

package pastello;

import javafx.scene.Group;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.HBox;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.Scene;
import javafx.scene.shape.Line;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Text;
import javafx.stage.Stage;
import pastello.PastelPaint;

/**
 * @author Claudio
 */
PastelPaint.initTextures();

function hover(n : Node) {
	n.opacity = 0;
}


var x : Integer[];
insert 23 into x;
insert 14 into x;

Stage {
    title: "Application title"
    width: 250
    height: 80
    scene: Scene {
		content: [
		Group {
			content: [
				HBox {
					spacing: 10
					content: [
						Text {
							x: 30
							y:30
							content: bind "{x[0]}"
						}

						javafx.scene.shape.Circle {
							centerX: 13
							centerY: 13
							radius: 13
							fill: null
							stroke: PastelPaint{}
							strokeWidth: 3
							onMouseEntered: function(e : MouseEvent) {
								hover(e.node);
							}

						}
						javafx.scene.shape.Polygon {
							translateX: 0
							translateY: 0
							points: [
								25, 25,
								0, 25,
								0, 0,
							]
							fill: null
							stroke: PastelPaint{}
							strokeWidth: 3
						}
						Rectangle {
							translateY: 5
							width: 30
							height: 20
							fill: null
							stroke: PastelPaint{}
							strokeWidth: 3
						}
						javafx.scene.shape.Polygon {
							translateX: 0
							translateY: 0
							points: [
								0, 20,
								30, 0,
								35, 5,
								5, 25
							]
							fill: null
							stroke: PastelPaint{}
							strokeWidth: 3
						}
						javafx.scene.shape.Circle {
							centerX: 6
							centerY: 14
							radius: 7
							fill: null
							stroke: Color.ORANGERED
							strokeWidth: 2
						}
						Group {
							translateY: 10
							translateX: 5
							content: [
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
							]
						}
					]

				}
			]
        }
		]
    }
}