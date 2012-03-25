package com.eto.etoplayer.view.lyric
{
import caurina.transitions.Tweener;

import com.adobe.cairngorm.control.CairngormEventDispatcher;
import com.eto.etoplayer.events.ClipboardToPlayListEvent;
import com.eto.etoplayer.events.SaveLyricFileEvent;
import com.eto.etoplayer.events.SoundPlayEvent;
import com.eto.etoplayer.events.modelEvents.LyricListResultEvent;
import com.eto.etoplayer.events.viewEvents.AdjustByMouseEvent;
import com.eto.etoplayer.model.LyricModel;
import com.eto.etoplayer.model.PlayModel;
import com.eto.etoplayer.states.LyricLoadState;
import com.eto.etoplayer.vo.MP3Info;
import com.eto.etoplayer.vo.lyric.lyricListResultVo;

import flash.desktop.Clipboard;
import flash.desktop.NativeDragManager;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.NativeDragEvent;

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
	
	private var adjustByMouseWheel:Boolean = false;
	
	private var saveClew:lyricAdjustSaveClew;
	
	private var uiMask:Sprite;
	
	public function LyricShowMX()
	{
		super();
		
		lyricModel = PlayModel.getInstance().lyricModel;
		lyricModel.addEventListener(
				   LyricListResultEvent.LYRIC_LIST_RESULT,popUplyricChooseView);
		lyricModel.addEventListener("lyricFileChanged",lyricFileChangedHandler);						
		addEventListener(
					NativeDragEvent.NATIVE_DRAG_ENTER,NativeDragEnterHandler);
		addEventListener(
					NativeDragEvent.NATIVE_DRAG_DROP,NativeDragDropHandler);
					
		addEventListener(MouseEvent.MOUSE_WHEEL,mouseWheelHandler);
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
		lyricSprite.addEventListener("lyrciDataEdited",lyrciDataEditedHandler);
		addChild(lyricSprite);
		
		saveClew = new lyricAdjustSaveClew();
		saveClew.addEventListener("saveButtonClick",saveButtonClickHandler);
		addChild(saveClew);
		//saveClew.invalidateDisplayList();
		saveClew.x = 1;
		saveClew.y = -30;
		
		uiMask = new Sprite();
		this.addChild(uiMask);
		this.mask = uiMask;
		
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
		saveClew.width = unscaledWidth;
		lyricSprite.updateDisplayList(unscaledWidth,unscaledHeight);
		
		var g:Graphics = uiMask.graphics;
		g.clear();
		g.beginFill(0x000000,1);
		g.drawRect(0,0,unscaledWidth,unscaledHeight);
		g.endFill();
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
	
	private function createContextMenu():void
	{
		this.contextMenu = new lyricContextMenu(this.lyricSprite);
		lyricContextMenu(this.contextMenu).addEventListener(
					AdjustByMouseEvent.ADJUST_BY_MOUSE,adjustByMouseEventHadler)
	}
	
	private function removeContextMenu():void
	{
		lyricContextMenu(this.contextMenu).dispose();
		this.contextMenu = null;
	}
	
	private function adjustByMouseEventHadler(event:AdjustByMouseEvent):void
	{
		this.adjustByMouseWheel = event.checked;
		
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
	
	private function mouseWheelHandler(event:MouseEvent):void
	{
		if(adjustByMouseWheel)
		{
			var num:int = int(-event.delta/3);
			lyricSprite.adjuestLyricAllPosition(num * 500);
		}
	}
	//private var saveClewShowed:Boolean = false;
	
	private function lyrciDataEditedHandler(event:Event):void
	{
		PlayModel.getInstance().lyricModel.lyricFileChange = true;
	}
	
	private function saveButtonClickHandler(e:Event):void
	{
		var event:SaveLyricFileEvent = 
						new SaveLyricFileEvent(lyricSprite.lyricData,
											PlayModel.getInstance().playItem);
		CairngormEventDispatcher.getInstance().dispatchEvent(event);
	}
	private function lyricFileChangedHandler(event:Event):void
	{
		var changed:Boolean = PlayModel.getInstance().lyricModel.lyricFileChange;
		if(changed)
		{
			showSaveClew();
		}
		else
		{
			hideSaveClew();
		}
	}
	
	private function positionChange(event:PositionChangeEvent):void
	{
		var item:MP3Info = PlayModel.getInstance().playItem
		
		var playEvent:SoundPlayEvent = new SoundPlayEvent(item);
		playEvent.position = event.newPosition;
		CairngormEventDispatcher.getInstance().dispatchEvent(playEvent);
	}
	
	private function showSaveClew():void
	{
		//mx.controls.Alert.show("aaa");
		Tweener.addTween(this.saveClew,{y:2,time:1,transition:"easeOutElastic"});
	}
	
	private function hideSaveClew():void
	{
		Tweener.addTween(this.saveClew,{y:-30,time:1,transition:"easeInOutBack"});
	}
}
}