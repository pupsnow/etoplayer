package com.eto.etoplayer.view.lyric
{
import com.adobe.cairngorm.control.CairngormEventDispatcher;
import com.eto.etoplayer.events.GetLyricListEvent;
import com.eto.etoplayer.events.viewEvents.AdjustByMouseEvent;
import com.eto.etoplayer.interfaces.IDispose;
import com.eto.etoplayer.model.PlayModel;
import com.eto.etoplayer.vo.MP3Info;

import flash.desktop.Clipboard;
import flash.desktop.ClipboardFormats;
import flash.display.NativeMenu;
import flash.display.NativeMenuItem;
import flash.events.Event;

import mx.controls.Alert;

[Event(name="adjustByMouse", type="com.eto.etoplayer.events.viewEvents.AdjustByMouseEvent")]
public class lyricContextMenu extends NativeMenu implements IDispose
{
	[Embed(source="images/kewu.png")]
    public var kewu:Class;
    
	public function lyricContextMenu(lyricSprite:LyricShow)
	{
		super();
		
		this.lyricSprite = lyricSprite;
		
		createChildren();
	}
	//--------------------------------------------------------------------------
	//
	//		vareable
	//
	//--------------------------------------------------------------------------
	private var lyricSprite:LyricShow
	
	//--------------------------------------------------------------------------
	//
	//		component
	//
	//--------------------------------------------------------------------------
	
	//------------------------------
	//	 main menus
	//------------------------------
	private var researchMenu:NativeMenuItem;
	private var adjustLyricMenu:NativeMenuItem 
	private var copyLyricMenu:NativeMenuItem;
	
	//------------------------------
	//	adjustLyricMenu`s sub menus
	//------------------------------
	private var aheahCurrent:NativeMenuItem;
	private var delayedCurrent:NativeMenuItem;
	private var aheahNext:NativeMenuItem;
	private var delayedNext:NativeMenuItem;
	private var aheahAll:NativeMenuItem;
	private var delayedAll:NativeMenuItem;
	private var adjustByMouse:NativeMenuItem;
	private var fullscreenMenu:NativeMenuItem;
	//--------------------------------------------------------------------------
	//
	//		create methods
	//
	//--------------------------------------------------------------------------
	
	private function createChildren():void
	{
		createContextMenu();
		addMenuEventListener();
	}
	
	private function createContextMenu():void
	{
		researchMenu = new NativeMenuItem("在线搜索");
		adjustLyricMenu = new NativeMenuItem("歌词调整");
		copyLyricMenu = new NativeMenuItem("复制歌词");
		fullscreenMenu = new NativeMenuItem("这个点了没什么用");
		adjustLyricMenu.submenu = createAdjustlyricSubMenu();
		
		this.addItem(researchMenu);
		this.addItem(new NativeMenuItem("-",true));
		this.addItem(adjustLyricMenu);
		this.addItem(copyLyricMenu);
		this.addItem(new NativeMenuItem("-",true));
		this.addItem(fullscreenMenu);
	}
	
	private function createAdjustlyricSubMenu():NativeMenu
	{
		var subMenu:NativeMenu = new NativeMenu();
		
		aheahCurrent = new NativeMenuItem("本句提前0.5秒");
		delayedCurrent = new NativeMenuItem("本句延后0.5秒");
		aheahNext = new NativeMenuItem("下句提前0.5秒");
		delayedNext = new NativeMenuItem("下句延后0.5秒");
		aheahAll = new NativeMenuItem("全部提前0.5秒");
		delayedAll = new NativeMenuItem("全部延后0.5秒");
		adjustByMouse = new NativeMenuItem("鼠标滚轮调整");
		
		subMenu.addItem(aheahCurrent);
		subMenu.addItem(delayedCurrent);
		subMenu.addItem(aheahNext);
		subMenu.addItem(delayedNext);
		subMenu.addItem(aheahAll);
		subMenu.addItem(delayedAll);
		subMenu.addItem(new NativeMenuItem("-",true));
		subMenu.addItem(adjustByMouse);
		
		return subMenu;
	}
	
	//--------------------------------------------------------------------------
	//
	//		Event listener
	//
	//--------------------------------------------------------------------------
	private function addMenuEventListener():void
	{
		//main menus
		fullscreenMenu.addEventListener(Event.SELECT,fullscreenDisplay);
		researchMenu.addEventListener(Event.SELECT,researchLyricFile);
		copyLyricMenu.addEventListener(Event.SELECT,copyLyricSelectedHandler);
		
		//adjustLyricMenu`s sub menus
		aheahCurrent.addEventListener(Event.SELECT,aheahCurrentSelectedHandler);
		delayedCurrent.addEventListener(
									Event.SELECT,delayedCurrentSelectedHandler);
		aheahNext.addEventListener(Event.SELECT,aheahNextSelectedHandler);
		delayedNext.addEventListener(Event.SELECT,delayedNextSelectedHandler);
		aheahAll.addEventListener(Event.SELECT,aheahAllSelectedHandler);
		delayedAll.addEventListener(Event.SELECT,delayedAllSelectedHandler);
		adjustByMouse.addEventListener(
									Event.SELECT,adjustByMouseSelectedHandler);
	}
	
	private function removeMenuEventListener():void
	{
		researchMenu.removeEventListener(Event.SELECT,researchLyricFile);
		copyLyricMenu.removeEventListener(
									Event.SELECT,copyLyricSelectedHandler);
		fullscreenMenu.removeEventListener(Event.SELECT,fullscreenDisplay);
		//adjustLyricMenu`s sub menus
		aheahCurrent.removeEventListener(
									Event.SELECT,aheahCurrentSelectedHandler);
		delayedCurrent.removeEventListener(
									Event.SELECT,delayedCurrentSelectedHandler);
		aheahNext.removeEventListener(Event.SELECT,aheahNextSelectedHandler);
		delayedNext.removeEventListener(
									Event.SELECT,delayedNextSelectedHandler);
		aheahAll.removeEventListener(Event.SELECT,aheahAllSelectedHandler);
		delayedAll.removeEventListener(Event.SELECT,delayedAllSelectedHandler);
		adjustByMouse.removeEventListener(
									Event.SELECT,adjustByMouseSelectedHandler);
	}
	
	//--------------------------------------------------------------------------
	//
	//		Event handler
	//
	//--------------------------------------------------------------------------
	
	private function researchLyricFile(event:Event):void
	{
		var item:Object = PlayModel.getInstance().playListModel.selectedItem;
		var mp3Vo:MP3Info = new MP3Info(item);
		var getEvent:GetLyricListEvent = new GetLyricListEvent(mp3Vo);
		CairngormEventDispatcher.getInstance().dispatchEvent(getEvent);//event.
	}
	
	private function copyLyricSelectedHandler(event:Event):void
	{
		var lyricText:String = ""; 
		for(var i:int=0;i<lyricSprite.lyricData.contents.length;i++)
		{
			lyricText += lyricSprite.lyricData.contents[i] + "\r\n";
		}
		Clipboard.generalClipboard.clear();
		Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,lyricText)
	}
	
	private function aheahCurrentSelectedHandler(event:Event):void
	{
		adjuestLyricStepPosition(-500,lyricSprite.step);
	}
	
	private function delayedCurrentSelectedHandler(event:Event):void
	{
		adjuestLyricStepPosition(500,lyricSprite.step);
	}
	
	private function aheahNextSelectedHandler(event:Event):void
	{
		adjuestLyricStepPosition(-500,lyricSprite.step+1);
	}
	
	private function delayedNextSelectedHandler(event:Event):void
	{
		adjuestLyricStepPosition(500,lyricSprite.step+1);
	}
	
	private function aheahAllSelectedHandler(event:Event):void
	{
		adjuestLyricAllPosition(-500);
	}
	
	private function delayedAllSelectedHandler(event:Event):void
	{
		adjuestLyricAllPosition(500)
	}
	
	private function adjustByMouseSelectedHandler(event:Event):void
	{
		this.adjustByMouse.checked = !this.adjustByMouse.checked;
		this.dispatchEvent(new AdjustByMouseEvent(this.adjustByMouse.checked));
	}
	
	private function fullscreenDisplay(event:Event):void
	{
		mx.controls.Alert.show("你好，愚蠢的人类!","事到如今你依然愚蠢",4,null,null,kewu);
	}
	//--------------------------------------------------------------------------
	//
	//		other
	//
	//--------------------------------------------------------------------------
	private function adjuestLyricStepPosition(value:int,step:int):void
	{
		lyricSprite.adjuestLyricStepPosition(value,step);
	}
	
	private function adjuestLyricAllPosition(value:int):void
	{
		lyricSprite.adjuestLyricAllPosition(value);
	}
	
	public function dispose():void
	{
		this.removeMenuEventListener();
		// main menu
		researchMenu = null;
		adjustLyricMenu = null;
		copyLyricMenu = null;
		//adjustLyricMenu`s sub menus
		aheahCurrent = null;
		delayedCurrent = null;
		aheahNext = null;
		delayedNext = null;
		aheahAll = null;
		delayedAll = null;
		adjustByMouse = null;
		fullscreenMenu = null;
	}
}
}