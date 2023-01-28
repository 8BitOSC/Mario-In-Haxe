package states;

import flixel.util.typeLimit.OneOfTwo;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxObject;
import Std.isOfType as is;
import tools.Util;

class State extends flixel.FlxState {
	private var cameraBounds:MinAndMax = Util.getCameraBounds();

	override public function draw():Void {
		@:privateAccess {
			var oldDefaultCameras = FlxCamera._defaultCameras;
			if (cameras != null) {
				FlxCamera._defaultCameras = cameras;
			}

			for (spr in members) {
				if(Reflect.field(spr, 'x') == null){
					spr.draw();
					FlxCamera._defaultCameras = oldDefaultCameras;
					return;
				}
				var doWeDraw:Bool = (spr != null && spr.exists && spr.visible);
				var x:Float = Reflect.field(spr, 'x');
				var y:Float = Reflect.field(spr, 'y');
				var w:Float = Reflect.field(spr, 'width');
				var h:Float = Reflect.field(spr, 'height');
				doWeDraw = doWeDraw && (x + w > cameraBounds.min.x) && (x < cameraBounds.max.x) && (y + h > cameraBounds.min.y) && (y < cameraBounds.max.y);
				if (doWeDraw) {
					spr.draw();
				}
			}

			FlxCamera._defaultCameras = oldDefaultCameras;
		}
	}

	override public function update(elapsed:Float):Void {
		cameraBounds = Util.getCameraBounds();
		super.update(elapsed);
	}
}
