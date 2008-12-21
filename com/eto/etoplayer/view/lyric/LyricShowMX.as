package com.eto.etoplayer.view.lyric
{
import com.adobe.cairngorm.control.CairngormEventDispatcher;
import com.eto.etoplayer.events.ClipboardToPlayListEvent;
import com.eto.etoplayer.events.GetLyricListEvent;
import com.eto.etoplayer.events.SoundPlayEvent;
import com.eto.etoplayer.events.modelEvents.LyricListResultEvent;
import com.eto.etoplayer.model.LyricModel;
import com.eto.etoplayer.model.PlayModel;
import com.eto.etoplayer.states.LyricLoadState;
import com.eto.etoplayer.util.LyricUtil;
import com.eto.etoplayer.vo.MP3Info;
import com.eto.etoplayer.vo.lyric.lyricListResultVo;

import flash.desktop.Clipboard;
import flash.desktop.ClipboardFormats;
import flash.desktop.NativeDragManager;
import flash.display.NativeMenu;
import flash.display.NativeMenuItem;
import flash.events.Event;
import flash.events.NativeDragEvent;

import mx.controls.Alert;
import mx.controls.ProgressBar;
import mx.core.UIComponent;
import mx.managers.PopUpManager;

public class LyricShowMX extends UIComponent
{
	[Embed(source="images/kewu.png")]
    public var kewu:Class;
    
	private var lyricSprite:LyricShow ;
	
	private var _currentState:String;
	
	private var lyricModel:LyricModel; 
	public function LyricShowMX()
	{
		super();
		
		lyricModel = PlayModel.getInstance().lyricModel;
		lyricModel.addEventListener(
				   LyricListResultEvent.LYRIC_LIST_RESULT,popUplyricChooseView);
								
		addEventListener(
					NativeDragEvent.NATIVE_DRAG_ENTER,NativeDragEnterHandler);
		addEventListener(
					NativeDragEvent.NATIVE_DRAG_DROP,NativeDragDropHandler);
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
	
	override public function set currentState(value:String):void
	{
		_currentState = value;
		
		switch(value)
		{
			case LyricLoadState.LISTLOADING : 
					showLoadingView("正在查询歌词列表");
					break;
			case LyricLoadState.LYRICLOADING : 
					showLoadingView("正在获取歌词文件");
					break;
			case LyricLoadState.LOADCOMPLETE : 
					hideLoadingView();
					break;
			default : break;
		}
	}
	
	private var loadingView:ProgressBar;
	private function showLoadingView(label:String):void
	{
		if(!loadingView)
		{
			loadingView = new ProgressBar();
			loadingView.indeterminate = true;
			loadingView.width = 120
			loadingView.x = this.width/2 - 60;
			loadingView.y = this.height/2 - 10;
			this.addChild(loadingView);
		}
		loadingView.label = label
	}
	
	private function hideLoadingView():void
	{
		if(loadingView)
		{
			this.removeChild(loadingView);
			loadingView = null;
		}
	}
	
	private var lyricChooseView:lyricLoadChoose = new lyricLoadChoose();
	
	private function popUplyricChooseView(event:LyricListResultEvent):void
	{
		//
		if(!lyricChooseView.isPopUp)
		{
			/* lyricChooseView.addEventListener(
										CloseEvent.CLOSE,removeLyricChooseView); */
			
 			PopUpManager.addPopUp(lyricChooseView,root,true);
 			PopUpManager.centerPopUp(lyricChooseView);
 		}
 		var lyricModel:LyricModel = PlayModel.getInstance().lyricModel;
 		var vo:lyricListResultVo = lyricModel.lyricListResult;
 		lyricChooseView.setData(vo.lyricList,vo.mp3Info);
	}
	
	/* private function removeLyricChooseView(event:CloseEvent):void
	{
		lyricChooseView.removeEventListener(
										CloseEvent.CLOSE,removeLyricChooseView);
		//lyricChooseView = null;
		//delete lyricChooseView;
	} */
	private function createContextMenu():void
	{
		var mainMenu:NativeMenu = new NativeMenu();
		
		var researchMenu:NativeMenuItem = new NativeMenuItem("在线搜索");
		var adjustLyricMenu:NativeMenuItem = new NativeMenuItem("歌词调整");
		var copyLyricMenu:NativeMenuItem = new NativeMenuItem("复制歌词");
		adjustLyricMenu.submenu = createAdjustlyricSubMenu();
		//adjust lyric subMenu
		/* var adjustlyricSubMenu:NativeMenu = new NativeMenu();
		var aheahCurrentMenuItem:NativeMenuItem = new NativeMenuItem("本句提前0.5秒");
		var delayedCurrentMI:NativeMenuItem = new NativeMenuItem("本句延后0.5秒");
		adjustlyricSubMenu */
		var fullscreenMenu:NativeMenuItem = new NativeMenuItem("这个点了没什么用");
		
		
		fullscreenMenu.addEventListener(Event.SELECT,fullscreenDisplay);
		researchMenu.addEventListener(Event.SELECT,researchLyricFile);
		copyLyricMenu.addEventListener(Event.SELECT,copyLyricSelectedHandler);
		mainMenu.addItem(researchMenu);
		mainMenu.addItem(adjustLyricMenu);
		mainMenu.addItem(copyLyricMenu);
		mainMenu.addItem(new NativeMenuItem("啊",true));
		mainMenu.addItem(fullscreenMenu);
		
		this.contextMenu = mainMenu;
	}
	
	private function createAdjustlyricSubMenu():NativeMenu
	{
		var subMenu:NativeMenu = new NativeMenu();
		var aheahCurrent:NativeMenuItem = new NativeMenuItem("本句提前0.5秒");
		var delayedCurrent:NativeMenuItem = new NativeMenuItem("本句延后0.5秒");
		aheahCurrent.addEventListener(Event.SELECT,aheahCurrentSelectedHandler);
		subMenu.addItem(aheahCurrent);
		subMenu.addItem(delayedCurrent);
		return subMenu;
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
		var item:MP3Info = PlayModel.getInstance().playItem
		
		var playEvent:SoundPlayEvent = new SoundPlayEvent(item);
		playEvent.position = event.newPosition;
		CairngormEventDispatcher.getInstance().dispatchEvent(playEvent);
	}
	
	private function researchLyricFile(event:Event):void
	{
		var item:Object = PlayModel.getInstance().playListModel.selectedItem;
		var mp3Vo:MP3Info = new MP3Info(item);
		var getEvent:GetLyricListEvent = new GetLyricListEvent(mp3Vo);
		CairngormEventDispatcher.getInstance().dispatchEvent(getEvent);//event.
	}
	
	private function copyLyricSelectedHandler(event:Event):void
	{
		//var reg:RegExp = /\\n/g; 直接读取text还有问题 靠
		//var lyricText:String = lyricSprite.text.replace(reg,"");
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
		lyricSprite.adjuestLyricStepPosition(-500,lyricSprite.step);
		var aaa:String = LyricUtil.restoreFileText(lyricSprite.lyricData)
		trace(aaa);
	}
	private function fullscreenDisplay(event:Event):void
	{
		mx.controls.Alert.show("给你说了没用你还点!!!!","愚蠢的人类啊",4,null,null,kewu);
	}
}
}