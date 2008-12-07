package com.eto.etoplayer.events
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class VersionUpdateEvent extends CairngormEvent
	{
		public static const VERSION_UPDATE:String = "VersionUpdate";
		
		/**
		 * Constructor.
		 */
		public function VersionUpdateEvent()
		{
			super(VERSION_UPDATE);
		}
		
		//public static var updateURL:String = "http://etostudio.gicp.net/etoplayer/toto_update.xml";
	}
}