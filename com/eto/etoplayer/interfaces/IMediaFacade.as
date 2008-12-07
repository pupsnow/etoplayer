package com.eto.etoplayer.interfaces
{
	import flash.events.IEventDispatcher;
	
	public interface IMediaFacade extends IEventDispatcher
	{
		function load(url:String):void
	
		function play(pos:int = 0):void
		
		function stop(pos:int = 0):void
		
		function pause():void
		
		function resume():void
		
		function get url():String
		
		function get displayTime():String
		
		function get currentState():String
	}
}