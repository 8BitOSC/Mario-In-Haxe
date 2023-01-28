package tools;

import flixel.FlxG;
import flixel.FlxCamera;
import flixel.math.FlxPoint;

typedef PointWithSize = {
	var x:Float;
	var y:Float;
	var width:Int;
	var height:Int;
}

class Util {
	public function getCameraBounds(camera:FlxCamera):PointWithSize {
		var width:Int = Std.int(camera.zoom * FlxG.width);
		var height:Int = Std.int(camera.zoom * FlxG.height);
		return {
			x: camera.scroll.x,
			y: camera.scroll.y,
			width: width,
			height: height
		};
	}
}
