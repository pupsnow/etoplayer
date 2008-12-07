package com.eto.etoplayer.util
{
	import flash.system.System;
	import flash.utils.ByteArray;
	
	public class CodePage
	{
		public function CodePage()
		{
		}
		
		public static function encodeUTF8(code:String):String
		{
			//System.useCodePage = true;
		 	if(code == null || code == "")
		 	{
		 		return "";
		 	}
   			var oriByteArr:ByteArray = new ByteArray();
  			oriByteArr.writeUTFBytes(code);
   			var tempByteArr : ByteArray = new ByteArray();
  			for (var i:int = 0; i<oriByteArr.length; i++) 
  		    {
   			    if (oriByteArr[i] == 194) 
   			    {
     				tempByteArr.writeByte(oriByteArr[i+1]);
     				i++;
   				} 
   				else if (oriByteArr[i] == 195) 
   				{
    				tempByteArr.writeByte(oriByteArr[i+1] + 64);
     				i++;
    			}
    			else 
    			{
     				tempByteArr.writeByte(oriByteArr[i]);
    			}
   			}
   			tempByteArr.position = 0;
   			var str:String = tempByteArr.readMultiByte(tempByteArr.bytesAvailable,"gb2312");
   			//System.useCodePage = false;
   			return str;
 		}
 		
 		public static function toUTF(source:String):String
 		{ 
			var target:String = ""; 
			for(var i:int = 0;i<source.length;i++)
			{ 
				target+=codeTohex(source.charCodeAt(i)); 
			} 

			System.useCodePage=true; 
			target=unescape(target); 
			System.useCodePage=false; 
			return target; 
		} 
			
		private static function codeTohex(code:Number):String
		{ 
			var low:Number=code%16; 
			var high:Number=(code-low)/16; 
			return "%"+hex(high)+hex(low); 
		} 
		
		private static function hex(code:Number):String
		{ 
			switch(code)
			{ 
				case 10: 
					return "A"; 
					break; 
				case 11: 
					return "B"; 
					break; 
				case 12: 
					return "C"; 
					break; 
				case 13: 
					return "D"; 
					break; 
				case 14: 
					return "E"; 
					break; 
				case 15: 
					return "F"; 
					break; 
				default: 
					return String(code); 
					break; 
			} 
		}
	}
}