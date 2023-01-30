package states;

import flixel.util.typeLimit.OneOfTwo;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxObject;
import Std.isOfType as is;
import tools.Util;

/**
 * a state that gives an automatic camera bound window
 */
class State extends flixel.FlxState {
	private var cameraBounds:MinAndMax = Util.getCameraBounds();

	override public function update(elapsed:Float):Void {
		cameraBounds = Util.getCameraBounds();
		super.update(elapsed);
	}
}
