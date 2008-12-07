package com.eto.etoplayer.interfaces
{
	public interface IPlayProgressBar
	{
		function setLoadProgress(value:Number, total:Number):void
		
		function setPlayProgress(value:Number, total:Number):void
		
		function reset():void
	}
}