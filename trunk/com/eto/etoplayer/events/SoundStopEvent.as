package com.eto.etoplayer.events
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class SoundStopEvent extends CairngormEvent
	{
		public static const SOUND_STOP:String = "soundStop";
		
		public function SoundStopEvent()
		{
			super(SOUND_STOP);
		}
		
	}
}