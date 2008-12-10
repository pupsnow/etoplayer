package com.eto.etoplayer.core
{
	import flash.filesystem.File;
	
	public class LocalFilePath
	{
		public function LocalFilePath()
		{
		}
		
		public static function get favoritesPath():String
		{
			var path:String = userSetingPath + File.separator +"Favorites.xml";
			return path;
		}
		
		public static function get userSetingPath():String
		{
			var storageDirectory:File = File.applicationStorageDirectory;
			
			var path:String = storageDirectory.resolvePath("\user").nativePath;
			
			storageDirectory = null;
			
			return path;
		}
		
		public static function get lyricFolder():String
		{
			var storageDirectory:File = File.applicationStorageDirectory;
			
			var path:String = storageDirectory.resolvePath("\lyrics").nativePath;
			
			storageDirectory = null;
			
			return path;
		}
		
		public static function get userConfig():String
		{
			var path:String = userSetingPath + File.separator +"UserConfig.xml";
			return path;
			
		}
	}
}