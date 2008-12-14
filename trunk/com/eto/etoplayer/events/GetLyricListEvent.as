package com.eto.etoplayer.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.eto.etoplayer.vo.MP3Info;

	public class GetLyricListEvent extends CairngormEvent
	{
		public static const GET_LRC_LIST:String = "GetLrcList";
		
		
		private var _mp3Info:MP3Info
				
		public function get mp3Info():MP3Info
		{
			return _mp3Info;
		}
		
		private var _strongSearch:Boolean;
		
		public function get strongSearch():Boolean
		{
			return _strongSearch;
		}
		
		public function GetLyricListEvent(mp3Info:MP3Info = null,strongSearch:Boolean = false)
		{
			super(GET_LRC_LIST);
			
			_mp3Info = mp3Info;
			_strongSearch = strongSearch; 
		}
		
	}
}