package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.util.FlxTimer;
import openfl.Assets;

class TitleState extends FlxState
{
	var esComoFuck:Array<FlxText> = [];

	public static var fromGameOver:Bool = false;

	var stop:Bool = false;
	var logo:FlxSprite;
	var trans:FlxSprite;

	override function create()
	{
		super.create();

		FlxG.mouse.visible = false;
		FlxG.camera.pixelPerfectRender = true;

		var bg = new FlxSprite().loadGraphic("assets/images/titlebg.png");
		bg.scrollFactor.set();
		bg.setGraphicSize(FlxG.width, FlxG.height);
		bg.updateHitbox();
		add(bg);

		logo = new FlxSprite(0, 0, "assets/images/logo.png");
		logo.scale.set(1.5, 1.5);
		logo.updateHitbox();
		logo.screenCenter();
		logo.y -= 60;
		add(logo);

		logo.scrollFactor.set(0, 0.9);

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

			fuck.scrollFactor.set(0, 0.8);
			gay.scrollFactor.set(0, 0.8);
		}

		if (fromGameOver)
		{
			stop = true;
			fromGameOver = false;
			FlxG.camera.flash(FlxColor.BLACK, 1, () -> stop = false);
		}

		trans = FlxGradient.createGradientFlxSprite(1, FlxG.height * 2, [FlxColor.TRANSPARENT, FlxColor.BLACK, FlxColor.BLACK, FlxColor.BLACK], 10);
		trans.scale.x = FlxG.width;
		trans.updateHitbox();
		trans.y = FlxG.height;
		add(trans);

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
			stop = true;
			FlxG.sound.play("assets/sounds/select.mp3");
			FlxTween.tween(FlxG.camera.scroll, {y: FlxG.height * 2}, 1, {
				onComplete: (twn) ->
				{
					new FlxTimer().start(0.3, (tmr) ->
					{
						FlxG.signals.preStateCreate.addOnce((state) -> FlxG.camera.flash(FlxColor.BLACK, 1));
						switch (homo)
						{
							case 0:
								FlxG.switchState(new PlayState());
							case 1:
								FlxG.switchState(new TextState('
								CONTROLS

								Movement: Arrow keys
								Jump / Double Jump: X
								Summon: Z
								'));

							case 2:
								FlxG.switchState(new TextState('
								CREDITS

								Creator: MaybeMaru
								Engine: Haxeflixel
								Sounds: jsfxr
								Music: TOTTFIY (Brutal 8-bit Remix) 
								'));

						}
					});
				},
				ease: FlxEase.quadInOut
			});
		}
	}

	var homo:Int = 0;

	function changeItem(change:Int)
	{
		if (change != 0)
			FlxG.sound.play("assets/sounds/menuclick.mp3");

		homo = FlxMath.wrap(homo + change, 0, esComoFuck.length - 1);
		for (i in esComoFuck)
		{
			if (i.ID == homo)
				i.color = 0xffffffff;
			else
				i.color = 0xffff0000;
		}
	}
}
