package tools;

import flixel.FlxG;
import flixel.FlxCamera;
import flixel.math.FlxPoint;

typedef MinAndMax = {
	var min:FlxPoint;
    var max:FlxPoint;
}

class Util {
	public static function getCameraBounds(camera:FlxCamera = null):MinAndMax {
        if(camera == null) camera = FlxG.camera;
		var width:Int = Std.int(camera.zoom * FlxG.width);
		var height:Int = Std.int(camera.zoom * FlxG.height);
		var min:FlxPoint = camera.scroll;
        var max:FlxPoint = new FlxPoint(min.x + width, min.y + height);
        return {min: min, max: max};
	}
}
