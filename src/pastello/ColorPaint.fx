/*
 * ColorPaint.fx
 *
 * Created on 4-mag-2009, 22.47.01
 */

package pastello;
import javafx.scene.paint.Color;

/**
 * @author Claudio Santini
 */

def colors : Color[] = [
	Color.web("#bba2c9"),	// viola
	Color.web("#508dcb"),	// blu
	Color.web("#a6e053"),	// verde
	Color.web("#7aa9ef"),	// azzurro
	Color.web("#ea928d"),	// rosa
	Color.web("#2dc3a9"),	// acquamarina
	Color.web("#d54d4d")	// rosso
];

def staticColors : Color[] = [
	Color.web("#e7a526"),	// arancio
	Color.web("#408f8c"),	// verde
	Color.web("#835c12"),	// marrone
];

var count = 0;
var staticCount = 0;

public function getInstance() {
	var ret = colors[count];
	count = (count+1) mod (colors.size()-1);
	return ret;
}

public function getRedInstance() {
	return colors[colors.size()-1];
}

public function getStaticInstance() {
//	var ret = staticColors[staticCount];
//	staticCount = (staticCount+1) mod (staticColors.size());
//	return ret;
	return staticColors[0];
}

