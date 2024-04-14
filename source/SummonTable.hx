package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

class SummonTable extends FlxSpriteGroup
{
	public var table:FlxSprite;

	public function new()
	{
		super();

		table = new FlxSprite().loadGraphic("assets/images/table/table.png", true, 54, 39);
		table.animation.add("off", [0], 12);
		table.animation.add("turn", [1, 2, 3], 12, false);
		table.animation.add("on", [2, 3], 12);
		add(table);

		cancelRitual();

		for (i in this)
		{
			i.scale.set(1.5, 1.5);
			i.updateHitbox();
		}
	}

	public function startRitual()
	{
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
		table.animation.play("off");
		PlayState.instance.inRitual = false;
	}
}
