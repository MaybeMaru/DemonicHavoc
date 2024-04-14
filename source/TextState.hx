package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.Assets;

class TextState extends FlxState
{
	var text:String;

	public function new(text:String)
	{
		super();
		this.text = text;
	}

	override function create()
	{
		super.create();

		var bg = new FlxSprite().loadGraphic("assets/images/titlebg.png");
		bg.scrollFactor.set();
		bg.setGraphicSize(FlxG.width, FlxG.height);
		bg.updateHitbox();
		bg.scale.add(0.2, 0.2);
		add(bg);

		bg.color = FlxColor.GRAY;

		var fuck = new FlxText(20, 20);
		fuck.setFormat(Assets.getFont("assets/data/novem___.ttf").fontName, 24);
		fuck.text = text;
		// fuck.screenCenter();
		add(fuck);

		fuck.color = 0xffff0000;
	}

	var back = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (back)
			return;

		if (FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.ESCAPE)
		{
			back = true;
			FlxG.sound.play("assets/sounds/escape.mp3");
			FlxG.camera.fade(FlxColor.BLACK, 1, false, () ->
			{
				TitleState.fromGameOver = true;
				FlxG.switchState(new TitleState());
			});
		}
	}
}
