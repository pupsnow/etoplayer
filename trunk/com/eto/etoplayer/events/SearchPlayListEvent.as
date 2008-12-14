package com.eto.etoplayer.events
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class SearchPlayListEvent extends CairngormEvent
	{
		public static const SEARCH_PLAY_LIST:String = "searchPlayList";
		
		public var keyword:String = null;
		
		public function SearchPlayListEvent(keyword:String)
		{
			super(SEARCH_PLAY_LIST);
			
			this.keyword = keyword;
		}
		
	}
}