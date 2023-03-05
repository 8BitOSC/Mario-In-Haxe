package sprites;

import flixel.util.FlxCollision;
import flixel.math.FlxPoint;
import sprites.Tile;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxG;
import flixel.FlxSprite;
import tools.Util;

typedef Spawn = {
	x:Int,
	y:Int
}

typedef TileMeta = {
	x:Int,
	y:Int,
	type:String,
	id:Int
}

typedef LevelMeta = {
	tiles:Array<TileMeta>,
	spawn:Spawn,
	theme:String,
	scale:Int
}

class TileGroup extends FlxTypedGroup<Tile> {

	/**
	 * creates a new group of tiles from a level meta object
	 * @param data the array of tiles to use
	 */
	override public function new(data:LevelMeta) {
		super(0);
		for (t in data.tiles) {
			addNewTile(data, t);
		}
	}

	/**
	 * searches for a tile with the given id and returns it
	 * @param id the id of the tile to search for
	 * @param callback a callback to run on the tile if it is found
	 * @return Tile
	 */
	public function searchForTile(id:Int, ?callback:Tile->Void):Tile {
		id += 1;
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

	/**
	 * searches for a tile at the given position and returns it
	 * @param x the x position to search for
	 * @param y the y position to search for
	 * @param callback a callback to run on the tile if it is found
	 * @return Tile
	 */
	public function searchForTileAtPos(x:Int, y:Int, ?callback:Tile->Void):Tile {
		for (t in this.members) {
			if(t == null) continue;
			if (t.actualPosition.x == x && t.actualPosition.y == y) {
				if (callback != null) {
					callback(t);
				}
				return t;
			}
		}
		return null;
	}

	/**
	 * an internal callback used in destroy functions
	 * @param t the tile to destroy
	 */
	private function destroyCallback(t:Tile) {
		var oldId:Int = t.id;
		this.remove(t);
		t.destroy();
		for (i in this.members) {
			if(Reflect.field(i, 'id') == null) continue;
			if (i.id > oldId) {
				i.id -= 1;
			}
		}
	}

	/**
	 * destroys a tile with the given id
	 * @param id the id of the tile to destroy
	 */
	public function destroyTile(id:Int):Void {
		searchForTile(id, destroyCallback);
	}

	/**
	 * destroys a tile at the given position
	 * @param x the x position of the tile to destroy
	 * @param y the y position of the tile to destroy
	 */
	public function destroyTileAtPos(x:Int, y:Int):Void {
		searchForTileAtPos(x, y, destroyCallback);
	}

	/**
	 * checks if a tile is occupied at the given position
	 * @param x the x position to check
	 * @param y the y position to check
	 * @return Bool
	 */
	public function isTileOccupied(x:Int,y:Int):Bool{
		var toReturn = false;
		for (t in this.members) {
			if(t == null) continue;
			if (t.actualPosition.x == x && t.actualPosition.y == y) {
				toReturn = true;
			}
		}
		return toReturn;
	}

	/**
	 * adds a new tile to the group
	 * @param data the level meta object, used for scale and theme
	 * @param t the tile meta object
	 */
	public function addNewTile(data:LevelMeta, t:TileMeta) {
		var w:Float = 16 * data.scale;
		var x:Float = (t.x) * w;
		var y:Float = (t.y) * w;
		var origX:Float = t.x;
		var origY:Float = t.y;
		x += w / 2;
		var subVal:Int = 6;
		x -= subVal;
		y += w / 2;
		y += subVal;
		add(new Tile(x, FlxG.height - y, data.scale, data.theme, t.type, t.id,origX,origY));
	}

	/**
	 * check if the tiles collide with a sprite
	 * @param sprite the sprite to check
	 * @return Dynamic
	 */

	public function collidesWith(sprite:FlxSprite):Dynamic{
		for(t in this.members){
			if(FlxCollision.pixelPerfectCheck(t,sprite)){
				return {"collided":true,"positions":t.axis};
			}
		}
		return {"collided":false,"positions":null};
	}
}
