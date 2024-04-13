package;

import flixel.FlxG;
import flixel.FlxSprite;

enum abstract AngelType(Int) from Int
{
	var ANGEL = 0;
	var CHERUB = 1;
}

class Angel extends FlxSprite
{
	var type:AngelType;

	public function new(?type:Null<AngelType>)
	{
		super();

		type ??= cast FlxG.random.int(0, 1);

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
	}
}
