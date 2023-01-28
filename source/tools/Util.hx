package tools;

import flixel.FlxG;
import flixel.FlxCamera;
import flixel.math.FlxPoint;

typedef MinAndMax = {
	var min:FlxPoint;
	var max:FlxPoint;
	var width:Int;
	var height:Int;
}

class Util {
	public static function getCameraBounds(camera:FlxCamera):MinAndMax {
		var width:Int = Std.int(camera.zoom * FlxG.width);
		var height:Int = Std.int(camera.zoom * FlxG.height);
		var min:FlxPoint = camera.scroll;
		var max:FlxPoint = new FlxPoint(min.x + width, min.y + height);
		var width:Int = Std.int(max.x - min.x);
		var height:Int = Std.int(max.y - min.y);
		return {
			min: min,
			max: max,
			width: width,
			height: height
		};
	}
}
