package com.eto.etoplayer.util
{
	public class TextUtil
	{
		public function TextUtil()
		{
		}
		
		public static function poundToPixel(pound:*):int
		{
			if(pound is Number)
			{
				var px:int = pound/72*96;
				return px;
			}
			
			return NaN;
		} 
	}
}