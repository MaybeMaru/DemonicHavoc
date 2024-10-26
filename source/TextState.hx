package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.Assets;

class DemonText extends FlxText
{
	public function new(x:Float, y:Float, text:String)
	{
		super(x, y);
		setFormat(Assets.getFont("assets/data/novem___.ttf").fontName, 24);
		this.text = text;
	}
}

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

		var fuck = new DemonText(20, 20, text);
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
			Assets.playSound("escape");
			FlxG.camera.fade(FlxColor.BLACK, 1, false, () ->
			{
				TitleState.fromGameOver = true;
				FlxG.switchState(new TitleState());
			});
		}
	}
}
