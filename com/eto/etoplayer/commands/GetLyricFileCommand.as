package com.eto.etoplayer.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.eto.etoplayer.core.LocalFilePath;
	import com.eto.etoplayer.events.GetLyricFileEvent;
	import com.eto.etoplayer.filesystem.TextFile;
	import com.eto.etoplayer.model.PlayModel;
	import com.eto.etoplayer.util.LyricUtil;
	import com.eto.etoplayer.view.lyric.LyricData;
	import com.eto.etoplayer.vo.MP3Info;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.System;
	
	import mx.controls.Alert;

	public class GetLyricFileCommand implements ICommand
	{
		private var mp3Info:MP3Info
		
		public function GetLyricFileCommand()
		{
			
		}

		public function execute(event:CairngormEvent):void
		{
			var getEvent:GetLyricFileEvent = GetLyricFileEvent(event);
			mp3Info = getEvent.mp3Info;
			
			getFileOnWeb(getEvent.lyricURL);
		}
		
		private function getFileOnWeb(url:String):void
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
			
			setLyricData(lyricText);
			
			var localLyricURL:String = LocalFilePath.lyricFolder + 
				"\\" + LyricUtil.getRuleFileName(mp3Info.title,mp3Info.artist);
				
			var textFile:TextFile = new TextFile(localLyricURL);
			textFile.write(lyricText);
		}
		
		private function setLyricData(lyricText:String):void
		{
			var lyrData:LyricData = LyricUtil.parse(lyricText);
			PlayModel.getInstance().lyricModel.lyricData = lyrData;
		}
		
		private function IOErrorHander(event:Event):void
		{
			System.useCodePage = false
			mx.controls.Alert.show("指定歌词服务器不可用或已过期。");
		}
	}
}