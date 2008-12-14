package com.eto.etoplayer.core
{
import flash.events.EventDispatcher;

[Event(name="userConfigComplete", type="com.eto.etoplayer.events.dataEvents.ApplicationEvent")]

public class ApplicationDispatcher extends EventDispatcher
{
	private static var _instance:ApplicationDispatcher;
	
	public static function getInstance():ApplicationDispatcher
	{
		if(!_instance)
		{
			_instance = new ApplicationDispatcher();
		}
		
		return _instance;
	}
	
	
	
	public function ApplicationDispatcher()
	{
		super();
	}
	
}
}