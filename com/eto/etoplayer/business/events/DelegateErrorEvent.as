package com.eto.etoplayer.business.events
{
import flash.events.Event;

public class DelegateErrorEvent extends Event
{
	public static const DELEGATE_ERROR:String = "delegateError";
	
	private var _errorMessage:String = "";
	public function get errorMessage():String
	{
		return _errorMessage;
	}
	public function DelegateErrorEvent(message:String)
	{
		super(DELEGATE_ERROR);
		
		_errorMessage = message;
	}
	
}
}