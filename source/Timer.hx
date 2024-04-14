package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;
import openfl.Assets;

class Timer extends FlxGroup
{
	var timer:FlxText;

	public function new()
	{
		super();

		timer = new FlxText(0, 20, 0, "0:00");
		timer.setFormat(Assets.getFont("assets/data/novem___.ttf").fontName, 24);
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
