package com.eto.etoplayer.events
{
import com.adobe.cairngorm.control.CairngormEvent;

public class PlayListSortEvent extends CairngormEvent
{
	public static const PLAY_LIST_SORT:String = "playListSort";
	
	public var sortOn:String = "";
	
	public function PlayListSortEvent(fieldName:String)
	{
		super(PLAY_LIST_SORT);
		
		sortOn = fieldName;
	}
	
}
}