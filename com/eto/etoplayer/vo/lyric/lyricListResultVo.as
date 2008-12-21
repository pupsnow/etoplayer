package com.eto.etoplayer.vo.lyric
{
import com.eto.etoplayer.vo.MP3Info;
	
public class lyricListResultVo
{
	public function lyricListResultVo(list:Object,mp3info:MP3Info)
	{
		_lyricList = list;
		_mp3Info = mp3info
	}
	
	private var _lyricList:Object
	public function get lyricList():Object
	{
		return _lyricList;
	}
	
	private var _mp3Info:MP3Info
	public function get mp3Info():MP3Info
	{
		return _mp3Info;
	}
	
}
}