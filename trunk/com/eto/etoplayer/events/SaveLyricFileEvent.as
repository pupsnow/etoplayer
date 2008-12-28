package com.eto.etoplayer.events
{
import com.adobe.cairngorm.control.CairngormEvent;
import com.eto.etoplayer.vo.MP3Info;

public class SaveLyricFileEvent extends CairngormEvent
{
	public static const SAVE_LYRIC_FILE:String = "saveLyricFile";
	
	private var _mp3Info:MP3Info;
	
	public function get mp3Info():MP3Info
	{
		return _mp3Info;
	}
	
	public function SaveLyricFileEvent(data:*,mp3Info:MP3Info)
	{
		super(SAVE_LYRIC_FILE);
		this.data = data;
		_mp3Info = mp3Info;
	}
	
}
}