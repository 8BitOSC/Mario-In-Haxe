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
	/**
	 * get the bounds of the camera in world coordinates
	 * @param camera the camera to get the bounds of
	 * @return MinAndMax
	 */
	public static function getCameraBounds(camera:Null<FlxCamera> = null):MinAndMax {
        if(camera == null) camera = FlxG.camera;
        if(camera == null) return {min: new FlxPoint(0, 0), max: new FlxPoint(0, 0), width: 0, height: 0};
		var width:Int = Std.int(FlxG.width / camera.zoom);
		var height:Int = Std.int(FlxG.height / camera.zoom);
		var min:FlxPoint = camera.scroll;
        var max:FlxPoint = new FlxPoint(min.x + width, min.y + height);
        return {min: min, max: max, width: width, height: height};
	}
    /**
     * clamp a value between min and max
     * @param value the value to clamp
     * @param min the minimum value
     * @param max the maximum value
     * @return Float
     */
    public static function clamp(value:Float, min:Float, max:Float):Float {
        return Math.max(min, Math.min(max, value));
    }
}
