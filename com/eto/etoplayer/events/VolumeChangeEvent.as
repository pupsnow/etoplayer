package com.eto.etoplayer.events
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class VolumeChangeEvent extends CairngormEvent
	{
		public static const VOLUME_CHANGE:String = "VolumeChange";
		
		public var value:Number = 0;
		
		public function VolumeChangeEvent()
		{
			super(VOLUME_CHANGE);
		}
		
	}
}