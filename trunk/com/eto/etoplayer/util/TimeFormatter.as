package com.eto.etoplayer.util
{
public class TimeFormatter
{
	public function TimeFormatter()
	{
	}
	
	public static function MSELToMMSS(msel:int,ignoreDecimal:Boolean = true):String
	{
		var minNum:int= int(msel/60000);//计算分钟
		
		var secoundNum:int = int(msel/1000)%60;
		
		return correctLength(minNum) + ":" + correctLength(secoundNum);
	}
	
	public static function lyricTimeToMSEL(time:String):int
	{
		var arrTime:Array = time.split(":");
		
		var min:int = int(arrTime[0]);
		var sec:Number = Number(arrTime[1]);
		
		var msel:int = (min*60 + sec)*1000;
		
		return msel;
	}
	
	public static function MSELToLyricTime(msel:int):String
	{
		
		var minNum:int= int(msel/60000);//计算分钟
		var secoundNum:Number = (msel/1000) %60;
		trace("msel:"+msel + "secoundNum:"+secoundNum);
		var minStr:String = correctLength(minNum);
		var scStr:String = "";
		if(secoundNum < 10)
		{
			scStr = "0" + secoundNum;
		}
		else
		{
			scStr = secoundNum.toString();
		}
		scStr = scStr.substr(0,5);
		return minStr + ":" + scStr;
	}
	
	/**
	 * @private
	 * Correcting "0" to "00"; 
	 */		
	public static function correctLength(num:int):String
	{
		var numStr:String = String(num);
		
		if(numStr.length == 1)
		{
			return "0" + numStr;
		}
		/* else if(numStr.length > 2)
		{
			return numStr.substr(0,2);
		} */
			
		return numStr;
	}
}
}