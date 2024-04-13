package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;

class PlayState extends FlxState
{
	var player:Player;
	var map:DemonMap;

	var timer:FlxText;

	override public function create()
	{
		super.create();

		map = new DemonMap();
		add(map);

		player = new Player();
		add(player);

		FlxG.camera.follow(player, PLATFORMER);
		FlxG.camera.bgColor = FlxColor.fromRGB(100, 0, 0);
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

		timer = new FlxText(0, 20, 0, "0:00", 16);
		timer.screenCenter(X);
		timer.scrollFactor.set();
		timer.camera = hudCam;
		add(timer);

		var lastDemon:FlxObject = player;
		for (i in 0...10)
		{
			var demon = new Demon(player);
			demon.target = lastDemon;
			add(demon);
			lastDemon = demon;
		}

		// add(new Demon(player));
	}

	override public function update(elapsed:Float)
	{
		map.overlapsWithCallback(player, FlxObject.separate);

		timer.text = FlxStringUtil.formatTime(FlxG.game.ticks / 1000);
		timer.screenCenter(X);

		super.update(elapsed);
	}
}
