package states.editor;

import sprites.Mario;
import flixel.group.FlxGroup;
import sprites.Tile;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import states.State;
import flixel.FlxSprite;
import sprites.TileGroup;
import flixel.math.FlxPoint;
import tools.Util;
import flixel.text.FlxText;
import flixel.addons.ui.FlxUIButton;

class EditorState extends State {
	var tiles:TileGroup = null;
	var selectedTile:Tile = null;
	var marioSpawn:MarioSpawn = null;
	var selectedMarioSpawn:MarioSpawn = null;

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
		spawn: {
			x: 1,
			y: 2
		},
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

		selectedMarioSpawn = new MarioSpawn(0, 0, levelInfo.scale + 0.1);
		selectedMarioSpawn.alpha = 0.4;

		types = selectedTile.anims;
		types.reverse();
		types.push('spawn');

		FlxG.mouse.visible = true;
		FlxG.mouse.useSystemCursor = true;

		tileSize = 16 * levelInfo.scale;

		FlxG.watch.add(FlxG.camera, 'zoom', 'zoom');
		FlxG.watch.add(scrollPosition, 'x', 'scrollX');
		FlxG.watch.add(scrollPosition, 'y', 'scrollY');
		FlxG.watch.add(cameraBounds, 'width', 'cameraWidth');
		FlxG.watch.add(cameraBounds, 'height', 'cameraHeight');
		FlxG.watch.add(FlxG.mouse, 'wheel', 'mouseScroll');
		FlxG.watch.addMouse();

		tiles = new TileGroup(levelInfo);
		marioSpawn = new MarioSpawn(levelInfo.spawn.x, levelInfo.spawn.y, levelInfo.scale);

		add(tiles);
		add(marioSpawn);
		add(selectedMarioSpawn);
		add(selectedTile);
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
		selectedMarioSpawn.x = x;
		selectedMarioSpawn.y = y;
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
		if (selectedType < 0)
			selectedType = types.length - 1;
		if (selectedType >= types.length)
			selectedType = 0;
		if (types[selectedType] == 'spawn') {
			selectedTile.visible = false;
			selectedMarioSpawn.visible = true;
		} else {
			selectedTile.visible = true;
			selectedMarioSpawn.visible = false;
			selectedTile.changeType(types[selectedType]);
		}

		if(FlxG.keys.justPressed.CONTROL && FlxG.keys.justPressed.S) {
			var json:String = haxe.Json.stringify(levelInfo);
		}

		if (FlxG.mouse.pressed) {
			if (types[selectedType] == 'spawn') {
				levelInfo.spawn.x = x;
				levelInfo.spawn.y = y;
				marioSpawn.changePosition(x, y);
				return;
			}
			var nextId:Int = levelInfo.tiles[levelInfo.tiles.length - 1].id + 1;
			if (tiles.isTileOccupied(x, y))
				return;
			var t:TileMeta = {
				x: x,
				y: y,
				type: types[selectedType],
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

class MarioSpawn extends FlxSprite {
	public function new(xPos:Float, yPos:Float, scale:Float) {
		super(0, 0);
		loadGraphic("assets/images/mario/small.png", true, 17, 18);
		animation.add("idle", [0]);
		animation.play("idle");
		this.scale.set(scale, scale);
		changePosition(xPos, yPos);
	}

	public function changePosition(xPos:Float, yPos:Float):FlxPoint {
		var w:Float = 17 * this.scale.x;
		var x:Float = (xPos) * w;
		var y:Float = (yPos) * w;
		x += w / 2;
		var subVal:Int = 6;
		x -= subVal;
		y += w / 2;
		y += subVal;
		this.x = x;
		this.y = FlxG.height - y;
		return new FlxPoint(this.x, this.y);
	}
}
