package com.eto.etoplayer.model
{
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.eto.etoplayer.core.SoundFacade;
	import com.eto.etoplayer.events.GetLyricListEvent;
	import com.eto.etoplayer.interfaces.IMediaFacade;
	import com.eto.etoplayer.interfaces.IModelInstance;
	import com.eto.etoplayer.interfaces.IPlayModel;
	import com.eto.etoplayer.interfaces.IPlayProgressBar;
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
			
			setMediaFacade(new SoundFacade());
		}
		
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
				_playListModel.addEventListener("selectedItemChange",setTitle);
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
		
		private function setTitle(event:Event):void
		{
			var item:MP3Info = _playListModel.selectedItem;
			_title = item.title + "(" +item.artist + ")";
			dispatchEvent(new Event("titleChange"));
		}
		
		//---------------------------------------------
		//		progressBar
		//---------------------------------------------
		
		private var progressBar:IPlayProgressBar;
		
		public function setProgressBar(bar:IPlayProgressBar):void
		{
			progressBar = bar;
		} 
		
		//---------------------------------------------
		//		event handler
		//---------------------------------------------
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
			
			var mp3InfoVO:MP3Info = playListModel.selectedItem;
			var getEvent:GetLyricListEvent = 
								new GetLyricListEvent(mp3InfoVO);
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
	}
}