package com.eto.etoplayer.view.lyric
{
	import flash.events.Event;

	public class PositionChangeEvent extends Event
	{
		public static const POSITION_CHANGE:String = "positionChange";
		
		private var _newPosition:int = 0;
		
		public function get newPosition():int
		{
			return _newPosition;
		}
		
		public function PositionChangeEvent(position:int)
		{
			super(POSITION_CHANGE);
			
			_newPosition = position;
		}
		
	}
}