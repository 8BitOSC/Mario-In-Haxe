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
import states.PlayState;
import flixel.FlxSprite;
import flixel.util.FlxCollision;
import flixel.math.FlxRect;

class Mario extends FlxSprite {
	var animMap:Map<String, Array<Int>> = new Map<String, Array<Int>>();

	var vel:FlxPoint = new FlxPoint(0, 0);
	var state:String = 'idle';

	var bounds:FlxSprite = null;

	var frameCycle:Float = 0;
	var canJump:Bool = true;

	override public function new(x:Float = 0, y:Float = 0) {
		super(x, y);
		loadGraphic("assets/images/mario/small.png", true, 17, 18);
		animMap.set("idle", [0]);
		animMap.set("walk", [3, 2, 1, 2]);
		animMap.set("jump", [5]);
		animMap.set("skid", [4]);
		animMap.set("die", [6]);
		animMap.set("climb", [8, 7]);
		animMap.set("goal", [7]);
		animMap.set("swim", [9, 10, 11, 12, 13]);
		animMap.set("all", [for (i in 0...14) i]);

		for (k in animMap.keys()) {
			this.animation.add(k, animMap.get(k), 12, true);
		}

		this.scale.set(2, 2);
	}

	override public function update(elapsed:Float) {
		FlxG.watch.addQuick('q', this.y);
		this.animation.play("idle");
		
		this.vel.y -= (15 * elapsed);
		var cap:Int = -30;
		if (this.vel.y <= cap) {
			this.vel.y = cap;
		}
		cap = -3;
		if (this.vel.x <= cap) {
			this.vel.x = cap;
		}
		if (this.vel.x >= Math.abs(cap)) {
			this.vel.x = Math.abs(cap);
		}
		var yBeforeCollision = this.y;
		if(this.vel.y > 1) this.y -= this.vel.y*1.1;
		else this.y -= this.vel.y;
		if (PlayState.tiles.collidesWith(this).collided) {
			
            this.y = yBeforeCollision;
			this.vel.y = 0;
            state = 'idle';
		}
		this.y -= 5;
		this.y += 5;
		if (FlxG.keys.anyPressed([RIGHT, D])) {
			this.flipX = false;
			this.vel.x += 1;
		}
		if (FlxG.keys.anyPressed([LEFT, A])) {
			this.flipX = true;
			this.vel.x -= .64;
		}
		if (FlxG.keys.anyJustPressed([UP, W, SPACE]) && canJump) {
			this.vel.y = 5;
		}
		var xBeforeCollision = this.x;
		this.vel.x *= (elapsed / 0.0185185185);
		this.x += this.vel.x;
		if (PlayState.tiles.collidesWith(this).collided) {
            this.x = xBeforeCollision;
			this.vel.x = 0;
		}
		if (Math.abs(this.vel.x) > 0)
			this.state = 'walk';
		if (Math.abs(this.vel.x) < 0.1)
			this.state = 'idle';
		if (Math.abs(this.vel.y) > 0){
			this.state = 'jump';
			canJump = false;
		} else {
			canJump = true;
		}
		this.animation.play(state);
		if (state == 'walk') {
			frameCycle = (frameCycle+(this.vel.x*0.1)) % 4;
			this.animation.curAnim.curFrame = Math.ceil(Math.abs(frameCycle));
			FlxG.watch.addQuick('frame', this.animation.curAnim.curFrame);
		}
		super.update(elapsed);
	}
}
