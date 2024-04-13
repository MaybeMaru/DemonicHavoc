package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import openfl.Assets;
import openfl.display.BitmapData;

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
		add(tilemap);

		for (i in tableIndex)
		{
			var point = tilemap.getTileCoordsByIndex(i);
			var table = new SummonTable();
			table.setPosition(point.x - table.width / 2, point.y - table.height / 2);
			tables.push(table);
			add(table);
		}
	}
}
