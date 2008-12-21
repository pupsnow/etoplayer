package com.eto.etoplayer.business.abstract
{
import com.eto.etoplayer.interfaces.IDelegate;

import flash.events.EventDispatcher;

[Event(name="delegateResult", type="com.eto.etoplayer.business.events.DelegateResultEvent")]
[Event(name="delegateError", type="com.eto.etoplayer.business.events.DelegateErrorEvent")]

public class AbstractDelegate extends EventDispatcher implements IDelegate
{
	public function AbstractDelegate()
	{
		
	}
}
}