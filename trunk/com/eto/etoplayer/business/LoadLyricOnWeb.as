package com.eto.etoplayer.business
{
import com.eto.etoplayer.business.abstract.AbstractDelegate;
import com.eto.etoplayer.business.events.DelegateErrorEvent;
import com.eto.etoplayer.business.events.DelegateResultEvent;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.system.System;

public class LoadLyricOnWeb extends AbstractDelegate
{
	public function LoadLyricOnWeb()
	{
		super();
	}
	
	public function load(url:String):void
	{
		var regexp:RegExp = /&amp;/g
		var codeUrl:String = url.replace(regexp,"&");
		
		var request:URLRequest = new URLRequest(codeUrl);
		var loader:URLLoader = new URLLoader();
		loader.addEventListener(IOErrorEvent.IO_ERROR,IOErrorHander);
		loader.addEventListener(Event.COMPLETE,loadCompleteHandler);
		loader.load(request);
		
		System.useCodePage = true;
	}
	
	private function loadCompleteHandler(event:Event):void
	{
		var lyricText:String = event.currentTarget.data;
		System.useCodePage = false;
		
		dispatchEvent(new DelegateResultEvent(lyricText));
	}
	
	private function IOErrorHander(event:Event):void
	{
		System.useCodePage = false
		dispatchEvent(new DelegateErrorEvent("指定歌词服务器不可用或已过期。"));
	}
}
}