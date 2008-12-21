package com.eto.etoplayer.model
{
import com.adobe.cairngorm.model.IModelLocator;
import com.eto.etoplayer.events.modelEvents.LyricListResultEvent;
import com.eto.etoplayer.view.lyric.LyricData;
import com.eto.etoplayer.vo.lyric.lyricListResultVo;

import flash.events.EventDispatcher;

[Event(name="lyricListResult", type="com.eto.etoplayer.events.modelEvents.LyricListResultEvent")]

public class LyricModel extends EventDispatcher implements IModelLocator
{
	[Bindable]
	public var lyricData:LyricData;
	
	[Bindable]
	public var timePosition:int = 0;
	
	[Bindable]
	public var currentState:String;
	
	private var _lyricSearchList:lyricListResultVo;
	
	public function set lyricListResult(vo:lyricListResultVo):void
	{
		_lyricSearchList = vo;
		dispatchEvent(new LyricListResultEvent());
	}
	
	public function get lyricListResult():lyricListResultVo
	{
		return _lyricSearchList;
	}
}
}