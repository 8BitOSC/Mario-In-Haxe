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
		for (spr in members) {
			var doWeDraw:Bool = (spr != null && spr.exists && spr.visible);
			if (Reflect.field(spr, 'x') != null) {
				var x:Float = Reflect.field(spr, 'x');
				var y:Float = Reflect.field(spr, 'y');
				var w:Float = Reflect.field(spr, 'width');
				var h:Float = Reflect.field(spr, 'height');
				Reflect.setField(spr, 'visible', doWeDraw
					&& (x + w > cameraBounds.min.x)
					&& (x < cameraBounds.max.x)
					&& (y + h > cameraBounds.min.y)
					&& (y < cameraBounds.max.y));
			}
		}
		super.draw();
	}
}
