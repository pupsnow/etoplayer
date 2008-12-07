package com.eto.etoplayer.events
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class SoundPauseEvent extends CairngormEvent
	{
		public static const SOUND_PAUSE:String = "soundPause";
		public function SoundPauseEvent()
		{
			super(SOUND_PAUSE);
		}
		
	}
}