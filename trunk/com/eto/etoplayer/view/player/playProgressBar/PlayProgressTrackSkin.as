package com.eto.etoplayer.view.player.playProgressBar 
{
	import com.eto.etoplayer.interfaces.ISkin;
	
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.Matrix;

	public class PlayProgressTrackSkin extends Shape implements ISkin
	{
		public function PlayProgressTrackSkin()
		{
			super();
		}
		
		public function updateDisplayList(w:Number,h:Number):void
		{
			graphics.clear();
			
			/* graphics.beginFill(0x4b5467,1);
			graphics.drawRoundRect(-100,-100,500,500,0);
			graphics.endFill(); */
			/*graphic border of track*/
			
			var colors:Array = [0x5c657e,0x5c667f];
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(w, h, Math.PI/2, 0, 0);
			
			graphics.beginGradientFill(GradientType.LINEAR,colors,[1,1],[0,255],matrix);
			graphics.drawRoundRect(0,0,w,h,0);
			graphics.endFill();
			
			/*graphic middle of track0x5c657e*/
		 	graphics.beginFill(0x444b5e,1);
			graphics.drawRoundRect(0,0,w,1,0);
			graphics.endFill(); 
			
			graphics.beginFill(0x656e86,1);
			graphics.drawRoundRect(0,h-1,w,1,0);
			graphics.endFill(); 
		}
	}
}