package com.eto.etoplayer.view.player.playProgressBar
{
	import com.eto.etoplayer.interfaces.ISkin;
	
	import flash.display.Shape;

	public class LoadSkin extends Shape implements ISkin
	{
		public function LoadSkin()
		{
			super();
		}
		
		public function updateDisplayList(w:Number, h:Number):void
		{//0x444b5e
			graphics.clear();
			graphics.beginFill(0x5e76b5,1);
			
			//临时加的。
			var num:Number = w-2;
			if(num<0)
				num = 0;
				
			graphics.drawRoundRect(1,1,num,h,0);
			graphics.endFill(); 
		}
	}
}