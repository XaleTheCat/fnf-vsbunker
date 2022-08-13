package grafex.sprites;

import grafex.systems.Paths;
import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	public var isPlayer:Bool = false;
	private var char:String = '';

	public var auto:Bool = true;

    // Oh yea, crafter things

	public static var redirects:Map<String, String> = null;
	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		this.isPlayer = isPlayer;
		changeIcon(char);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);

	}

	private var iconOffsets:Array<Float> = [0, 0];
	public function changeIcon(char:String)
	{
		if(this.char != char)
		{
        	switch(char) 
			{     
        		default:
					var name:String = 'icons/' + char;
					if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + char; //Older versions of psych engine's support
					if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-noone'; //Prevents crash from missing icon
					var file:Dynamic = Paths.image(name);
			
					loadGraphic(file); //Load stupidly first for getting the file size
					var widths = width;
					if (width == 450) {
						loadGraphic(file, true, Math.floor(width / 3), Math.floor(height)); // 
						iconOffsets[0] = (width - 150) / 3;
						iconOffsets[1] = (width - 150) / 3;
						iconOffsets[2] = (width - 150) / 3;
					} else {
						loadGraphic(file, true, Math.floor(width / 2), Math.floor(height)); 
						iconOffsets[0] = (width - 150) / 2;
						iconOffsets[1] = (width - 150) / 2;
					}
				
					updateHitbox();
					if (widths == 450) {
						animation.add(char, [0, 1, 2], 0, false, isPlayer);
					} else {
						animation.add(char, [0, 1], 0, false, isPlayer);
					}
					animation.play(char);
					this.char = char;
				
					antialiasing = ClientPrefs.globalAntialiasing;
					if(char.endsWith('-pixel')) {
						antialiasing = false;
        	   	    }
			}
		}
	}

	public function getCharacter():String {
		return char;
	}
}
