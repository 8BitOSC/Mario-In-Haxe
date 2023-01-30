package sprites;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

class Tile extends FlxSprite {
	var animMap:Map<String, Int> = new Map<String, Int>();
	var solidMap:Map<String, Bool> = new Map<String, Bool>();

	public var id:Int = -1;
	public var actualPosition:FlxPoint = null;
	public var anims:Array<String> = [];
	public var type:String = 'ground';
	public var isSolid:Bool = true;
	override public function new(x:Float = 0, y:Float = 0, scale:Float = 5, level:String = 'ground', type:String = 'ground',id:Int = -1,actualX:Float = 0,actualY:Float = 0) {
		this.id = id;
		this.actualPosition = new FlxPoint(actualX,actualY);
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

		for(k in animMap.keys()) {
			anims.push(k);
		}

		this.type = type;
		this.isSolid = solidMap.get(type);
		this.animation.add(type, [animMap.get(type)]);
		this.animation.play(type);
	}

	public function changeType(type:String){
		this.type = type;
		this.isSolid = solidMap.get(type);
		this.animation.add(type, [animMap.get(type)]);
		this.animation.play(type);
	}
}
