package states.editor;

import sprites.Tile;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import states.State;
import flixel.FlxSprite;
import sprites.TileGroup;

class EditorState extends State {
	var tiles:TileGroup = null;
	var selectedTile:Tile = null;

	var levelInfo:LevelMeta = {
		tiles: [for (i in 0...50) {x: i, y: 0, type: 'ground'}].concat([for (i in 0...50) {x: i, y: 1, type: 'ground'}]),
		theme: "ground",
		scale: 2
	}

	var tileSize:Float = 16;

	override public function create():Void {
		super.create();
		bgColor = 0xff8f9aff;

		FlxG.mouse.visible = true;
		FlxG.mouse.useSystemCursor = true;

		tileSize = 16 * levelInfo.scale;

		FlxG.watch.add(FlxG.camera, 'zoom', 'zoom');
		FlxG.watch.add(FlxG.camera.scroll, 'x', 'scrollX');
		FlxG.watch.add(FlxG.camera.scroll, 'y', 'scrollY');
		FlxG.watch.add(cameraBounds, 'width', 'cameraWidth');
		FlxG.watch.add(cameraBounds, 'height', 'cameraHeight');

		tiles = new TileGroup(levelInfo);
		add(tiles);

		selectedTile = new Tile(0, 0, levelInfo.scale);
		selectedTile.alpha = 0.4;
		add(selectedTile);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		var x:Float = Math.floor(FlxG.mouse.x / tileSize) * tileSize;
		var y:Float = Math.floor(FlxG.mouse.y / tileSize) * tileSize;
		var w:Float = tileSize;
		x += w / 2;
		x -= 6;
		selectedTile.x = x;
		selectedTile.y = y;
		var up:Bool = FlxG.keys.pressed.A || FlxG.keys.pressed.UP;
		var down:Bool = FlxG.keys.pressed.D || FlxG.keys.pressed.DOWN;
		var left:Bool = FlxG.keys.pressed.W || FlxG.keys.pressed.LEFT;
		var right:Bool = FlxG.keys.pressed.S || FlxG.keys.pressed.RIGHT;
		if (left)
			FlxG.camera.scroll.x -= 4;
		if (right)
			FlxG.camera.scroll.x += 4;
		if (up)
			FlxG.camera.scroll.y -= 4;
		if (down)
			FlxG.camera.scroll.y += 4;
	}
}
