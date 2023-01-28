package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import wasteofhaxe.WasteOfHaxe2 as WasteOfHaxe;
import sys.io.File;

class MainState extends FlxState {
	var bg:FlxSprite = null;
	var user:String = '';

	override public function create():Void {
		super.create();

		var scaleVal:Float = 2;
		bg = FlxGridOverlay.create(20, 20, Math.floor(FlxG.width * scaleVal), Math.floor(FlxG.height * scaleVal), true, 0xffff9500, 0xffffe4a4);
		bg.x = 1;
		bg.y = 1;

		add(bg);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		if (bg != null) {
			var move:Float = 0.25;
			bg.x += move;
			bg.y += move;
			if (bg.x >= 0)
				bg.x = -200;
			if (bg.y >= 0)
				bg.y = -200;
		}
		if(FlxG.keys.justPressed.ANY) FlxG.resetState();
	}
}
