package com.eto.etoplayer.events
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class GetWebPlayListEvent extends CairngormEvent
	{
		public static const GET_WEB_PLAY_LIST:String = "GetWebPlayList";
		
		/**
		 * Constructor.
		 */
		public function GetWebPlayListEvent()
		{
			super(GET_WEB_PLAY_LIST);
		}
		
	}
}