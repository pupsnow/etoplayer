package com.eto.etoplayer.view.lyric
{
	/**
	 * This value Object Class contain valueable contents 
	 * of one lyric file which was parsed.
	 * 
	 * @author Riyco
	 * 
	 */	
	public class LyricData
	{
		//----------------------------------------
		//		title
		//----------------------------------------
		private var _title:String = "";
		
		public function get title():String
		{
			return _title;
		}
		public function set title(str:String):void
		{
			_title = str;
		}
		
		//-----------------------------------------
		//		artist
		//-----------------------------------------
		private var _artist:String = "";
		
		public function get artist():String
		{
			return _artist;
		}
		public function set artist(str:String):void
		{
			_artist = str;
		}
		
		//-----------------------------------------
		//		album
		//-----------------------------------------
		private var _album:String = "";
		
		public function get album():String
		{
			return _album;
		}
		public function set album(str:String):void
		{
			_album = str;
		}
		
		//-----------------------------------------
		//		madeBy
		//-----------------------------------------
		public var _madeBy:String = "";
		
		public function get madeBy():String
		{
			return _madeBy;
		}
		public function set madeBy(str:String):void
		{
			_madeBy = str;
		}
		
		//-----------------------------------------
		//		times
		//-----------------------------------------
		private var _times:Array;
		
		public function get times():Array
		{
			return _times;
		}
		public function set times(arr:Array):void
		{
			_times = arr;
		}
		
		//-----------------------------------------
		//		contents
		//-----------------------------------------
		private var _contents:Array;
		
		public function get contents():Array
		{
			return _contents;
		}
		public function set contents(arr:Array):void
		{
			_contents = arr;
		}
	}
}