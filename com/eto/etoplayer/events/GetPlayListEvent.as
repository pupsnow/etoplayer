package com.eto.etoplayer.events
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class GetPlayListEvent extends CairngormEvent
	{
		public static const GET_PLAY_LIST:String = "getPlayList";
		
		public function GetPlayListEvent()
		{
			super(GET_PLAY_LIST);
		}
		
	}
}