package sprites;

import sprites.Tile;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxObject;
import tools.Util;

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
			var w:Float = 16 * data.scale;
			var x:Float = (t.x) * w;
			var y:Float = (t.y) * w;
			x += w / 2;
			var subVal:Int = 6;
			x -= subVal;
			y += w / 2;
			y += subVal;
			add(new Tile(x, FlxG.height - y, data.scale, data.theme, t.type));
			FlxG.log.add(x);
			FlxG.log.add(FlxG.height - y);
		}
	}

	override public function draw():Void {
        var cameraBounds = Util.getCameraBounds();
        @:privateAccess {
			var oldDefaultCameras = FlxCamera._defaultCameras;
			if (cameras != null) {
				FlxCamera._defaultCameras = cameras;
			}

			for (spr in members) {
				var doWeDraw:Bool = (spr != null && spr.exists && spr.visible);
				var x:Float = Reflect.field(spr, 'x');
				var y:Float = Reflect.field(spr, 'y');
				var w:Float = Reflect.field(spr, 'width');
				var h:Float = Reflect.field(spr, 'height');
				doWeDraw = doWeDraw && (x + w > cameraBounds.min.x) && (x < cameraBounds.max.x) && (y + h > cameraBounds.min.y) && (y < cameraBounds.max.y);
				if (doWeDraw) {
					spr.draw();
				}
			}

			FlxCamera._defaultCameras = oldDefaultCameras;
		}
		super.draw();
	}
}
