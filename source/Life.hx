package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxRect;
import flixel.text.FlxText;

class Life extends FlxSpriteGroup
{
	var top:FlxSprite;
	var bottom:FlxSprite;
	var text:FlxText;

	public function new()
	{
		super();

		bottom = new FlxSprite().loadGraphic("assets/images/heartBottom.png");
		add(bottom);

		top = new FlxSprite().loadGraphic("assets/images/heartTop.png");
		add(top);

		scale.set(2, 2);
		updateHitbox();

		setPercent(1);
	}

	function setPercent(percent:Float)
	{
		var h = top.height * percent;
		top.clipRect = FlxRect.weak(0, top.height - h, top.width, h);
	}
}
