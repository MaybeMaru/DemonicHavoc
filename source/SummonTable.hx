package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;

class SummonTable extends FlxSpriteGroup
{
	public var table:FlxSprite;

	var book:FlxSprite;

	public function new()
	{
		super();

		table = new FlxSprite().loadGraphic("assets/images/table/table.png", true, 54, 39);
		table.animation.add("off", [0], 12);
		table.animation.add("turn", [1, 2, 3], 12, false);
		table.animation.add("on", [2, 3], 12);
		add(table);

		book = new FlxSprite().loadGraphic("assets/images/table/book.png");
		add(book);

		cancelRitual();

		for (i in this)
		{
			i.scale.set(1.5, 1.5);
			i.updateHitbox();
		}

		book.offset.x -= 31;
		book.offset.y = 0;

		book.origin.y -= 25;
	}

	var inRitual:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (inRitual)
		{
			book.offset.y = FlxMath.lerp(book.offset.y, 60, elapsed);
			book.angle = FlxG.random.float(-book.offset.y * 0.05, book.offset.y * 0.05);
		}
		else
		{
			book.angle = 0;
			book.offset.y = FlxMath.lerp(book.offset.y, 0, elapsed * 8);
		}
	}

	public function startRitual()
	{
		inRitual = true;
		table.animation.play("turn");
		table.animation.finishCallback = (a) ->
		{
			table.animation.play("on");
			table.animation.finishCallback = null;
		}
		PlayState.instance.inRitual = true;
	}

	public function cancelRitual()
	{
		inRitual = false;
		table.animation.play("turn", false, true, 2);
		table.animation.finishCallback = (a) ->
		{
			table.animation.play("off");
			table.animation.finishCallback = null;
		}
		PlayState.instance.inRitual = false;
	}
}
