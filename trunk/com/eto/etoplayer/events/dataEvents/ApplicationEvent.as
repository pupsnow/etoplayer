package com.eto.etoplayer.events.dataEvents
{
	import flash.events.Event;
	
	public class ApplicationEvent extends Event
	{
		public static const USER_CONFIG_COMPLETE:String = "userConfigComplete";
		
		public function ApplicationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}