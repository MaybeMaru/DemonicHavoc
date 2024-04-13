package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.util.FlxStringUtil;
import openfl.Assets;

// lime test html5
class PlayState extends FlxState
{
	var player:Player;
	var map:DemonMap;

	override public function create()
	{
		super.create();

		FlxG.stage.quality = LOW;

		FlxG.sound.playMusic("assets/music/bg.mp3");

		// Make background layers
		for (i in 0...3)
		{
			var spr = new FlxSprite(0, 0, 'assets/images/bg/$i.png');
			spr.screenCenter();
			spr.scrollFactor.set(0.01 + (i * 0.03), 0.01 + (i * 0.03));

			var arr = [
				FlxColor.fromRGB(i * 50, i * 10, 0),
				FlxColor.fromRGB(i * 50, i * 10, 0, 0),
				FlxColor.fromRGB(i * 50, i * 10, 0)
			];

			var gradient = FlxGradient.createGradientFlxSprite(1, FlxG.height, arr, 7 + i);
			gradient.scale.x = FlxG.width * 1.1;
			gradient.screenCenter();
			gradient.blend = ADD;
			gradient.alpha = 0.3;

			gradient.scrollFactor.copyFrom(spr.scrollFactor);
			gradient.scrollFactor.subtract(0.015, 0.015);

			add(spr);
			add(gradient);
		}

		map = new DemonMap();
		add(map);

		player = new Player();
		add(player);

		FlxG.camera.follow(player, PLATFORMER);
		FlxG.camera.bgColor = FlxColor.fromRGB(25, 0, 0);
		FlxG.camera.setScrollBoundsRect(0, 0, map.width, map.height);

		player.x = map.width / 2;
		player.y = map.height / 2;
		FlxG.camera.focusOn(player.getPosition());
		FlxG.camera.zoom = 1.15;

		var hudCam = new FlxCamera();
		hudCam.bgColor.alpha = 0;
		FlxG.cameras.add(hudCam, false);

		FlxG.camera.pixelPerfectRender = true;
		hudCam.pixelPerfectRender = true;

		var timer = new Timer();
		timer.camera = hudCam;
		add(timer);

		var life = new Life();
		life.camera = hudCam;
		add(life);

		var lastDemon:FlxObject = player;
		for (i in 0...10)
		{
			var demon = new Demon(player);
			demon.target = lastDemon;
			add(demon);
			lastDemon = demon;
		}

		var angel = new Angel();
		angel.screenCenter();
		add(angel);
	}

	override public function update(elapsed:Float)
	{
		map.overlapsWithCallback(player, FlxObject.separate);

		super.update(elapsed);
	}
}
