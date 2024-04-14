package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import openfl.Assets;

class TitleState extends FlxState
{
	var esComoFuck:Array<FlxText> = [];

	public static var fromGameOver:Bool = false;

	var stop:Bool = false;
	var logo:FlxSprite;

	override function create()
	{
		super.create();

		FlxG.mouse.visible = false;

		var red = [FlxColor.fromRGB(255, 0, 0, 0), FlxColor.RED];
		var orange = [FlxColor.fromRGB(255, 165, 0, 0), FlxColor.fromRGB(255, 165, 0)];

		var gradientOne = FlxGradient.createGradientFlxSprite(1, Std.int(FlxG.height * 1.2), red, 10);
		gradientOne.scale.x = FlxG.width;
		gradientOne.updateHitbox();
		add(gradientOne);

		var gradientTwo = FlxGradient.createGradientFlxSprite(1, Std.int(FlxG.height * 0.6), orange, 10);
		gradientTwo.scale.x = FlxG.width;
		gradientTwo.updateHitbox();
		gradientTwo.blend = ADD;
		add(gradientTwo);

		gradientOne.y = FlxG.height - gradientOne.height + 100;
		gradientTwo.y = FlxG.height - gradientTwo.height + 75;

		gradientOne.alpha = 0.6;
		gradientTwo.alpha = 0.4;

		logo = new FlxSprite(0, 0, "assets/images/logo.png");
		logo.scale.set(1.5, 1.5);
		logo.updateHitbox();
		logo.screenCenter();
		logo.y -= 60;
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
			gay.alpha = 0.6;
			add(gay);
			add(fuck);
		}

		if (fromGameOver)
		{
			stop = true;
			fromGameOver = false;
			FlxG.camera.flash(FlxColor.BLACK, 1, () -> stop = false);
			// FlxG.camera.fade(FlxColor.BLACK, 1, true, () -> stop = false);
		}

		changeItem(0);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		logo.offset.y = FlxMath.fastSin((FlxG.game.ticks / 1000) * 2) * 10;

		if (stop)
			return;

		if (FlxG.keys.justPressed.UP)
			changeItem(-1);

		if (FlxG.keys.justPressed.DOWN)
			changeItem(1);

		if (FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.ENTER)
		{
			switch (homo)
			{
				case 0:
					FlxG.switchState(new PlayState());
				case 1:
				case 2:
			}
		}
	}

	var homo:Int = 0;

	function changeItem(change:Int)
	{
		homo = FlxMath.wrap(homo + change, 0, esComoFuck.length - 1);
		for (i in esComoFuck)
		{
			if (i.ID == homo)
				i.color = 0xffffffff;
			else
				i.color = 0xff000000;
		}
	}
}
