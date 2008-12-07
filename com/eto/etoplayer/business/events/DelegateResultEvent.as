package com.eto.etoplayer.business.events
{
	import flash.events.Event;

	public class DelegateResultEvent extends Event
	{
		public static const DELEGATE_RESULT:String = "delegateResult";
		
		public var result:*;
		
		public function DelegateResultEvent(result:* = null)
		{
			super(DELEGATE_RESULT);
			
			this.result = result;
		}
	}
}