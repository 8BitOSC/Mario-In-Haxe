package sprites;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

typedef TopBottom = {
	var top:Float;
	var bottom:Float;
}

typedef LeftRight = {
	var left:Float;
	var right:Float;
}

typedef Axis = {
	var topBottom:TopBottom;
	var leftRight:LeftRight;
}

class Tile extends FlxSprite {
	var animMap:Map<String, Int> = new Map<String, Int>();
	var solidMap:Map<String, Bool> = new Map<String, Bool>();

	public var id:Int = -1;
	public var actualPosition:FlxPoint = null;
	public var anims:Array<String> = [];
	public var type:String = 'ground';
	public var isSolid:Bool = true;

	var topBottom:TopBottom = {"top":0,"bottom":0};
	var leftRight:LeftRight = {"left":0,"right":0};

	public var axis:Axis = null;

	/**
	 * creates a new tile
	 * @param x x position
	 * @param y y position
	 * @param scale scaling of the tile
	 * @param level the image to grab (e.g. ground = assets/images/tiles/ground/blocks.png)
	 * @param type the type of tile (e.g. ground, brick, block, hardBlock)
	 * @param id the id of the tile
	 * @param actualX the actual x position of the tile, as x is offset
	 * @param actualY the actual y position of the tile, as y is offset
	 */
	override public function new(x:Float = 0, y:Float = 0, scale:Float = 5, level:String = 'ground', type:String = 'ground', id:Int = -1, actualX:Float = 0,
			actualY:Float = 0) {
		this.id = id;
		this.actualPosition = new FlxPoint(actualX, actualY);
		super(x, y);
		this.scale.set(scale, scale);
		this.loadGraphic('assets/images/tiles/${level}/blocks.png', true, 17, 17);
		animMap.set('ground', 0);
		animMap.set('brick', 1);
		animMap.set('block', 3);
		animMap.set('hardBlock', 7);

		solidMap.set('ground', true);
		solidMap.set('brick', true);
		solidMap.set('block', true);
		solidMap.set('hardBlock', true);

		for (k in animMap.keys()) {
			anims.push(k);
		}

		this.type = type;
		this.isSolid = solidMap.get(type);
		this.animation.add(type, [animMap.get(type)]);
		this.animation.play(type);
	}

	public function changeType(type:String) {
		this.type = type;
		this.isSolid = solidMap.get(type);
		this.animation.add(type, [animMap.get(type)]);
		this.animation.play(type);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		topBottom.top = (this.y - this.height*2);
		topBottom.bottom = (this.y + this.height);

		leftRight.left = (this.x + this.width / 2);
		leftRight.right = (this.x - this.width / 2);

		axis = {
			"topBottom": topBottom,
			"leftRight": leftRight
		};
	}
}
