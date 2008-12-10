package com.eto.etoplayer.events
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class SaveUserConfigEvent extends CairngormEvent
	{
		public static const SAVE_USER_CONFIG:String = "saveUserConfig";
		
		public function SaveUserConfigEvent()
		{
			super(SAVE_USER_CONFIG);
		}
	}
}