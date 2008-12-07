package com.eto.etoplayer.events
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class RemovePlayListItemsEvent extends CairngormEvent
	{
		public static const REMOVE_PLAY_LIST_ITEM:String = "removePlayListItem";
		
		private var _removeItems:Array;
		public function set removeItems(items:Array):void
		{
			_removeItems = items;
		}
		public function get removeItems():Array
		{
			return _removeItems;
		}
		
		private var _isRemoveAll:Boolean = false;
		public function set isRemoveAll(items:Boolean):void
		{
			_isRemoveAll = items;
		}
		public function get isRemoveAll():Boolean
		{
			return _isRemoveAll;
		}
		
		public function RemovePlayListItemsEvent(bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(REMOVE_PLAY_LIST_ITEM, bubbles, cancelable);
		}
		
	}
}