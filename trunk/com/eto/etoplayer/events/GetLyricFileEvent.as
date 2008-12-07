package com.eto.etoplayer.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.eto.etoplayer.vo.MP3Info;

	public class GetLyricFileEvent extends CairngormEvent
	{
		public static const GET_LYRIC_FILE:String = "GetLyricFile";
		
		private var _mp3Info:MP3Info
				
		public function get mp3Info():MP3Info
		{
			return _mp3Info;
		}
		
		private var _lyricURL:String
				
		public function get lyricURL():String
		{
			return _lyricURL;
		}
		
		public function GetLyricFileEvent(lyricURL:String,mp3Info:MP3Info)
		{
			super(GET_LYRIC_FILE);
			
			_lyricURL = lyricURL;
			_mp3Info = mp3Info;
		}
		
	}
}