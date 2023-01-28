package states;

import flixel.util.typeLimit.OneOfTwo;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxObject;
import Std.isOfType as is;

class State extends flixel.FlxState {
	override public function draw():Void {
		@:privateAccess {
			var i:Int = 0;
			var spr:FlxBasic = null;

			var oldDefaultCameras = FlxCamera._defaultCameras;
			if (cameras != null) {
				FlxCamera._defaultCameras = cameras;
			}

			while (i < length) {
				spr = members[i++];

				var doWeDraw:Bool = (spr != null && spr.exists && spr.visible);
				if (Reflect.field(spr,'x') != null) {
					var x:Float = Reflect.field(spr,'x');
					var y:Float = Reflect.field(spr,'y');
					var w:Float = Reflect.field(spr,'width');
					var h:Float = Reflect.field(spr,'height');
					doWeDraw = doWeDraw && (x + w > 0) && (x < FlxG.width) && (y + h > 0) && (y < FlxG.height);
				}
				if (doWeDraw) {
					spr.draw();
				}
			}

			FlxCamera._defaultCameras = oldDefaultCameras;
		}
	}
}
