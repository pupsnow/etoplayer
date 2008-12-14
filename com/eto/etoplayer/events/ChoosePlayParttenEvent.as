package com.eto.etoplayer.events
{
import com.adobe.cairngorm.control.CairngormEvent;

public class ChoosePlayParttenEvent extends CairngormEvent
{
	public static const CHOOSE_PLAY_PARTTEN:String = "choosePlayPartten";
	
	private var _partten:String = null;
	public function get partten():String
	{
		return _partten;
	}
	public function ChoosePlayParttenEvent(pt:String)
	{
		super(CHOOSE_PLAY_PARTTEN);
		
		_partten = pt;
	}
}
}