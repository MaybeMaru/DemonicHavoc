package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class Demon extends FlxSprite
{
	public var player:Player;
	public var target:FlxObject;

	public var bitesLeft:Int;
	public var targetAngel:Bool;

	public function new()
	{
		super();

		loadGraphic("assets/images/demon.png", true, 20, 25);
		animation.add("idle", [0, 1, 2], 12);
		animation.add("bite", [3, 4], 12, false);
		animation.add("die", [5, 6], 12);

		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, true, false);
		facing = RIGHT;

		tint = new Tint();
		shader = tint.shader;
	}

	var tint:Tint;

	public function init(player:Player):Void
	{
		diff = FlxG.random.float(0, 6.28);
		speed = FlxG.random.int(275, 325);
		bound = FlxG.random.int(30, 50);

		bitesLeft = 2;
		targetAngel = false;

		tint.setTint([0, 0.25, 0.5, 0.75][FlxG.random.int(0, 3)]);
		animation.play("idle");
		this.player = player;
	}

	var diff:Float;
	var speed:Int;
	var bound:Int;

	override public function update(elapsed:Float):Void
	{
		offset.y = FlxMath.fastSin((FlxG.game.ticks / 1000) + diff) * 10;

		if (target == null)
		{
			super.update(elapsed);
			return;
		}

		velocity.set(0, 0);

		var dx:Float = target.x - x;
		var dy:Float = target.y - y;
		var distance:Float = Math.sqrt(dx * dx + dy * dy);

		facing = dx < 0 ? LEFT : RIGHT;

		if (Math.abs(distance) <= (targetAngel ? 5 : bound))
		{
			super.update(elapsed);
			return;
		}

		dx /= distance;
		dy /= distance;

		velocity.set(dx * speed, dy * speed);
		acceleration.set(dx * speed, dy * speed);

		super.update(elapsed);
	}
}
