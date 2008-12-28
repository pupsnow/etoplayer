package com.eto.etoplayer.commands
{
import com.adobe.cairngorm.commands.ICommand;
import com.adobe.cairngorm.control.CairngormEvent;
import com.eto.etoplayer.core.LocalFilePath;
import com.eto.etoplayer.events.SaveLyricFileEvent;
import com.eto.etoplayer.filesystem.TextFile;
import com.eto.etoplayer.model.PlayModel;
import com.eto.etoplayer.util.LyricUtil;
import com.eto.etoplayer.view.lyric.LyricData;
import com.eto.etoplayer.vo.MP3Info;

import flash.filesystem.File;

public class SaveLyricFileCommand implements ICommand
{
	public function SaveLyricFileCommand()
	{
	}

	public function execute(event:CairngormEvent):void
	{
		var evn:SaveLyricFileEvent = SaveLyricFileEvent(event);
		var data:* = evn.data;
		var mp3Info:MP3Info = evn.mp3Info;
		var lyricFileText:String = "";
		
		if(data is String)
		{
			lyricFileText = data;
		}
		else if(data is LyricData)
		{
			lyricFileText = LyricUtil.restoreFileText(data);
		}
		
		var localLyricURL:String = LocalFilePath.lyricFolder + File.separator
			+ LyricUtil.formartFileName(mp3Info.title,mp3Info.artist);
			
		var textFile:TextFile = new TextFile(localLyricURL);
		textFile.write(lyricFileText);
		
		PlayModel.getInstance().lyricModel.lyricFileChange = false;
	}
	
}
}