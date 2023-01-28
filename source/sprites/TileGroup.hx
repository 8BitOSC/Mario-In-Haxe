package sprites;

import sprites.Tile;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxObject;

typedef TileMeta = {
	x:Int,
	y:Int,
	type:String
}

typedef LevelMeta = {
	tiles:Array<TileMeta>,
	theme:String,
	scale:Int
}

class TileGroup extends FlxTypedGroup<Tile> {
	override public function new(data:LevelMeta) {
		super(0);
		for (t in data.tiles) {
			trace(t);
			var w:Float = 16 * data.scale;
			var x:Float = (t.x) * w;
			var y:Float = (t.y) * w;
			x += w / 2;
			var subVal:Int = 6;
			x -= subVal;
			y += w / 2;
			y += subVal;
			add(new Tile(x, FlxG.height - y, data.scale, data.theme, t.type));
		}
	}

	override public function draw():Void {
		@:privateAccess {
			var i:Int = 0;
			var spr:Tile = null;

			var oldDefaultCameras = FlxCamera._defaultCameras;
			if (cameras != null) {
				FlxCamera._defaultCameras = cameras;
			}

			while (i < length) {
				spr = members[i++];

				var doWeDraw:Bool = (spr != null && spr.exists && spr.visible);
				var x:Float = spr.x;
				var y:Float = spr.y;
				var w:Float = spr.width;
				var h:Float = spr.height;
				doWeDraw = doWeDraw && (x + w > 0) && (x < FlxG.width) && (y + h > 0) && (y < FlxG.height);
				if (doWeDraw) {
					spr.draw();
				}
			}

			FlxCamera._defaultCameras = oldDefaultCameras;
		}
	}
}
