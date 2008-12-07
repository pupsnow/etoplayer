package com.eto.etoplayer.interfaces
{
	import flash.events.IEventDispatcher;

	public interface IDelegate extends IEventDispatcher
	{
		function call():void
	}
}