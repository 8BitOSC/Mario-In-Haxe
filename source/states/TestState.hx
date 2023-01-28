package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import states.State;
import flixel.FlxSprite;
import sprites.TileGroup;

class TestState extends State {
	var bg:FlxSprite = null;
	var user:String = '';

	override public function create():Void {
		super.create();

		var scaleVal:Float = 2;
		bg = FlxGridOverlay.create(20, 20, Math.floor(FlxG.width * scaleVal), Math.floor(FlxG.height * scaleVal), true, 0xffff9500, 0xffffe4a4);
		bg.x = 1;
		bg.y = 1;

		add(bg);
		// x, y, width, height, camera width, camera height, camera zoom, camera scroll x, camera scroll y
		FlxG.watch.add(bg, 'x', 'x');
		FlxG.watch.add(bg, 'y', 'y');
		FlxG.watch.add(bg, 'width', 'width');
		FlxG.watch.add(bg, 'height', 'height');
		FlxG.watch.add(FlxG.camera, 'zoom', 'zoom');
		FlxG.watch.add(FlxG.camera.scroll, 'x', 'scrollX');
		FlxG.watch.add(FlxG.camera.scroll, 'y', 'scrollY');
		FlxG.watch.add(FlxG, 'width', 'cameraWidth');
		FlxG.watch.add(FlxG, 'height', 'cameraHeight');

		var toAdd:LevelMeta = {tiles: [], theme: "ground", scale: 2};

		for (i in 0...25) {
			toAdd.tiles.push({
				x: i,
				y: 0,
				type: 'ground'
			});
		}

		var block = new TileGroup(toAdd);
		add(block);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		if (bg != null) {
			var move:Float = 1;
			bg.x += move;
			bg.y += move;
			//if (bg.x >= 0)
			//	bg.x = -200;
			//if (bg.y >= 0)
			//	bg.y = -200;
		}
		if (FlxG.keys.pressed.UP)
			FlxG.camera.zoom -= 0.1;
		if (FlxG.keys.pressed.DOWN)
			FlxG.camera.zoom += 0.1;
		if (FlxG.keys.pressed.A)
			FlxG.camera.scroll.x -= 2;
		if (FlxG.keys.pressed.D)
			FlxG.camera.scroll.x += 2;
		if (FlxG.keys.pressed.W)
			FlxG.camera.scroll.y -= 2;
		if (FlxG.keys.pressed.S)
			FlxG.camera.scroll.y += 2;
		if (FlxG.keys.justPressed.R)
			FlxG.resetState();
	}
}
