package com.eto.etoplayer.util
{
	import com.eto.etoplayer.view.lyric.LyricData;
	
	public class LyricUtil
	{
		public function LyricUtil()
		{
			
		}
		
		public static function parse(lyricSrc:String):LyricData
		{
			trace(lyricSrc);
			var lyricObject:LyricData = new LyricData();
			
 		    var lyricList:Array = lyricSrc.split('\r\n');
 		    trace("lyricList:"+lyricList.toString());
 		    var lyricArr:Array=new Array();
			var timeArr:Array=new Array();
			
 		    for(var i:int=0;i<lyricList.length;i++)
 		    {
 		    	var lyricItem:String=lyricList[i];
 		    	
 		    	if(lyricItem.indexOf("ti:") != -1) 
 		    	{
					lyricObject.title = lyricItem.replace("ti:","曲名:");
				} 
				else if(lyricItem.indexOf("ar:") != -1) 
				{
					lyricObject.artist = lyricItem.replace("ar:","艺术家:");
				} 
				else if(lyricItem.indexOf("al:") != -1) 
				{
					lyricObject.album = lyricItem.replace("al:","专辑:");
				} 
				else if(lyricItem.indexOf("by:") != -1) 
				{
					lyricObject.madeBy = lyricItem.replace("by:","制作:");
 		 		}
 		 		else
 		 		{
	 		 		var pattern:RegExp = /\[/g;
	 		 			lyricItem = lyricItem.replace(pattern,"")
	 		 		
	 		 		var item_im:Array = lyricItem.split("]");
	 		 		var item_len:int=item_im.length;
	 		 		for(var j:int=0;j<item_len-1;j++)
	 		 		{
	 		 			if(item_len>1)
	 		 			{
	 		 				//Maybe some lyric file`s time content like this:[00:44.11]
	 		 				//So I just intercept(substr) the minute and second in order to 
	 		 				//temporary facilitation 
	 		 				//var timeStr:String=item_im[j].substr(0,5);
	 		 				var msel:Number = TimeFormatter.lyricTimeToMSEL(item_im[j]);
	 		 				timeArr.push(msel);
	 		 				lyricArr.push({time:msel,lyric:item_im[item_len-1]});
	 		 			}
	 		 			else if(item_len==1)
	 		 			{
	 		 				lyricArr.push("\r");
	 		 			}
	 		 		}
	 		 	}
			}
	 		
	 		timeArr.sort(Array.NUMERIC);
			var arrContent:Array = new Array();
			var tLen:Number=timeArr.length;
			for (var _i:int= 0; _i<tLen; _i++) 
			{
				for(var _j:int=0;_j<lyricArr.length;_j++)
				{
					if(lyricArr[_j]["time"]==timeArr[_i])
					{
						trace(lyricArr[_j]["time"]+":"+lyricArr[_j]["lyric"]);
						arrContent.push(lyricArr[_j]["lyric"]);
					}
				}
			}
			lyricObject.contents = arrContent;
			lyricObject.times = timeArr;
			
			return lyricObject;
	 	}
	 		
	 	public static function getRuleFileName(title:String,artist:String):String
	 	{
	 		return title + "_-_" + artist + ".lrc";
	 	}	
		
	}
}