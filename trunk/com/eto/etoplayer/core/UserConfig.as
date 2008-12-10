package com.eto.etoplayer.core
{
	import com.eto.etoplayer.states.PlayPattern;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
public class UserConfig extends EventDispatcher
{
	//--------------------------------------------------------------------------
	//
	//	  		property
	//
	//--------------------------------------------------------------------------
	
	//------------------------------
	//	  configXML
	//------------------------------
	
	public static function set configXML(configXML:XML):void
	{
		setConfigXML(configXML);
	}
	
	private static function setConfigXML(xml:XML):void
	{
		playPattern = xml.playsets.playpattern;
		
		var event:Event = 
					new Event(ApplicationDispatcher.USER_CONFIG_COMPLETE);
		ApplicationDispatcher.getInstance().dispatchEvent(event);
	}
	
	//------------------------------
	//	  playPattern
	//------------------------------
	
	private static var _playPattern:String = PlayPattern.SINGLE;
	
	public static function get playPattern():String
	{
		return _playPattern;
	}
	public static function set playPattern(pattern:String):void
	{
		_playPattern = pattern;
	}
	
	//--------------------------------------------------------------------------
	//
	//	  		method
	//
	//--------------------------------------------------------------------------
	
	public static function toXMLString():String
	{
		var xmlString:String = "<user>";
		xmlString += "<playsets>";
		xmlString += "<playpattern>"+ playPattern +"</playpattern>"
		xmlString += "</playsets>";
		xmlString += "</user>"
		return xmlString;
	}
}
}