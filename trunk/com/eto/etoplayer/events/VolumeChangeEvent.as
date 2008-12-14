package com.eto.etoplayer.events
{
import com.adobe.cairngorm.control.CairngormEvent;

public class VolumeChangeEvent extends CairngormEvent
{
	public static const VOLUME_CHANGE:String = "VolumeChange";
	
	private var _value:Number = 0;
	
	public function get value():Number
	{
		return _value
	}
	
	private var _saveChange:Boolean = false;
	
	public function get saveChange():Boolean
	{
		return _saveChange
	}
	
	public function VolumeChangeEvent(value:Number, saveChange:Boolean = false)
	{
		super(VOLUME_CHANGE);
		
		_value = value;
		_saveChange = saveChange;
	}
	
}
}