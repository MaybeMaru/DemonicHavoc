package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.Assets;

class TitleState extends FlxState
{
	var esComoFuck:Array<FlxText> = [];

	override function create()
	{
		super.create();

		var logo = new FlxSprite(0, 0, "assets/images/logo.png");
		logo.scale.set(1.5, 1.5);
		logo.updateHitbox();
		logo.screenCenter();
		logo.y -= 75;
		add(logo);

		var index:Int = 0;
		for (i in ["START", "CONTROLS", "CREDITS"])
		{
			var fuck = new FlxText(0, 300 + 50 * index, 0, i);
			fuck.setFormat(Assets.getFont("assets/data/novem___.ttf").fontName, 24);
			fuck.screenCenter(X);
			fuck.ID = index;
			esComoFuck.push(fuck);
			index++;

			var gay = new FlxSprite(fuck.x - 5, fuck.y - 5).makeGraphic(cast fuck.width + 10, cast fuck.height + 10, FlxColor.BLACK);
			add(gay);
			add(fuck);
		}

		changeItem(0);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.UP)
			changeItem(-1);

		if (FlxG.keys.justPressed.DOWN)
			changeItem(1);
	}

	var homo:Int = 0;

	function changeItem(change:Int)
	{
		homo = FlxMath.wrap(homo + change, 0, esComoFuck.length - 1);
		for (i in esComoFuck)
		{
			if (i.ID == homo)
				i.color = 0xff9c4e19;
			else
				i.color = 0xff3a1a1a;
		}
	}
}
