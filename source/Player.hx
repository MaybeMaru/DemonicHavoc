package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import flixel.util.FlxColor;

class Player extends FlxSprite
{
	var jumpForce = 500;
	var moveSpeed = 300;

	var star:FlxSprite;

	public function new()
	{
		super();

		star = new FlxSprite().loadGraphic("assets/images/star.png");

		loadGraphic("assets/images/mike.png", true, 46, 45);
		scale.set(1.3, 1.3);

		origin.x = 50;
		setSize(25, 50);

		animation.add("idle", [0, 1, 2], 12);
		animation.add("run", [3, 4, 5, 4], 12);
		animation.add("summon", [6, 7, 8], 12);
		animation.add("jump", [9, 10], 12);
		animation.add("fall", [11, 12], 12);

		acceleration.y = 1000;
		maxVelocity.y = 500;
		maxVelocity.x = moveSpeed;

		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, true, false);
		facing = RIGHT;
	}

	var doubleJump = false;
	var inFloor = false;
	var moving = false;

	var lastY:Float = -1;

	override function drawComplex(cam)
	{
		if (star.alpha > 0)
		{
			var elp = FlxG.elapsed;
			star.alpha -= elp;
			star.angle += elp * 120;
			star.scale.add(elp * 0.5, elp * 0.5);
			star.color = FlxColor.interpolate(FlxColor.RED, FlxColor.WHITE, FlxMath.remapToRange(star.alpha, 0, 0.6, 0, 1));
			star.drawComplex(cam);
		}

		super.drawComplex(cam);
	}

	var ritualTable:SummonTable = null;

	function stopMovement()
	{
		velocity.x = 0;
		moving = false;
	}

	override function update(elapsed:Float)
	{
		// Ritual table
		if (ritualTable != null)
		{
			if (FlxG.keys.pressed.Z)
			{
				animation.play("summon");
				x = FlxMath.lerp(x, ritualTable.table.x + 25, elapsed * 4);
				stopMovement();

				super.update(elapsed);
				return;
			}

			ritualTable.cancelRitual();
			ritualTable = null;
		}

		// Movement
		if (FlxG.keys.pressed.LEFT)
		{
			velocity.x -= moveSpeed * elapsed * 20;
			facing = LEFT;
			moving = true;
		}
		else if (FlxG.keys.pressed.RIGHT)
		{
			velocity.x += moveSpeed * elapsed * 20;
			facing = RIGHT;
			moving = true;
		}
		else
		{
			stopMovement();
		}

		// Just hit floor crap
		var floor = isTouching(FLOOR);
		if (floor && !inFloor)
		{
			FlxG.sound.play("assets/sounds/hitfloor.mp3");
		}
		inFloor = floor;

		// Jump
		if (inFloor)
		{
			animation.play(moving ? "run" : "idle");

			if (FlxG.keys.justPressed.X)
			{
				velocity.y = -jumpForce;
				doubleJump = false;
				inFloor = false;

				FlxG.sound.play("assets/sounds/jump.mp3");
				animation.play("jump");
			}
		}
		else
		{
			if (!doubleJump)
			{
				// Double jump
				if (FlxG.keys.justPressed.X)
				{
					velocity.y = -jumpForce * 0.75;
					FlxG.sound.play("assets/sounds/doublejump.mp3");
					animation.play("jump");
					doubleJump = true;

					star.setPosition(x - 20, y - 25);
					star.scale.set(1, 1);
					star.alpha = 0.6;
				}
			}
		}

		if (FlxG.keys.justPressed.Z)
		{
			var gay = getScreenPosition(null, camera);
			gay.add(12, 12);

			for (table in PlayState.instance.map.tables)
			{
				// Nasty ass code but im tired
				if (table.table.getBoundingBox(camera).containsPoint(gay))
				{
					ritualTable = table;
					table.startRitual();
					break;
				}
			}

			gay.put();
		}

		super.update(elapsed);

		if (y > lastY && !inFloor)
			animation.play("fall");

		lastY = y;
	}

	public var canGetHit:Bool = true;

	public var mikeHealth:Int = 100;

	public function getHit()
	{
		if (!canGetHit)
			return;

		mikeHealth -= 25;
		PlayState.instance.life.setPercent(mikeHealth / 100);

		if (mikeHealth <= 0)
		{
			FlxG.sound.music.stop();
			FlxG.switchState(new GameOverState());
			return;
		}

		canGetHit = false;
		FlxG.camera.shake(0.025, 0.1);
		FlxG.sound.play("assets/sounds/hurt.mp3");
		FlxFlicker.flicker(this, 1.5, 0.1, true, true, (flk) -> canGetHit = true);
	}
}
