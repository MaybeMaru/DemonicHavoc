package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;

enum abstract AngelType(Int) from Int
{
	var ANGEL = 0;
	var CHERUB = 1;
}

class Angel extends FlxSprite
{
	var type:AngelType;
	var player:Player;

	// All demons currently kicking ass
	public var demons:Array<Demon> = [];

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

	var healthPoints:Int = 7;

	public function getBite(demon:Demon)
	{
		healthPoints--;
		demon.bitesLeft--;

		demon.animation.play("bite", true);
		demon.animation.finishCallback = (n) ->
		{
			demon.animation.finishCallback = null;
			if (demon.bitesLeft <= 0)
			{
				// demon.destroy();
				demons.remove(demon);
				PlayState.instance.demonsArray.remove(demon);
				PlayState.instance.resetDemonTargets();

				demon.x += FlxG.random.int(-5, 5);
				demon.y += FlxG.random.int(-5, 5);
				Assets.playSound("demondie" + FlxG.random.int(1, 3)).pitch = FlxG.random.float(0.9, 1.1);

				demon.target = null;
				demon.animation.play("die");
				demon.velocity.set(20 * (FlxG.random.bool() ? -1 : 1), -100);
				demon.acceleration.y = 600;

				new FlxTimer().start(5, (tmr) ->
				{
					demon.kill();
				});
			}
		}

		Assets.playSound("bite");

		if (healthPoints <= 0)
		{
			destroy();
			PlayState.instance.angelsGroup.remove(this, true);
			Assets.playSound("angeldie");

			for (demon in demons)
			{
				demon.targetAngel = false;
				demon.animation.play("idle");
			}

			PlayState.instance.resetDemonTargets();
		}
	}

	var blehTimer:Float = 0.5;
	var nextBite:Float = 0.5;

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

		if (demons.length > 0)
		{
			var biteQueue:Array<Demon> = [];
			var hasDemonClose:Bool = false;
			for (demon in demons)
			{
				if (quickDist(demon) <= 25)
				{
					hasDemonClose = true;
					biteQueue.push(demon);
				}
			}

			if (hasDemonClose)
			{
				blehTimer += elapsed;
				if (blehTimer >= nextBite)
				{
					blehTimer = 0;
					nextBite = FlxG.random.float(0.4, 0.6);
					for (demon in biteQueue)
					{
						if (healthPoints <= 0)
							break;

						getBite(demon);
					}
				}
			}
		}
	}

	function quickDist(demon:Demon)
	{
		var dx:Float = demon.x - x;
		var dy:Float = demon.y - y;
		return Math.abs(Math.sqrt(dx * dx + dy * dy));
	}
}
