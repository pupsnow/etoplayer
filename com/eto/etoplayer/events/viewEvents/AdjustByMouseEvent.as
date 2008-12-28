package com.eto.etoplayer.events.viewEvents
{
import flash.events.Event;

public class AdjustByMouseEvent extends Event
{
	public static const ADJUST_BY_MOUSE:String = "adjustByMouse"
	
	public var checked:Boolean = false;
	
	public function AdjustByMouseEvent(checked:Boolean)
	{
		super(ADJUST_BY_MOUSE);
		
		this.checked = checked
	}
	
}
}