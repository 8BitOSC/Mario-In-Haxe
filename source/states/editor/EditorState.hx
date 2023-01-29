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

		FlxG.resizeWindow(796,448);
		FlxG.resizeGame(796,448);

		FlxG.mouse.visible = true;
		FlxG.mouse.useSystemCursor = true;

		tileSize = 16 * levelInfo.scale;

		selectedTile = new Tile(0, 0, levelInfo.scale);
		selectedTile.alpha = 0.4;
		add(selectedTile);

		FlxG.watch.add(FlxG.camera, 'zoom', 'zoom');
		FlxG.watch.add(FlxG.camera.scroll, 'x', 'scrollX');
		FlxG.watch.add(FlxG.camera.scroll, 'y', 'scrollY');
		FlxG.watch.add(cameraBounds, 'width', 'cameraWidth');
		FlxG.watch.add(cameraBounds, 'height', 'cameraHeight');

		tiles = new TileGroup(levelInfo);
		add(tiles);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		selectedTile.x = FlxG.mouse.x;
		selectedTile.y = FlxG.mouse.y;
		if (FlxG.keys.pressed.UP)
			FlxG.camera.zoom += 0.01;
		if (FlxG.keys.pressed.DOWN)
			FlxG.camera.zoom -= 0.01;
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
