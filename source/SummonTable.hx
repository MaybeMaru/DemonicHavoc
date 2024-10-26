package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class SummonTable extends FlxSpriteGroup
{
	public var table:FlxSprite;

	var book:FlxSprite;
	var bar:FlxBar;

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

		bar = new FlxBar(0, 0, LEFT_TO_RIGHT, 100, 10, this, "ritualValue", 0.0, 2.0, true);
		bar.createColoredEmptyBar(FlxColor.BLACK);
		bar.createColoredFilledBar(FlxColor.RED);
		bar.alpha = 0;
		add(bar);

		bar.offset.set(10, 15);

		book.offset.x -= 31;
		book.offset.y = 0;

		book.origin.y -= 25;
	}

	var ritualValue:Float = 0.0;

	var inRitual:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (inRitual)
		{
			book.offset.y = FlxMath.lerp(book.offset.y, 60, elapsed);
			book.angle = FlxG.random.float(-book.offset.y * 0.05, book.offset.y * 0.05);

			if (!finished)
			{
				ritualValue = Math.min(ritualValue + elapsed, 2);

				if (ritualValue >= 2)
				{
					finishRitual();
				}
			}
		}
		else
		{
			book.angle = 0;
			book.offset.y = FlxMath.lerp(book.offset.y, 0, elapsed * 8);
			if (!finished)
				ritualValue = Math.max(ritualValue - (elapsed * 1.5), 0);
		}

		var gay = book.offset.y / 60;
		bar.offset.y = 15 * gay;
		bar.alpha = gay;
	}

	public var finished:Bool = false;

	public function finishRitual()
	{
		finished = true;
		inRitual = false;
		Assets.playSound("summondemon");
		Assets.playSound("demonSpawn" + FlxG.random.int(1, 3)).pitch = FlxG.random.float(0.9, 1.1); // Give it some variety
		PlayState.instance.player.cancelRitual();
		hide();

		// Spawn demons
		for (i in 0...5)
		{
			new FlxTimer().start(0.0333 * i, (tmr) -> PlayState.instance.spawnDemon(book.x + FlxG.random.int(-10, 10), book.y + FlxG.random.int(-10, 10)));
		}
	}

	public function show()
	{
		book.alpha = 0;
		table.alpha = 0;
		FlxTween.tween(book, {alpha: 1}, 0.3, {
			onUpdate: (e) ->
			{
				table.colorTransform.redOffset = 255 - (book.alpha * 255);
				table.scale.x = 1.5 * book.alpha;
				table.alpha = book.alpha;
			},
			onComplete: (e) ->
			{
				finished = false;
			}
		});

		visible = true;
	}

	public function hide()
	{
		FlxTween.tween(book, {alpha: 0}, 0.3, {
			onUpdate: (e) ->
			{
				table.colorTransform.redOffset = 255 - (book.alpha * 255);
				table.scale.x = 1.5 * book.alpha;
				table.alpha = book.alpha;
			},
			onComplete: (e) ->
			{
				this.visible = false;
				ritualValue = 0;
				table.scale.set(1.5, 1.5);
				table.colorTransform.redOffset = 0;
				table.alpha = 1;
				book.alpha = 1;
			}
		});
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
