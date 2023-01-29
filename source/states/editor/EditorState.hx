package states.editor;

#if desktop
import flixel.group.FlxGroup;
import sprites.Tile;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import states.State;
import flixel.FlxSprite;
import sprites.TileGroup;
import flixel.math.FlxPoint;

class EditorState extends State {
	var tiles:TileGroup = null;
	var selectedTile:Tile = null;

	var levelInfo:LevelMeta = {
		tiles: [
			for (i in 0...4)
				{
					x: i,
					y: 0,
					type: 'ground',
					id: 1
				}
		].concat([
			for (i in 0...4)
				{
					x: i,
					y: 1,
					type: 'ground',
					id: i + 4
				}
			]),
		theme: "ground",
		scale: 2
	}

	var tileSize:Float = 16;

	var scrollPosition:FlxPoint = new FlxPoint(0, 0);
	var selectedTilePosition:FlxPoint = new FlxPoint(0, 0);

	var types:Array<String> = [];
	var selectedType:Int = 0;

	override public function create():Void {
		super.create();
		bgColor = 0xff8f9aff;

		selectedTile = new Tile(0, 0, levelInfo.scale + 0.1);
		selectedTile.alpha = 0.4;
		types = selectedTile.anims;

		FlxG.mouse.visible = true;
		FlxG.mouse.useSystemCursor = true;

		tileSize = 16 * levelInfo.scale;

		FlxG.watch.add(FlxG.camera, 'zoom', 'zoom');
		FlxG.watch.add(scrollPosition, 'x', 'scrollX');
		FlxG.watch.add(scrollPosition, 'y', 'scrollY');
		FlxG.watch.add(cameraBounds, 'width', 'cameraWidth');
		FlxG.watch.add(cameraBounds, 'height', 'cameraHeight');
		FlxG.watch.add(FlxG.mouse,'wheel', 'mouseScroll');

		tiles = new TileGroup(levelInfo);
		add(selectedTile);
		insert(members.indexOf(selectedTile)+1, tiles);
		
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		var x:Float = Math.floor(FlxG.mouse.x / tileSize) * tileSize;
		var y:Float = Math.floor(FlxG.mouse.y / tileSize) * tileSize;
		selectedTilePosition.x = x / tileSize;
		selectedTilePosition.y = y / tileSize;
		x += tileSize / 2;
		var subVal:Int = 7;
		x -= subVal;
		y -= subVal;
		y += tileSize / 2;
		selectedTile.x = x;
		selectedTile.y = y;
		var up:Bool = FlxG.keys.pressed.W || FlxG.keys.pressed.UP;
		var down:Bool = FlxG.keys.pressed.S || FlxG.keys.pressed.DOWN;
		var left:Bool = FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT;
		var right:Bool = FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT;
		if (left)
			FlxG.camera.scroll.x -= 4;
		if (right)
			FlxG.camera.scroll.x += 4;
		if (up)
			FlxG.camera.scroll.y -= 4;
		if (down)
			FlxG.camera.scroll.y += 4;

		scrollPosition.x = Math.floor(FlxG.camera.scroll.x);
		scrollPosition.y = Math.floor(FlxG.camera.scroll.y);
		if (scrollPosition.x < 0)
			scrollPosition.x = 0;
		if (scrollPosition.y > 0)
			scrollPosition.y = 0;

		FlxG.camera.scroll.x = scrollPosition.x;
		FlxG.camera.scroll.y = scrollPosition.y;

		var x:Int = Std.int(selectedTilePosition.x);
		var y:Int = Std.int(FlxG.height / tileSize - selectedTilePosition.y) - 1;

		var mouseMoveInThisFrame:Int = Std.int(Util.clamp(FlxG.mouse.wheel, -1, 1));
		selectedType += mouseMoveInThisFrame;
		selectedType = selectedType % types.length;
		selectedTile.changeType(types[selectedType]);

		if (FlxG.mouse.pressed) {
			var nextId:Int = levelInfo.tiles[levelInfo.tiles.length - 1].id + 1;
			if (tiles.isTileOccupied(x, y))
				return;
			var t:TileMeta = {
				x: x,
				y: y,
				type: 'ground',
				id: nextId
			};
			levelInfo.tiles.push(t);
			tiles.addNewTile(levelInfo, t);
		}
		if (FlxG.mouse.pressedRight) {
			tiles.destroyTileAtPos(x, y);
		}
	}
}
#end
