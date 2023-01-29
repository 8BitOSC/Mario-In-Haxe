package sprites;

import flixel.math.FlxPoint;
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
	type:String,
	id:Int
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
			addNewTile(data, t);
		}
	}

	public function searchForTile(id:Int, ?callback:Tile->Void):Tile {
		id += 1;
		trace(this.members);
		trace(callback);
		for (t in this.members) {
			if(t == null) continue;
			if (t.id == id) {
				if (callback != null) {
					callback(t);
				}
				return t;
			}
		}
		return null;
	}

	public function destroyTile(id:Int):Void {
		searchForTile(id, function(t:Tile) {
			var oldId:Int = t.id;
			this.remove(t);
			t.destroy();
			for (i in this.members) {
				if(Reflect.field(i, 'id') == null) continue;
				if (i.id > oldId) {
					i.id -= 1;
				}
			}
		});
	}

	public function isTileOccupied(x:Int,y:Int):Bool{
		var toReturn = false;
		for (t in this.members) {
			if(t == null) continue;
			trace(new FlxPoint(x,y));
			trace(t.actualPosition);
			if (t.x == x && t.y == y) {
				toReturn = true;
			}
		}
		return toReturn;
	}

	public function addNewTile(data:LevelMeta, t:TileMeta) {
		var w:Float = 16 * data.scale;
		var x:Float = (t.x) * w;
		var y:Float = (t.y) * w;
		var origX:Float = x;
		var origY:Float = y;
		x += w / 2;
		var subVal:Int = 6;
		x -= subVal;
		y += w / 2;
		y += subVal;
		add(new Tile(x, FlxG.height - y, data.scale, data.theme, t.type, t.id,origX,origY));
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
				// trace(x);
				// trace(y);
				// trace(cameraBounds);
				// doWeDraw = if do we draw and the following:
				// x is greater than the camera bounds min x
				// x is less than the camera bounds max x
				// y is greater than the camera bounds min y
				// y is less than the camera bounds max y
				// width/height is added to x/y before calculations
				x += w;
				y += h;
				// doWeDraw = doWeDraw && (x > cameraBounds.min.x && x < cameraBounds.max.x && y > cameraBounds.min.y && y < cameraBounds.max.y);
				// doWeDraw = dowedraw and x is greater than cameraBounds min x
				// x is less than FlxG.width
				// y is greater than cameraBounds min y
				// y is less than FlxG.height
				doWeDraw = doWeDraw
					&& (x + w * 1.5 > cameraBounds.min.x && x - w * 1.5 < cameraBounds.max.x && y + h > cameraBounds.min.y && y < FlxG.height);
				if (doWeDraw) {
					spr.draw();
				}
			}

			FlxCamera._defaultCameras = oldDefaultCameras;
		}
	}
}
