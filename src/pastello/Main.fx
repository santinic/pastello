/*
 * Main.fx
 *
 * Created on 11-feb-2009, 0.30.45
 */

package pastello;

import javafx.scene.media.Media;
import javafx.scene.media.MediaPlayer;
import javafx.scene.Scene;
import javafx.stage.Stage;
import pastello.GamePlay;
import pastello.GameScene;
import pastello.StartMenu;

/**
 * @author Claudio Santini
 */

var gamePlay = GamePlay.getInstance();

MediaPlayer {
	repeatCount: MediaPlayer.REPEAT_FOREVER
	media: Media {
		source: "{__DIR__}resources/ghost-lullaby.mp3"
	}
}.play();

Stage {
    title: "Pastello"
    width: GameScene.WIDTH
    height: GameScene.HEIGHT
	resizable: false
	scene: Scene {
		content: bind
			[StartMenu.bg, gamePlay.gameScene.objects, gamePlay.gameScene.content];
	}
}
