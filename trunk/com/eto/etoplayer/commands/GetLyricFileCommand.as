package com.eto.etoplayer.commands
{
import com.adobe.cairngorm.commands.ICommand;
import com.adobe.cairngorm.control.CairngormEvent;
import com.adobe.cairngorm.control.CairngormEventDispatcher;
import com.eto.etoplayer.business.LoadLyricOnWeb;
import com.eto.etoplayer.business.events.DelegateErrorEvent;
import com.eto.etoplayer.business.events.DelegateResultEvent;
import com.eto.etoplayer.core.LocalFilePath;
import com.eto.etoplayer.events.GetLyricFileEvent;
import com.eto.etoplayer.events.GetLyricListEvent;
import com.eto.etoplayer.filesystem.TextFile;
import com.eto.etoplayer.model.LyricModel;
import com.eto.etoplayer.model.PlayModel;
import com.eto.etoplayer.states.LyricLoadState;
import com.eto.etoplayer.util.LyricUtil;
import com.eto.etoplayer.view.lyric.LyricData;
import com.eto.etoplayer.vo.MP3Info;

import flash.filesystem.File;

import mx.controls.Alert;
import mx.utils.StringUtil;

public class GetLyricFileCommand implements ICommand
{
	private var mp3Info:MP3Info
	private var playModel:PlayModel;
	private var lyricModel:LyricModel;
	
	public function GetLyricFileCommand()
	{
		playModel = PlayModel.getInstance();
		lyricModel = playModel.lyricModel;
	}

	public function execute(event:CairngormEvent):void
	{
		var getEvent:GetLyricFileEvent = GetLyricFileEvent(event);
		mp3Info = getEvent.mp3Info;
		
		//trace("aaa"+getEvent.lyricURL);
		if(getEvent.lyricURL)
		{
			var lyricURL:String = getEvent.lyricURL;
			//trace(urllyricURL);
			if(checkURL(lyricURL))
			{
				loadFileOnWeb(lyricURL)
			}
			else
			{
				mx.controls.Alert.show("无效的歌词路径");
			}
		}
		else
		{
			var localPath:String = getLyricLocalPath(mp3Info);
			if(localPath)
			{
				loadFileOnLocal(localPath)
			}
			else
			{
				var glEvent:GetLyricListEvent = new GetLyricListEvent(mp3Info);
				CairngormEventDispatcher.getInstance().dispatchEvent(glEvent);
			}
		}
	}
	
	private function loadFileOnWeb(url:String):void
	{
		var delegate:LoadLyricOnWeb = new LoadLyricOnWeb();
		delegate.addEventListener(
					   DelegateResultEvent.DELEGATE_RESULT,loadCompleteHandler);
		delegate.addEventListener(
								DelegateErrorEvent.DELEGATE_ERROR,IOErrorHander);
		delegate.load(url);
		
		lyricModel.currentState = LyricLoadState.LYRICLOADING;
	}
	
	private function getLyricLocalPath(mp3info:MP3Info):String
	{
		var lrcFileName:String = 
						LyricUtil.formartFileName(mp3Info.title,mp3Info.artist);
		var localLyricURL:String = 
					   LocalFilePath.lyricFolder + File.separator + lrcFileName;
		var lyricFile:File = new File(localLyricURL);
		if(lyricFile.exists)
		{
			return localLyricURL;
		}
		
		return null;
	}
	
	private function loadFileOnLocal(filePath:String):void
	{
		var textFile:TextFile = new TextFile(filePath);
		var lyricText:String = textFile.read();
		var lyrData:LyricData = LyricUtil.parse(lyricText);
		//trace(lyrData.contents.length);
		lyricModel.lyricData = lyrData;
	}
	
	private function checkURL(url:String):Boolean
	{
		if(StringUtil.isWhitespace(url))
		{
			return false;
		}
		if(url.indexOf("http://") == -1 && url.indexOf("https://") == -1)
		{
			return false
		}
		
		return true;
	}
	//--------------------------------------------------------------------------
	//
	//			event handler
	//
	//--------------------------------------------------------------------------
	private function loadCompleteHandler(event:DelegateResultEvent):void
	{
		lyricModel.currentState = LyricLoadState.LOADCOMPLETE;
		var lyricText:String = event.result;
		
		setLyricData(lyricText);
		
		var localLyricURL:String = LocalFilePath.lyricFolder + File.separator
			+ LyricUtil.formartFileName(mp3Info.title,mp3Info.artist);
			
		var textFile:TextFile = new TextFile(localLyricURL);
		textFile.write(lyricText);
	}
	
	private function IOErrorHander(event:DelegateErrorEvent):void
	{
		lyricModel.currentState = LyricLoadState.LOADCOMPLETE;
		mx.controls.Alert.show(event.errorMessage);
	}
	
	private function setLyricData(lyricText:String):void
	{
		var lyrData:LyricData = LyricUtil.parse(lyricText);
		PlayModel.getInstance().lyricModel.lyricData = lyrData;
	}
}
}