package com.eto.etoplayer.model
{
	import com.adobe.cairngorm.model.IModelLocator;
	import com.eto.etoplayer.view.lyric.LyricData;

	public class LyricModel implements IModelLocator
	{
		[Bindable]
		public var lyricData:LyricData;
		
		[Bindable]
		public var timePosition:int = 0;
		
		[Bindable]
		public var currentState:String;
	}
}