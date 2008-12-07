package com.eto.etoplayer.core
{
import flash.filesystem.File;
import flash.net.FileFilter;

public class FileFiters
{
	public static function get mediaFileFiters():Array
	{
		var mp3filter:FileFilter = new FileFilter(
						"支持音乐格式(.mp3;.wmv)","*.mp3;*.MP3;*.wmv;*.WMV");
		return [mp3filter];
	}
	
	public static function isMediaFile(file:File):Boolean
	{
		var type:String = file.extension;
		if(file.isDirectory)
		{
			return false;
		}
		else if(type == "MP3"||type == "mp3"||type == "wmv")
		{
			return true;
		}
		return false;
	}
}
}