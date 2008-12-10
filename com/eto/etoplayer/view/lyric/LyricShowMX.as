package com.eto.etoplayer.view.lyric
{
import com.adobe.cairngorm.control.CairngormEventDispatcher;
import com.eto.etoplayer.events.ClipboardToPlayListEvent;
import com.eto.etoplayer.events.GetLyricListEvent;
import com.eto.etoplayer.events.SoundPlayEvent;
import com.eto.etoplayer.interfaces.IMediaFacade;
import com.eto.etoplayer.model.PlayModel;
import com.eto.etoplayer.vo.MP3Info;

import flash.desktop.Clipboard;
import flash.desktop.NativeDragManager;
import flash.display.NativeMenu;
import flash.display.NativeMenuItem;
import flash.events.Event;
import flash.events.NativeDragEvent;

import mx.controls.Alert;
import mx.core.UIComponent;

public class LyricShowMX extends UIComponent
{
	[Embed(source="images/kewu.png")]
    public var kewu:Class;
    
	private var lyricSprite:LyricShow ;
	//private var mainMenu:NativeMenu;
	
	public function LyricShowMX()
	{
		super();
		
		addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,
											NativeDragEnterHandler);
		addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,
											NativeDragDropHandler);
	}
	
	public function set contextMenuEnable(bln:Boolean):void
	{
		if(bln)
		{
			createContextMenu();
		}
		else
		{
			removeContextMenu();
		}
	}
	
	public function set lyricData(data:LyricData):void
	{
		lyricSprite.lyricData = data;
	}
	
	public function set timePosition(position:Number):void
	{
		//trace("mx"+position);
		lyricSprite.setPosition(position);
	}
	
	override protected function createChildren():void
	{
		super.createChildren();
		
		lyricSprite = new LyricShow();
		lyricSprite.addEventListener(PositionChangeEvent.POSITION_CHANGE,positionChange);
		addChild(lyricSprite);
	}
	
	override protected function commitProperties():void
	{
		super.commitProperties();
		
		lyricSprite.commitProperties();	
	}
	
	override protected function measure():void
	{
		super.measure();
		
		lyricSprite.measure();
	}
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
	{
		super.updateDisplayList(unscaledWidth,unscaledHeight);
		
		lyricSprite.updateDisplayList(unscaledWidth,unscaledHeight);
	}
	
	private function createContextMenu():void
	{
		var mainMenu:NativeMenu = new NativeMenu();
		
		var researchMenu:NativeMenuItem = new NativeMenuItem("在线搜索");
		
		var fullscreenMenu:NativeMenuItem = new NativeMenuItem("这个点了没什么用");
		fullscreenMenu.addEventListener(Event.SELECT,fullscreenDisplay);
		researchMenu.addEventListener(Event.SELECT,researchLyricFile);

		mainMenu.addItem(researchMenu);
		mainMenu.addItem(fullscreenMenu);
		
		this.contextMenu = mainMenu;
	}
	
	private function removeContextMenu():void
	{
		this.contextMenu = null;
	}
	
	private function NativeDragEnterHandler(event:NativeDragEvent):void
	{
		NativeDragManager.acceptDragDrop(this);
	}
	private function NativeDragDropHandler(event:NativeDragEvent):void
	{
		var clipboard:Clipboard =  event.clipboard;
		var addEvent:ClipboardToPlayListEvent = 
									new ClipboardToPlayListEvent(clipboard,true);
		CairngormEventDispatcher.getInstance().dispatchEvent(addEvent);
	}
	
	private function positionChange(event:PositionChangeEvent):void
	{
		var mediaFacade:IMediaFacade = PlayModel.getInstance().mediaFacade;
		
		var playEvent:SoundPlayEvent = new SoundPlayEvent(mediaFacade.url);
		playEvent.position = event.newPosition;
		CairngormEventDispatcher.getInstance().dispatchEvent(playEvent);
	}
	
	private function researchLyricFile(event:Event):void
	{
		var item:Object = PlayModel.getInstance().playListModel.selectedItem;
		var mp3Vo:MP3Info = new MP3Info(item);
		var getEvent:GetLyricListEvent = new GetLyricListEvent(mp3Vo,true);
		CairngormEventDispatcher.getInstance().dispatchEvent(getEvent);//event.
	}
	
	private function fullscreenDisplay(event:Event):void
	{
		mx.controls.Alert.show("给你说了没用你还点!!!!","愚蠢的人类啊",4,null,null,kewu);
	}
}
}