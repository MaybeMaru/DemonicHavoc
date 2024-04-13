package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import openfl.Assets;
import openfl.display.BitmapData;

using StringTools;

class DemonMap extends FlxTilemap
{
	public function new()
	{
		super();

		var map = Assets.getText("assets/data/map.txt");

		var csv:String = "";
		for (i in map)
		{
			switch (i)
			{
				case 13:
					csv += "\n";
				case 44:
					csv += ",";
				case 9647:
					csv += "0";
				case 9646:
					csv += "1";
			}
		}

		loadMapFromCSV(csv, "assets/images/tile.png", 50, 50, OFF, 0, 1, 1);
	}
}
