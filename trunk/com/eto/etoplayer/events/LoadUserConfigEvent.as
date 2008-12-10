package com.eto.etoplayer.events
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class LoadUserConfigEvent extends CairngormEvent
	{
		public static const LOAD_USER_CONFIG:String = "loadUserConfig";
		
		public function LoadUserConfigEvent()
		{
			super(LOAD_USER_CONFIG);
		}
		
	}
}