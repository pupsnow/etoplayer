package com.eto.etoplayer.core
{
	import com.eto.etoplayer.events.dataEvents.ApplicationEvent;
	import com.eto.etoplayer.filesystem.TextFile;
	import com.eto.etoplayer.states.PlayPattern;
	
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
		var playsets:Object = xml.playsets;
		playPattern = playsets.playpattern;
		volume = Number(playsets.volume);
		
		var dialogshows:Object = xml.dialogshows
		showAppCloseMode = dialogshows.showappclosemode;
		
		var event:ApplicationEvent = 
					new ApplicationEvent(ApplicationEvent.USER_CONFIG_COMPLETE);
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
	
	//------------------------------
	//	  volume
	//------------------------------
	
	private static var _volume:Number = 0.8;
	
	public static function get volume():Number
	{
		return _volume;
	}
	public static function set volume(vol:Number):void
	{
		_volume = vol;
	}
	
	//------------------------------
	//	  showClodeMode
	//------------------------------
	
	private static var _showAppCloseMode:String = "";
	
	public static function get showAppCloseMode():String
	{
		return _showAppCloseMode;
	}
	public static function set showAppCloseMode(mode:String):void
	{
		if(mode && mode != "")
		{
			_showAppCloseMode = mode;
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//	  		method
	//
	//--------------------------------------------------------------------------
	public static function save():void
	{
		var textFile:TextFile = new TextFile(LocalFilePath.userConfig);
		textFile.write(toXMLString());
	}
	
	public static function toXMLString():String
	{
		var xmlString:String = "<user>";
		xmlString += "<playsets>";
		xmlString += "<playpattern>"+ playPattern +"</playpattern>"
		xmlString += "<volume>"+ volume +"</volume>"
		xmlString += "</playsets>";
		xmlString += "<dialogshows>";
		xmlString += "<showappclosemode>" + showAppCloseMode + "</showappclosemode>" ;
		xmlString += "</dialogshows>";
		xmlString += "</user>"
		return xmlString;
	}
}
}