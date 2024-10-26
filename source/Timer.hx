package;

import TextState.DemonText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;
import openfl.Assets;

class Timer extends FlxGroup
{
	public var timer:FlxText;

	public function new()
	{
		super();

		timer = new DemonText(0, 20, "0:00");
		timer.screenCenter(X);

		var bg = new FlxSprite(timer.x - 5, timer.y - 5).makeGraphic(cast timer.width + 10, cast timer.height + 10, FlxColor.BLACK);
		bg.alpha = 0.6;

		add(bg);
		add(timer);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		timer.text = FlxStringUtil.formatTime(PlayState.instance.timeElapsed);
		timer.screenCenter(X);
	}
}
