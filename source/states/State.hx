package states;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxCamera;

class State extends flixel.FlxState {
	override public function draw():Void {
		@:privateAccess {
			var i:Int = 0;
			var basic:FlxBasic = null;

			var oldDefaultCameras = FlxCamera._defaultCameras;
			if (cameras != null) {
				FlxCamera._defaultCameras = cameras;
			}

			while (i < length) {
				basic = members[i++];

				if (basic != null && basic.exists && basic.visible) {
					basic.draw();
				}
				trace('drew!!');
			}

			FlxCamera._defaultCameras = oldDefaultCameras;
		}
	}
}
