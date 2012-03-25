package com.eto.etoplayer.business.abstract
{
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

public class AbstractURLLoader extends URLLoader
{
	public function AbstractURLLoader(request:URLRequest=null)
	{
		super(request);
		
		addEventListener(Event.COMPLETE,loadCompleteHandler);
		addEventListener(IOErrorEvent.IO_ERROR,IOErrorHandler);
		//addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,
	}
	
	protected function loadCompleteHandler(event:Event):void
	{
		throw new Error("");
	}
	
	protected function loadCompleteHandler(event:Event):void
	{
		
	}
	protected function loadCompleteHandler(event:Event):void
	{
		
	}
	protected function loadCompleteHandler(event:Event):void
	{
		
	}
	protected function loadCompleteHandler(event:Event):void
	{
		
	}
		//override public function 
	}
}