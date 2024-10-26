package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import openfl.Assets;

// Im so low on time holy fuck
class GameOverState extends FlxState
{
	public static var lastTime:Float = 0;

	override function create()
	{
		super.create();
		FlxG.mouse.visible = false;

		var bg = new FlxSprite().loadGraphic("assets/images/gameover.png");
		bg.setGraphicSize(FlxG.width, FlxG.height);
		bg.updateHitbox();
		add(bg);

		var homo = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(homo);

		var timer = new FlxText();
		timer.setFormat(Assets.getFont("assets/data/novem___.ttf").fontName, 24, FlxColor.YELLOW);
		timer.setBorderStyle(OUTLINE, FlxColor.ORANGE, 2);
		timer.text = 'Time Survived:\n' + FlxStringUtil.formatTime(lastTime);
		add(timer);

		timer.updateHitbox();
		timer.setPosition(FlxG.width - timer.width - 25, FlxG.height - timer.height - 25);

		timer.visible = false;

		new FlxTimer().start(8, (tmr) ->
		{
			timer.visible = true;
			Assets.playSound("select");
		});

		Assets.playSound("gameover");
		FlxG.camera.flash(FlxColor.WHITE, 1, () ->
		{
			new FlxTimer().start(1, (tmr) ->
			{
				FlxTween.tween(homo, {alpha: 0});

				new FlxTimer().start(0.3, (tmr) ->
				{
					Assets.playSound("hallelujah", 1.5);
				});
			});
		});

		new FlxTimer().start(10.5, (tmr) ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 1, false, () ->
			{
				TitleState.fromGameOver = true;
				FlxG.switchState(new TitleState());
			});
		});
	}
}
