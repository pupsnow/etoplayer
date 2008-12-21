package com.eto.etoplayer.commands
{
import com.adobe.cairngorm.control.CairngormEvent;
import com.adobe.cairngorm.commands.ICommand;

public class LoadLyricFileCommand implements ICommand
{
	public function LoadLyricFileCommand()
	{
	}

	public function execute(event:CairngormEvent):void
	{
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