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
import flixel.FlxSprite;

class Mario extends FlxSprite {
    var animMap:Map<String,Array<Int>> = new Map<String,Array<Int>>();
    override public function new(x:Float = 0,y:Float = 0){
        super(x,y);
        loadGraphic("assets/images/mario/small.png",true,17,18);
        animMap.set("idle", [0]);
        animMap.set("walk", [3,2,1,2]);
        animMap.set("jump", [5]);
        animMap.set("fall", [5]);
        animMap.set("skid", [4]);
        animMap.set("die", [6]);
        animMap.set("climb", [8,7]);
        animMap.set("climbIdle", [7]);
        animMap.set("goal", [7]);
        animMap.set("swim",[9,10,11,12,13]);
        animMap.set("all",[for(i in 0...14) i]);

        for(k in animMap.keys()){
            this.animation.add(k, animMap.get(k), 12, true);
        }
        this.animation.play("all");

        this.scale.set(2,2);
    }
}