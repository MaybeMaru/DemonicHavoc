package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxMath;

enum abstract AngelType(Int) from Int
{
	var ANGEL = 0;
	var CHERUB = 1;
}

class Angel extends FlxSprite
{
	var type:AngelType;
	var player:Player;

	public var target:FlxObject;

	public function new(?type:Null<AngelType>, player:Player)
	{
		super();

		type ??= cast FlxG.random.int(0, 1);
		this.player = player;

		switch (type)
		{
			case ANGEL:
				loadGraphic("assets/images/angel.png", true, 64, 37);
				setFacingFlip(RIGHT, false, false);
				setFacingFlip(LEFT, true, false);
			case CHERUB:
				loadGraphic("assets/images/cherub.png", true, 48, 36);
				setFacingFlip(RIGHT, true, false);
				setFacingFlip(LEFT, false, false);
		}

		scale.set(1.2, 1.2);
		centerOrigin();

		animation.add("idle", [0, 1, 2], 12);
		animation.play("idle");

		facing = RIGHT;

		diff = FlxG.random.float(0, 6.28);
		speed = FlxG.random.float(80, 100);

		if (PlayState.instance.timeElapsed > 50)
		{
			speed += FlxG.random.float(5, 15);
		}

		if (PlayState.instance.timeElapsed > 90)
		{
			speed += FlxG.random.float(5, 15);
		}
	}

	var diff:Float;
	var speed:Float;

	override public function update(elapsed:Float):Void
	{
		velocity.set(0, 0);
		offset.y = FlxMath.fastSin((FlxG.game.ticks / 1000) + diff) * 10;

		var dx:Float = target.x - x;
		var dy:Float = target.y - y;
		var distance:Float = Math.sqrt(dx * dx + dy * dy);

		facing = dx < 0 ? LEFT : RIGHT;

		dx /= distance;
		dy /= distance;

		velocity.set(dx * speed, dy * speed);
		acceleration.set(dx * speed, dy * speed);

		var gay = player.getScreenPosition(null, FlxG.camera);
		gay.add(12, 12);
		if (this.getBoundingBox(FlxG.camera).containsPoint(gay))
		{
			player.getHit();
		}

		super.update(elapsed);
	}
}
