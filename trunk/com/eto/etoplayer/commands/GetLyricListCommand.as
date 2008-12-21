package com.eto.etoplayer.commands
{
import com.adobe.cairngorm.control.CairngormEvent;
import com.eto.etoplayer.business.GetLyricListDelegate;
import com.eto.etoplayer.commands.abstract.AbstractRequestCommand;
import com.eto.etoplayer.events.GetLyricListEvent;
import com.eto.etoplayer.model.LyricModel;
import com.eto.etoplayer.model.PlayModel;
import com.eto.etoplayer.states.LyricLoadState;
import com.eto.etoplayer.vo.GetLyricListVo;
import com.eto.etoplayer.vo.MP3Info;
import com.eto.etoplayer.vo.lyric.lyricListResultVo;

import mx.controls.Alert;

public class GetLyricListCommand extends AbstractRequestCommand
{
	private var mp3Info:MP3Info;
	private var lyricModel:LyricModel;
	private var playModel:PlayModel;
	
	public function GetLyricListCommand()
	{
		playModel = PlayModel.getInstance();
		lyricModel = PlayModel.getInstance().lyricModel
	}
	
	override public function execute(event:CairngormEvent):void
	{
		var getEvent:GetLyricListEvent = GetLyricListEvent(event);
		mp3Info = playModel.playItem;

		getlyricList(mp3Info);
	}
	
	public function getlyricList(mp3Info:MP3Info):void
	{
		var delegate:GetLyricListDelegate = new GetLyricListDelegate(this);
		var vo:GetLyricListVo = new GetLyricListVo();
		vo.title = mp3Info.title;
		vo.artist = mp3Info.artist;
		delegate.send(vo);
		
		lyricModel.currentState = LyricLoadState.LISTLOADING;
	}
	
	override public function result(data:Object):void
	{
		lyricModel.currentState = LyricLoadState.LOADCOMPLETE;
		
		try
		{				
 			//var revent:ResultEvent = data as ResultEvent;
 			var xml:XML=new XML(data);
 			
 			var lycList:XMLList = xml.children();
 			var len:int = lycList.length();
 			if(len > 0)
 			{
 				var vo:lyricListResultVo = 
 										new lyricListResultVo(lycList,mp3Info);
 				lyricModel.lyricListResult = vo;
 				/* if(len == 1)
 				{ */
 					//var lyricChoose:lyricLoadChoose = new lyricLoadChoose();
 					
 					//PopUpManager.addPopUp(lyricChoose,Application.application as DisplayObject,true);
 					//PopUpManager.centerPopUp(lyricChoose);
 					
 					//lyricChoose.setData(lycList,mp3Info);
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