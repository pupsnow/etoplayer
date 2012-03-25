package com.eto.etoplayer.vo
{
	//import mx.utils.ObjectUtil;
	
	public class MP3Info
	{
		public function MP3Info(item:Object = null)
		{
			//trace(ObjectUtil.toString(item));
			if(item is XML)
			{
				title = item.@title;
				album = item.@album;
				artist = item.@artist;
				year = item.@year;
				genre = item.@genre;
				track = item.@track;
				comment = item.@comment;
				url = item.@url;
			}
		}
		
		public var title : String = "";//歌曲的名称；对应于 ID3 2.0 标签 TIT2。 ID3Info	
		public var album : String = "";//专辑的名称；对应于 ID3 2.0 标签 TALB。 ID3Info 	
		public var artist : String = "";//歌手的姓名；对应于 ID3 2.0 标签 TPE1。 ID3Info 	
		public var year : String = "";//录制的年份；对应于 ID3 2.0 标签 TYER。
		public var genre : String = "";//歌曲的流派；对应于 ID3 2.0 标签 TCON。 ID3Info 		
		public var track : String = "";//曲目编号；对应于 ID3 2.0 标签 TRCK。 ID3Info 		 
		public var comment : String = "";//录制的相关注解；对应于 ID3 2.0 标签 COMM。 ID3Info 
		public var url:String = "";//文件路径.
		
		public function toXMLString():String
		{
			var xmlStr:String = "<item title=\"" + title 
							  + "\" album=\"" + album 
							  + "\" artist=\"" + artist 
							  + "\" year=\"" + year 
							  + "\" genre=\"" + genre 
							  + "\" url=\"" + url + "\"/>";
			return xmlStr;
		}
		
		public function toXML():XML
		{
			var xml:XML = <item title={title} album={album} artist={artist} year={year} genre={genre} url={url}/>;
			return xml;
		}
		
		public function indexOf(str:String):int
		{
			var tix:int = title.toLowerCase().indexOf(str);
			if(tix!= -1)
			{
				return tix;
			}
			
			tix = artist.toLowerCase().indexOf(str);
			if(tix!= -1)
			{
				return tix;
			}
			
			return -1
		}
	}
}