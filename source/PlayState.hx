package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.util.FlxStringUtil;
import openfl.Assets;

// lime test html5
class PlayState extends FlxState
{
	public static var instance:PlayState;

	public var player:Player;
	public var map:DemonMap;
	public var life:Life;

	public var angelsGroup:FlxTypedGroup<Angel>;
	public var demonsGroup:FlxTypedGroup<Demon>;

	override public function create()
	{
		super.create();
		PlayState.instance = this;

		FlxG.stage.quality = LOW;

		FlxG.sound.playMusic("assets/music/bg.mp3", 0.8);

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

		FlxG.debugger.drawDebug = true;

		player = new Player();
		map = new DemonMap(player);
		angelsGroup = new FlxTypedGroup<Angel>();
		demonsGroup = new FlxTypedGroup<Demon>();

		add(map);
		add(angelsGroup);
		add(demonsGroup);
		add(player);

		FlxG.camera.follow(player, PLATFORMER);
		FlxG.camera.bgColor = FlxColor.fromRGB(25, 0, 0);
		FlxG.camera.setScrollBoundsRect(0, 0, map.tilemap.width, map.tilemap.height);

		player.x = map.tilemap.width / 2;
		player.y = map.tilemap.height / 2;
		FlxG.camera.snapToTarget();
		FlxG.camera.zoom = 1.15;

		var hudCam = new FlxCamera();
		hudCam.bgColor.alpha = 0;
		FlxG.cameras.add(hudCam, false);

		FlxG.camera.pixelPerfectRender = true;
		hudCam.pixelPerfectRender = true;

		var timer = new Timer();
		timer.camera = hudCam;
		add(timer);

		life = new Life();
		life.camera = hudCam;
		add(life);

		/*var lastDemon:FlxObject = player;
			for (i in 0...10)
			{
				var demon = new Demon(player);
				demon.target = lastDemon;
				add(demon);
				lastDemon = demon;
		}*/
	}

	public var inRitual:Bool = false;

	var bleh:Float = 0;

	public var timeElapsed:Float = 0;

	var spawnInterval:Float = 10.0; // Initial spawn interval in seconds
	var lastSpawnTime:Float = 0.0;

	override public function update(elapsed:Float)
	{
		map.tilemap.overlapsWithCallback(player, FlxObject.separate);

		bleh = FlxMath.lerp(bleh, (inRitual ? -100 : 0), elapsed * (inRitual ? 1.5 : 5));
		FlxG.camera.targetOffset.y = bleh;

		super.update(elapsed);

		// Higher difficulty over time
		timeElapsed += elapsed;

		// Check if its time to spawn angels
		updateSpawn();
	}

	function updateSpawn()
	{
		if (timeElapsed - lastSpawnTime >= spawnInterval)
		{
			var twoPackChance = (timeElapsed > 30 ? (timeElapsed > 50 ? 25 : 15) : 0);
			var threePackChance = (timeElapsed > 50 ? (timeElapsed > 70 ? 20 : 10) : 0);

			if (threePackChance > 0 && FlxG.random.bool(threePackChance))
			{
				for (i in 0...3)
					spawnAngel();
			}
			else if (twoPackChance > 0 && FlxG.random.bool(twoPackChance))
			{
				for (i in 0...2)
					spawnAngel();
			}
			else
			{
				spawnAngel();
			}

			lastSpawnTime = timeElapsed;

			// Super bullshit hardcoded rising difficulty go!
			spawnInterval -= timeElapsed > 30 ? (timeElapsed > 50 ? (timeElapsed > 70 ? 0.75 : 0.5) : 0.25) : 0.15;
			spawnInterval = Math.max(spawnInterval, 2.0);
		}
	}

	function spawnAngel()
	{
		var angel = new Angel(player);
		angel.target = player;
		angel.x = FlxG.random.bool() ? -200 : map.tilemap.width + 200;
		angel.y = FlxG.random.float(-200, map.tilemap.height + 200);
		angelsGroup.add(angel);
	}

	public var demonsArray:Array<Demon> = [];

	public function spawnDemon(x:Float, y:Float)
	{
		var demon = new Demon(player);
		demon.setPosition(x, y);

		var i:Int = demonsArray.length - 1;
		while (i > -1)
		{
			if (demonsArray[i] != null)
			{
				demon.target = demonsArray[i];
				break;
			}

			i--;
		}

		if (demon.target == null)
			demon.target = player;

		demonsArray.push(demon);
		demon.ID = demonsArray.length - 1;

		demonsGroup.add(demon);
	}

	public function resetDemonTargets()
	{
		for (i in 0...demonsArray.length)
		{
			demonsArray[i].target = demonsArray[i - 1] ?? player;
		}
	}
}
