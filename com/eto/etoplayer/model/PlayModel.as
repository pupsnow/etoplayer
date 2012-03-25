package com.eto.etoplayer.model
{
import com.adobe.cairngorm.control.CairngormEventDispatcher;
import com.eto.etoplayer.core.ApplicationDispatcher;
import com.eto.etoplayer.core.SoundFacade;
import com.eto.etoplayer.data.UserConfig;
import com.eto.etoplayer.events.GetLyricFileEvent;
import com.eto.etoplayer.events.SoundPlayEvent;
import com.eto.etoplayer.events.dataEvents.ApplicationEvent;
import com.eto.etoplayer.interfaces.IMediaFacade;
import com.eto.etoplayer.interfaces.IModelInstance;
import com.eto.etoplayer.interfaces.IPlayModel;
import com.eto.etoplayer.interfaces.IPlayProgressBar;
import com.eto.etoplayer.states.PlayPattern;
import com.eto.etoplayer.util.Random;
import com.eto.etoplayer.vo.MP3Info;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.ProgressEvent;

/**
 *  Dispatched when the playState property changes.
 */
[Event(name="stateChange", type="flash.events.Event")]

/**
 *  Dispatched when the position of mediaFacade`s SoundChannel changes.
 */
[Event(name="positionChange", type="flash.events.Event")]

/**
 * 
 * @author Riyco
 * 
 */	
public class PlayModel extends EventDispatcher implements IModelInstance, IPlayModel
{
	public static const STATE_CHANGE:String = "stateChange";
	public static const POSITION_CHANGE:String = "positionChange";
	
	public function PlayModel()
	{
		super();
		
		var sf:SoundFacade = new SoundFacade();
		setMediaFacade(sf);
		volumeRead();
		appDispatcher.addEventListener(
							ApplicationEvent.USER_CONFIG_COMPLETE,volumeRead);
		
		
	}
	
	private function volumeRead(event:ApplicationEvent = null):void
	{
		trace("volumeRead");
		volume = Number(UserConfig.volume);
		
	}
	//--------------------------------------------------------------------------
	//
	//		variable
	//		
	//--------------------------------------------------------------------------
	
	private var appDispatcher:ApplicationDispatcher = 
											ApplicationDispatcher.getInstance();
	
	private var playURLChange:Boolean = true;
	
	//---------------------------------------------
	//		Instance
	//---------------------------------------------
	
	private static var _instance:PlayModel
	
	public static function getInstance():PlayModel
	{
		if(!_instance)
			_instance = new PlayModel();
		
		return _instance;
	}
	
	//---------------------------------------------
	//		mediaFacade
	//---------------------------------------------
	
	private var _mediaFacade:IMediaFacade;
	
	private function setMediaFacade(facade:IMediaFacade):void
	{
		_mediaFacade = facade;
		_mediaFacade.addEventListener(SoundFacade.PLAY_START,onPlayStart);
		_mediaFacade.addEventListener(ProgressEvent.PROGRESS,onLoadProress);
		_mediaFacade.addEventListener(SoundFacade.PLAY_PROGRESS,onPlayProgress);
		_mediaFacade.addEventListener(Event.SOUND_COMPLETE,onPlayComplete);
	}
	
	public function get mediaFacade():IMediaFacade
	{
		return _mediaFacade;
	}
	
	//---------------------------------------------
	//		lyric
	//---------------------------------------------
	
	private var _lyricModel:LyricModel
	
	public function get lyricModel():LyricModel
	{
		if(!_lyricModel)
		{
			_lyricModel = new LyricModel();
		}
		
		return _lyricModel;
	}
	
	//---------------------------------------------
	//		playlist
	//---------------------------------------------
	
	private var _playListModel:PlayListModel
	
	public function get playListModel():PlayListModel
	{
		if(!_playListModel)
		{
			_playListModel = new PlayListModel();
		}
		
		return _playListModel;
	}
	
	//---------------------------------------------
	//		title
	//---------------------------------------------
	
	private var _title:String = "";
	
	[Bindable(event="titleChange")]
	public function get title():String
	{
		return _title;
	}
	
	private function setTitle():void
	{
		var item:MP3Info = playItem;
		_title = titleFormat(item);
		
		dispatchEvent(new Event("titleChange"));
	}
	
	private function titleFormat(item:MP3Info):String
	{
		var __title:String = item.title;
		if(item.artist && item.artist != "")
		{
			__title += "(" +item.artist + ")";
		}
		return __title;
	}
	
	//------------------------------
	//		volume
	//------------------------------
	[Bindable(event="volumeChange")]
	public function get volume():Number
	{
		trace(mediaFacade.volume+"");
		return mediaFacade.volume;
	}
	
	public function set volume(vol:Number):void
	{
		trace("set:"+vol);
		mediaFacade.volume = vol;
		dispatchEvent(new Event("volumeChange"));
	}
	//------------------------------
	//	playItem
	//------------------------------
	
	private var _playItem:MP3Info
	
	[Bindable(event="playItemChange")]
	public function get playItem():MP3Info
	{
		return _playItem;
	}
	
	public function set playItem(item:MP3Info):void
	{
		if(item == _playItem)
		{
			return ;
		}
		
		_playItem = item;
		playURLChange = true;
		
		dispatchEvent(new Event("playItemChange"));
		
		setTitle();
	}
	
	//------------------------------
	//		progressBar
	//------------------------------
	
	private var progressBar:IPlayProgressBar;
	
	public function setProgressBar(bar:IPlayProgressBar):void
	{
		progressBar = bar;
	} 
	
	//--------------------------------------------------------------------------
	//
	//		public method
	//		
	//--------------------------------------------------------------------------
	
	/**
	 * 
	 * @param position
	 * 
	 */	
	public function play(position:int = 0):void
	{
		if(playURLChange)
		{
			mediaFacade.load(playItem.url);
		}
		else
		{
			mediaFacade.play(position)
		}
		
		playURLChange = false;
	}
	//--------------------------------------------------------------------------
	//
	//		event handler
	//		
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private function onPlayStart(event:Event):void
	{
		this.lyricModel.lyricData = null;
		
		if(progressBar)
		{
			progressBar.setPlayProgress(0,0);
		}
		
		//var mp3InfoVO:MP3Info = playItem;
		var getEvent:GetLyricFileEvent = 
							new GetLyricFileEvent(null,this.playItem);
		CairngormEventDispatcher.getInstance().dispatchEvent(getEvent);
	}
	 
	/**
	 * @private
	 */		
	private function onLoadProress(event:ProgressEvent):void
	{
		if(progressBar)
		{
			progressBar.setLoadProgress(event.bytesLoaded,event.bytesTotal);
		}
	}
	
	/**
	 * @private
	 */
	private function onPlayProgress(event:ProgressEvent):void
	{
		if(progressBar)
		{
			progressBar.setPlayProgress(event.bytesLoaded,event.bytesTotal);
		}
		
		if(lyricModel)
		{
			lyricModel.timePosition = event.bytesLoaded;
		}
	}
	
	private function onPlayComplete(event:Event):void
	{
		if(playListModel.dataProvider && playListModel.dataProvider.length ==0)
		{
			return ;
		}
		
		var index:int = -1;
		var pattern:String = UserConfig.playPattern;
		switch(pattern)
		{
			case PlayPattern.SINGLE : 
				 break;
				 
			case PlayPattern.SINGLE_ROUND : 
				 index = playListModel.selectedIndex;  
				 break;
				 
			case PlayPattern.ORDERLY : 
				 if(playListModel.selectedIndex+1 <= playListModel.dataProvider.length)
				 {
					 index = playListModel.selectedIndex + 1
				 }
			     break;
			     
			case PlayPattern.ORDERLY_ROUND :
				 if(playListModel.selectedIndex+1 < playListModel.dataProvider.length)
				 {
					 index = playListModel.selectedIndex + 1
				 }
				 else
				 {
				 	index = 0;
				 } 
				 trace(index);
				 break;
				 
			case PlayPattern.RANDOM : 
				 index = Random.range(playListModel.dataProvider.length -1,-1)
				 break;
		}
		if(index >= 0)
		{
			playNext(index)
		}
	}
	
	private function playNext(index:int):void
	{
		var item:Object = playListModel.dataProvider[index];
		playListModel.setSelectedItem(item,true);
		var mp3Info:MP3Info = new MP3Info(item);
		var event:SoundPlayEvent = new SoundPlayEvent(mp3Info);
		CairngormEventDispatcher.getInstance().dispatchEvent(event);
	}
}
}