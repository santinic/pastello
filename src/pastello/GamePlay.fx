/*
 * GamePlay.fx
 *
 * Created on 20-apr-2009, 14.04.00
 */

package pastello;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileWriter;
import java.io.InputStream;
import java.io.InputStreamReader;
import javafx.scene.paint.Color;
import javafx.scene.shape.Circle;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import net.phys2d.math.Vector2f;
import org.json.JSONArray;
import org.json.JSONObject;
import pastello.Ball;
import pastello.Box;
import pastello.Flag;
import pastello.GamePlay;
import pastello.GameScene;
import pastello.PhysicalObject;
import pastello.Polygon;

/**
 * @author Claudio Santini
 */

var singleton : GamePlay = null;

public function getInstance() : GamePlay {
	if(singleton == null) {
		singleton = GamePlay {}
	}
	return singleton;
}

public class GamePlay {

	public var gameScene : GameScene;

	init {		
		gameScene = GameScene{
			content: bind [gameScene.visualPolygons, gameScene.nodes]
			visible:  bind if(GameScene.isGameMode) true else false
		};
	}

	/** Loads next level */
	public function loadNextLevel() : Void {
		gameScene.postit.hide();
		gameScene.level++;
		loadLevel(gameScene.level);
	}

	/** Loads specified level */
	public function loadLevel(level : Integer) {
		gameScene.level = level;
		loadJSON(getClass().getResourceAsStream("levels/{level}.json"));
	}

	/** Writes all the currurent shape objects in the scene in a JSON file */
	public function saveJSON(file: File) {
		var array = new JSONArray();
		for(obj in gameScene.objects) {
			var json = new JSONObject();
			json.put("x", obj.x);
			json.put("y", obj.y);
			json.put("isStatic", obj.isStatic);
			if(obj instanceof Box) {
				json.put("name", "Box");
				var box = obj as Box;
				json.put("w", box.w);
				json.put("h", box.h)
			}
			else if(obj instanceof Ball) {
				var ball = obj as Ball;
				json.put("name", "Ball");
				json.put("radius", ball.radius);
				json.put("isRedBall", ball.isRedBall);
			}
			else if(obj instanceof Polygon) {
				json.put("name", "Polygon");
				var poly = obj as Polygon;
				var vertices = new JSONArray();
				for(v in poly.vertices) {
					var vj = new JSONObject();
					vj.put("x", v.x);
					vj.put("y", v.y);
					vertices.put(vj);
				}
				json.put("vertices", vertices);
			}
			else if(obj instanceof Flag) {
				json.put("name", "Flag");
				json.remove("isStatic");
			}
			array.put(json);
		}
		println({array.toString()});
		var fw = new FileWriter(file);
		array.write(fw);
		fw.close();
	}

	public function loadJSON(file: InputStream) {

		gameScene.cleanupObjects();

//		var fr = new FileReader(file);
//		var br = new BufferedReader(fr);

		var br = new BufferedReader(new InputStreamReader(file));

		var txt : String;
		var s : String;
		while((s = br.readLine()) != null) {
			txt = txt.concat(s);
		}
		var array = new JSONArray(txt);
		for(i in [0..array.length()-1]) {
			var json = array.getJSONObject(i);
			var name = json.get("name");
			var obj : PhysicalObject;
			if(name.equals("Box")) {
				obj = Box {
					x: json.getLong("x")
					y: json.getLong("y")
					w: json.getLong("w")
					h: json.getLong("h")
					isStatic: json.getBoolean("isStatic")
				}
				gameScene.addObject(obj);
			}
			else if(name.equals("Ball")) {
				try {
					var fake = json.getBoolean("isFake");
					if(fake) {
						insert Circle {
							centerX: json.getLong("x")
							centerY: json.getLong("y")
							radius: json.getLong("radius")
							strokeDashArray: [5, 5]
							stroke: Color.LIGHTGRAY
							fill: null
							strokeWidth: 3
						} into gameScene.visualPolygons;
					}
				} catch(e: org.json.JSONException) {
					obj = Ball {
						x: json.getLong("x")
						y: json.getLong("y")
						radius: json.getLong("radius")
						isStatic: json.getBoolean("isStatic")
						isRedBall: json.getBoolean("isRedBall")
					}
					gameScene.addObject(obj);
				}
			}
			else if(name.equals("Polygon")) {
				var vertices = json.getJSONArray("vertices");
				obj = Polygon {
					//x: json.getLong("x")
					//y: json.getLong("y")
					isStatic: json.getBoolean("isStatic")
					vertices: [
						for(j in [0..vertices.length()-1]){
							var v = vertices.get(j) as JSONObject;
							new Vector2f(v.getLong("x"), v.getLong("y"));
						}
					]
				}
				gameScene.addObject(obj);
			}
			else if(name.equals("Flag")) {
				obj = Flag {
					x: json.getLong("x")
					y: json.getLong("y")
				}
				gameScene.addObject(obj);
			}
			else if(name.equals("Text")) {
				insert Text {
					font: Font {
						name: "SketchFont"
						size: 34
					}
					fill: ColorPaint.getInstance()
					content: json.getString("content")
					x: json.getLong("x")
					y: json.getLong("y")
				} into gameScene.visualPolygons;
			}
		}

//		fr.close();

	}
}
