package com.eto.etoplayer.interfaces
{
	public interface IPlayModel extends IEventDispatcherModel
	{
		/* function get url():String
		
		function get position():int
		
		function get playState():String*/
		
		function get title():String 
		
		function get mediaFacade():IMediaFacade
	}
}