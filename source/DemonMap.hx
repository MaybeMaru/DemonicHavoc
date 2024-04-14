package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import openfl.Assets;

using StringTools;

class DemonMap extends FlxGroup
{
	public var tilemap:FlxTilemap;
	public var tables:Array<SummonTable> = [];

	public function new(player:Player)
	{
		super();

		var map = Assets.getText("assets/data/map.txt");

		var i:Int = 0;
		var tableIndex:Array<Int> = [];

		var csv:String = "";
		for (_ in map)
		{
			switch (_)
			{
				case 13:
					csv += "\n";
				case 44:
					csv += ",";
				case 9647:
					csv += "0";
					i++;
				case 9646:
					csv += "1";
					i++;
				case 9635: // Ritual table
					csv += "0";
					tableIndex.push(i);
					i++;
			}
		}

		tilemap = new FlxTilemap();
		tilemap.loadMapFromCSV(csv, "assets/images/tile.png", 50, 50, OFF, 0, 1, 1);
		tilemap.visible = false;
		add(tilemap);

		add(new FlxSprite().loadGraphic("assets/images/tiles/map.png"));

		var a = new FlxSprite(tilemap.width / 2).loadGraphic("assets/images/tiles/map.png");
		a.flipX = true;
		add(a);

		// Three
		for (i in [[3, 11], [23, 11]])
			add(new FlxSprite(i[0] * 50, i[1] * 50).loadGraphic("assets/images/tiles/threePlatform.png"));

		// Four
		for (i in [[9, 11], [16, 11], [6, 6], [19, 6]])
			add(new FlxSprite(i[0] * 50, i[1] * 50).loadGraphic("assets/images/tiles/fourPlatform.png"));

		// Five
		add(new FlxSprite(12 * 50, 8 * 50).loadGraphic("assets/images/tiles/fivePlatform.png"));

		// Six
		for (i in [[4, 14], [19, 14]])
			add(new FlxSprite(i[0] * 50, i[1] * 50).loadGraphic("assets/images/tiles/sixPlatform.png"));

		for (i in tableIndex)
		{
			var point = tilemap.getTileCoordsByIndex(i);
			var table = new SummonTable();
			table.setPosition(point.x - table.width / 2, point.y - table.height / 2);
			tables.push(table);
			add(table);
		}
	}

	public function getRandomOffTable():SummonTable
	{
		var posibleTables:Array<SummonTable> = [];
		for (i in tables)
		{
			if (i.finished)
			{
				posibleTables.push(i);
			}
		}

		return posibleTables[FlxG.random.int(0, posibleTables.length - 1)];
	}
}
