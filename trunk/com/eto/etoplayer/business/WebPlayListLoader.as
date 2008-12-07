package com.eto.etoplayer.business
{
	import com.eto.etoplayer.business.events.DelegateResultEvent;
	import com.eto.etoplayer.core.ServerLocation;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 *  Dispatched when loading play list success.
	 */
	[Event(name="delegateResult", type="com.eto.etoplayer.business.DelegateResultEvent")]
	
	/**
	 * 
	 * @author Riyco
	 * 
	 */	
	public class WebPlayListLoader extends EventDispatcher
	{
		private var updataLoader:URLLoader 
		
		public function WebPlayListLoader()
		{
			super();
			
			updataLoader = new URLLoader();
			updataLoader.addEventListener(Event.COMPLETE,loaderCompleteHandler);
		}
		
		public function load():void
		{
			var updataRequest:URLRequest = new URLRequest(ServerLocation.webPlayListAddress);
			
			updataLoader.load(updataRequest);
			
		}
		
		private function loaderCompleteHandler(event:Event):void
   		{
   			var resultEvent:DelegateResultEvent 
   								= new DelegateResultEvent(updataLoader.data);
   			
   			dispatchEvent(resultEvent);
   		}
	}
}