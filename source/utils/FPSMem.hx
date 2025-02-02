package utils;

import haxe.Timer;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System;
import grafex.data.EngineData;
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end
#if flash
import openfl.Lib;
#end

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class FPSMem extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;
    public var currentMem:Float;

    public static var showMem:Bool=true;
    public static var showFPS:Bool=true;
	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	var lastUpdate:Float = 0;
	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
                defaultTextFormat = new TextFormat(openfl.utils.Assets.getFont("assets/fonts/VCR OSD Mono Cyr.ttf").fontName, 14, color);
		width = 1280;
		height = 720;

		//text = "FPS: ";

		cacheCount = 0;
		currentTime = 0;
		times = [];

		#if flash
		addEventListener(Event.ENTER_FRAME, function(e)
		{
			__enterFrame(Timer.stamp()-lastUpdate);
		});
		#end
	}

	// Event Handlers
	@:noCompletion
	private #if !flash override #end function __enterFrame(d:Float):Void
		{
			currentTime = Timer.stamp();
			var dt = currentTime-lastUpdate;
			lastUpdate = currentTime;
			times.push(currentTime);
			while(times[0]<currentTime-1)
				times.shift();
	
			var currentCount = times.length;
			currentFPS = currentCount;
			currentMem = Math.round(System.totalMemory / (1e+6));
	
		  if (currentCount != cacheCount /*&& visible*/) {
			text = "";
			var s:String = 'FPSMem';
			if(showFPS) {
			   text += Translation.string("FPS", s) + ": " + currentFPS + "\n";
			}
			if(showMem) {
				if(currentMem<0) {
					text += Translation.string("Memory", s) + ": " + Translation.string("Leaking", s) + " " + Math.abs(currentMem) + " " + Translation.string("MB", s) + "\n";
				} else {
					text += Translation.string("Memory", s) + ": " + currentMem + " " + Translation.string("MB", s) + "\n";
					}
				}
				//text += "Grafex Engine v. " + data.EngineData.grafexEngineVersion + "\n" ;
			}
	
			cacheCount = currentCount;
		}
}