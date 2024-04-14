package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

// Im so low on time holy fuck
class GameOverState extends FlxState
{
	override function create()
	{
		super.create();

		var bg = new FlxSprite().loadGraphic("assets/images/gameover.png");
		bg.setGraphicSize(FlxG.width, FlxG.height);
		bg.updateHitbox();
		add(bg);

		var homo = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(homo);

		FlxG.sound.play("assets/sounds/gameover.mp3");
		FlxG.camera.flash(FlxColor.WHITE, 1, () ->
		{
			new FlxTimer().start(1, (tmr) ->
			{
				FlxTween.tween(homo, {alpha: 0});

				new FlxTimer().start(0.3, (tmr) ->
				{
					FlxG.sound.play("assets/sounds/hallelujah.mp3", 1.5);
				});
			});
		});

		new FlxTimer().start(8, (tmr) ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 1, false, () ->
			{
				TitleState.fromGameOver = true;
				FlxG.switchState(new TitleState());
			});
		});
	}
}
