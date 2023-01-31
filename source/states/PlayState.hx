package states;

import sprites.Mario;
import flixel.group.FlxGroup;
import sprites.Tile;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.FlxSprite;
import sprites.TileGroup;
import flixel.math.FlxPoint;
import tools.Util;
import flixel.text.FlxText;
import flixel.addons.ui.FlxUIButton;

class PlayState extends FlxState {
	var tiles:TileGroup = null;

	var levelInfo:LevelMeta = null;
	var mario:Mario = null;

	var tileSize:Float = 16;

	var scrollPosition:FlxPoint = new FlxPoint(0, 0);
	var selectedTilePosition:FlxPoint = new FlxPoint(0, 0);

	var types:Array<String> = [];
	var selectedType:Int = 0;

	var cameraBounds:MinAndMax = Util.getCameraBounds();

	override public function new(data:LevelMeta,marioX:Float,marioY:Float){
		this.levelInfo = data;
		mario = new Mario(marioX,marioY);
		super();
	}

	override public function create():Void {
		super.create();
		bgColor = 0xff8f9aff;

		FlxG.mouse.visible = false;

		tileSize = 16 * levelInfo.scale;

		tiles = new TileGroup(levelInfo);

		add(tiles);
		add(mario);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		cameraBounds = Util.getCameraBounds();
	}
}
