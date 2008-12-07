package com.eto.etoplayer.view.player.playProgressBar
{
	import com.eto.etoplayer.interfaces.ISkin;
	
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.Matrix;
	
	/**
	 * 
	 * @author riyco
	 * 
	 */	
	public class PlayProgressSkin extends Shape implements ISkin
	{
		public function PlayProgressSkin()
		{
			super();
		}
		
		public function updateDisplayList(w:Number, h:Number):void
		{
			graphics.clear();
			
			/*graphic border of progress 0x5c657e*/
		 	graphics.beginFill(0x7fa2ff,1);
			graphics.drawRoundRect(1,1,w,3,0);
			graphics.endFill(); 
			
			/*graphic middle of progress*/
			graphics.beginFill(0x0f41cd,1);
			graphics.drawRoundRect(1,2,w,1,0);
			graphics.endFill(); 
			
			/*graphic highlist of progress*/
			var colors:Array = [0xefefef,0xffffff];
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(w, h, 0, 10, 0); 
			
			graphics.beginGradientFill(GradientType.LINEAR,colors,[0.1,0.5],[0,255],matrix);
			graphics.drawRoundRect(1,1,w,3,0);
			graphics.endFill();
		}
		
	}
}