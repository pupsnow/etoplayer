package com.eto.etoplayer.util
{
	public class TimeFormatter
	{
		public function TimeFormatter()
		{
		}
		
		public static function MSELToMMSS(num:int):String
		{
			var minNum:int= int(num/60000);//计算分钟
			
			var secoundNum:int = int(num/1000)%60;
			
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
		
		/**
		 * @private
		 * Correcting "0" to "00"; 
		 */		
		private static function correctLength(num:int):String
		{
			var numStr:String = String(num);
			
			if(numStr.length == 1)
				return "0" + numStr;
				
			return numStr;
		}
	}
}