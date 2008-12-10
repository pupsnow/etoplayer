package com.eto.etoplayer.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.eto.etoplayer.business.GetLyricListDelegate;
	import com.eto.etoplayer.commands.abstract.AbstractRequestCommand;
	import com.eto.etoplayer.core.LocalFilePath;
	import com.eto.etoplayer.events.GetLyricListEvent;
	import com.eto.etoplayer.filesystem.TextFile;
	import com.eto.etoplayer.model.PlayModel;
	import com.eto.etoplayer.util.LyricUtil;
	import com.eto.etoplayer.view.lyric.LyricData;
	import com.eto.etoplayer.view.lyric.lyricLoadChoose;
	import com.eto.etoplayer.vo.GetLyricListVo;
	import com.eto.etoplayer.vo.MP3Info;
	
	import flash.display.DisplayObject;
	import flash.filesystem.File;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.PopUpManager;

	public class GetLyricListCommand extends AbstractRequestCommand
	{
		private var mp3Info:MP3Info;
		
		public function GetLyricListCommand()
		{
			//trace("");
		}
		
		override public function execute(event:CairngormEvent):void
		{
			var getEvent:GetLyricListEvent = GetLyricListEvent(event);
			mp3Info = getEvent.mp3Info;
			
			var localLyricURL:String = LocalFilePath.lyricFolder + 
				"\\" + LyricUtil.getRuleFileName(mp3Info.title,mp3Info.artist);
			var lyricFile:File = new File(localLyricURL);
			if(lyricFile.exists && !getEvent.strongSearch)
			{
				var textFile:TextFile = new TextFile(localLyricURL);
				var lyricText:String = textFile.read();
				var lyrData:LyricData = LyricUtil.parse(lyricText);
				PlayModel.getInstance().lyricModel.lyricData = lyrData;
			}
			else
			{
				var delegate:GetLyricListDelegate = new GetLyricListDelegate(this);
			
				//var kewords:String = mp3Info.title;
				var vo:GetLyricListVo = new GetLyricListVo();
				vo.title = mp3Info.title;
				delegate.send(vo);
			}
		}
		
		override public function result(data:Object):void
		{
			try
			{				
 				//var revent:ResultEvent = data as ResultEvent;
 				var xml:XML=new XML(data);
 				
 				var lycList:XMLList = xml.children();
 				var len:int = lycList.length();
 				if(len > 0)
 				{
 					/* if(len == 1)
 					{ */
 						var lyricChoose:lyricLoadChoose = new lyricLoadChoose();
	 					
	 					PopUpManager.addPopUp(lyricChoose,Application.application as DisplayObject,true);
	 					PopUpManager.centerPopUp(lyricChoose);
	 					
	 					lyricChoose.setData(lycList,mp3Info);
 					//}
 				}
 				else
 				{
 					Alert.show("未在服务器上搜索到歌词");
 				}
 			}
 			catch(exception:Error)
			{
 				Alert.show(exception.getStackTrace(),exception.message);
 			}
		}   
	}
}