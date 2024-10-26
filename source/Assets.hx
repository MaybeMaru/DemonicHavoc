package;

import flixel.FlxG;
import flixel.sound.FlxSound;

class Assets
{
	inline static var SOUND_EXT:String = "ogg";

	public static inline function playMusic(name:String, volume:Float = 1.0):Void
	{
		FlxG.sound.playMusic(music(name), volume);
	}

	public static function playSound(name:String, volume:Float = 1.0):FlxSound
	{
		return FlxG.sound.play(sound(name), volume);
	}

	public static inline function sound(name:String):String
	{
		return 'assets/sounds/$name.$SOUND_EXT';
	}

	public static inline function music(name:String):String
	{
		return 'assets/music/$name.$SOUND_EXT';
	}
}
