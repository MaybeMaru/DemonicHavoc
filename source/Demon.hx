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

	public function new(player:Player)
	{
		super();

		//		loadGraphic("assets/images/demon.png");

		loadGraphic("assets/images/demon.png", true, 20, 25);
		/*animation.add("idle", [0, 1, 2], 12);
			animation.play("idle");

			for (frame in frames.frames)
			{
				if (frame == null)
				{
					frames.frames.remove(frame);
				}
				// frame.duration = (1 / 12);
		}*/

		this.player = player;

		diff = FlxG.random.float(0, 6.28);
		speed = FlxG.random.int(275, 325);
		bound = FlxG.random.int(30, 50);
		// animation.curAnim.curFrame += Std.int(diff / 2);

		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, true, false);
		facing = RIGHT;

		var tint = new Tint();
		tint.setTint([0, 0.25, 0.5, 0.75][FlxG.random.int(0, 3)]);
		shader = tint.shader;
	}

	var diff:Float;
	var speed:Int;
	var bound:Int;

	override public function update(elapsed:Float):Void
	{
		velocity.set(0, 0);
		offset.y = FlxMath.fastSin((FlxG.game.ticks / 1000) + diff) * 10;

		var dx:Float = target.x - x;
		var dy:Float = target.y - y;
		var distance:Float = Math.sqrt(dx * dx + dy * dy);

		facing = dx < 0 ? LEFT : RIGHT;

		if (Math.abs(distance) <= bound)
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
