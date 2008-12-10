package com.eto.etoplayer.filesystem
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	public class TextFile
	{
		private var textFile:File;
		
		private var files:FileStream;
		
		public function TextFile(path:String)
		{
			textFile = new File(path);
		}
		
		public function read():String
		{
			var stream:FileStream = new FileStream();
			if(!textFile.exists)
			{
				return null;
			}
			
			stream.open(textFile,FileMode.READ);
			var text:String = stream.readMultiByte(stream.bytesAvailable,File.systemCharset);
			return text;
		}
		
		public function append(appendText:String):void
		{
			var stream:FileStream = new FileStream();
			stream.open(textFile,FileMode.APPEND);
			stream.writeMultiByte(appendText,File.systemCharset);
			stream.close();	
		}
		
		public function write(text:String):void
		{
			var stream:FileStream = new FileStream();
			stream.open(textFile,FileMode.WRITE);
			stream.writeMultiByte(text,File.systemCharset);
			stream.close();
		}
		
		public function update(oldText:*,newText:*):void
		{
			if(oldText is String)
			{
				updateString(oldText,newText)
			}
			if(oldText is Array)
			{
				
			}
			else if(oldText is XMLList)
			{
				updateString(oldText,newText);
			}
		}
		
		private function updateString(oldString:String,newString:String):void
		{
			
		}
		
		private function updateXML(oldXMLList:XMLList,newXMLList:XMLList):void
		{
			
		}
	}
}