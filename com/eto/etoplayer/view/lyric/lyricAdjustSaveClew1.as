package com.eto.etoplayer.view.lyric
{
import com.eto.etoplayer.interfaces.IDispose;

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;

public class lyricAdjustSaveClew1 extends Sprite implements IDispose
{
	public function lyricAdjustSaveClew1()
	{
		super();
	}
	
	private var clewText:TextField 
	
	private function createChildren():void
	{
		clewText = new TextField();
		clewText.x = 20;
		clewText.width = 100;
		clewText.defaultTextFormat = clewTextFormat();
		clewText.text = "单击此处保存调整后的内容";
		addChild(clewText);
		
	}
	
	private function commitProperty():void
	{
		
	}
	
	private function measure():void
	{
	
	}
	
	private function updateDisplayList(unScaleWidth:Number,unScaleHight:Number):void
	{
		
	}
	
	private function setStyle():void
	{
		
	}
	
	private function clewTextFormat():TextFormat
	{
		var tf:TextFormat = new TextFormat();
		tf.color = 0xff7a31;
		return tf;
	}
	
	private function commitProperty():void
	{
			
	}
	public function dispose():void
	{
	}
	
}
}