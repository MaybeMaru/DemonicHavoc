package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

class Player extends FlxSprite
{
	var jumpForce = 500;
	var moveSpeed = 300;

	public function new()
	{
		super();

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

		// FlxG.debugger.drawDebug = true;

		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, true, false);
		facing = RIGHT;
	}

	var doubleJump = false;
	var inFloor = false;
	var moving = false;

	var lastY:Float = -1;

	override function update(elapsed:Float)
	{
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
			velocity.x = 0;
			moving = false;
		}

		inFloor = isTouching(FLOOR);

		// Jump
		if (inFloor)
		{
			animation.play(moving ? "run" : "idle");

			if (FlxG.keys.justPressed.X)
			{
				velocity.y = -jumpForce;
				doubleJump = false;
				inFloor = false;

				animation.play("jump");
			}
		}
		else
		{
			if (!doubleJump)
			{
				if (FlxG.keys.justPressed.X)
				{
					velocity.y = -jumpForce * 0.75;
					animation.play("jump");
					doubleJump = true;
				}
			}
		}

		super.update(elapsed);

		if (y > lastY && !inFloor)
			animation.play("fall");

		lastY = y;
	}
}
