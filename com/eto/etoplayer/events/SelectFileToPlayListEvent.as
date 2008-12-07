package com.eto.etoplayer.events
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class SelectFileToPlayListEvent extends CairngormEvent
	{
		public static const SELECT_FILE_TO_PLAY_LIST:String = "selectFileToPlayList";
		
		public function SelectFileToPlayListEvent(bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(SELECT_FILE_TO_PLAY_LIST, bubbles, cancelable);
		}
		
	}
}