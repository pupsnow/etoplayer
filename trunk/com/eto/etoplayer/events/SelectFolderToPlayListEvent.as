package com.eto.etoplayer.events
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class SelectFolderToPlayListEvent extends CairngormEvent
	{
		public static const SELECT_FOLDER_TO_PLAYLIST:String = "selectFolderToPlayList";
		
		public function SelectFolderToPlayListEvent()
		{
			super(SELECT_FOLDER_TO_PLAYLIST);
		}
	}
}