package com.eto.etoplayer.events.modelEvents
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class LyricListResultEvent extends CairngormEvent
	{
		public static const LYRIC_LIST_RESULT:String = "lyricListResult";
		
		public function LyricListResultEvent()
		{
			super(LYRIC_LIST_RESULT);
		}
		
	}
}