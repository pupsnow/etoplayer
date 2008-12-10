package com.eto.etoplayer.core
{
import flash.events.EventDispatcher;

[Event(name="userConfigComplete", type="flash.events.Event")]

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
	
	public static const USER_CONFIG_COMPLETE:String = "userConfigComplete";
	
	public function ApplicationDispatcher()
	{
		super();
	}
	
}
}