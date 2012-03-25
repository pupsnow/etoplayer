package com.eto.etoplayer.view.player
{
import com.adobe.cairngorm.control.CairngormEventDispatcher;
import com.eto.etoplayer.events.SoundPlayEvent;
import com.eto.etoplayer.interfaces.IPlayProgressBar;
import com.eto.etoplayer.interfaces.ISkin;
import com.eto.etoplayer.model.PlayModel;
import com.eto.etoplayer.view.player.playProgressBar.LoadSkin;
import com.eto.etoplayer.view.player.playProgressBar.PlayProgressSkin;
import com.eto.etoplayer.view.player.playProgressBar.PlayProgressTrackSkin;
import com.eto.etoplayer.vo.MP3Info;

import flash.display.Sprite;
import flash.events.MouseEvent;

import mx.core.UIComponent;

public class PlayProgressBar extends UIComponent implements IPlayProgressBar
{
	
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
	 */
	public function PlayProgressBar()
	{
		super();
		
		buttonMode = true;
		cacheAsBitmap = true;
		
		addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
	}
	
	//---------------------------------------------------
	//		Properties of view 
	//---------------------------------------------------
	
	/**
	 * @private 
	 * background skin of progressBar
	 */		
	private var _trackBar:PlayProgressTrackSkin;
	
	/**
	 * @private 
	 * skin of progress of load .
	 */
	private var _loadBar:LoadSkin;
	
	/**
	 * @private 
	 * skin of progress of play.
	 */
	private var _playBar:PlayProgressSkin;
	
	/**
	 * @private 
	 */
	private var thumbs:Sprite;
	
	//---------------------------------------------------
	//		Variable : progress data value
	//---------------------------------------------------
	
	/**
	 * @private 
	 */		
	private var _loadTotal:Number = 0;
	
	/**
	 * @private 
	 */
	private var _loadValue:Number = 0;
	
	/**
	 * @private 
	 */
	private var _playTotal:Number = 0;
	
	/**
	 * @private 
	 */
	private var _playValue:Number = 0;
	
	
	//---------------------------------------------------
	//		override
	//---------------------------------------------------
	
	/**
	 * @private 
	 */		
	override protected function createChildren():void
	{
		super.createChildren();
		
		if(!_trackBar)
		{
			_trackBar = new PlayProgressTrackSkin();
			addChild(_trackBar);
		}
		
		if(!_loadBar)
		{
			_loadBar = new LoadSkin();
			addChild(_loadBar);
		}
		
		if(!_playBar)
		{
			_playBar = new PlayProgressSkin();
			addChild(_playBar);
		}
		
		if(!this.thumbs)
		{
			thumbs = new Sprite();
			addChild(thumbs);
		}
	}
	
	/**
	 * @private 
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
	{
		super.updateDisplayList(unscaledWidth,unscaledHeight);
		
		_trackBar.updateDisplayList(unscaledWidth,unscaledHeight);
		
		setLoadProgress(_loadValue,_loadTotal);
		
		setPlayProgress(_playValue,_playTotal);
		//
	}
	
	/**
	 * 
	 * @param value
	 * @param total
	 * 
	 */		
	public function setLoadProgress(value:Number, total:Number):void
	{
		this._loadValue = value;
		this._loadTotal = total;
		
		_setProgress(_loadBar,value,total);
	}
	
	/**
	 * 
	 * @param value
	 * @param total
	 * 
	 */		
	public function setPlayProgress(value:Number, total:Number):void
	{
		this._playValue = value;
		this._playTotal = total;
		
		_setProgress(_playBar,value,total);
	}
	
	public function reset():void
	{
		setPlayProgress(0, 0)
	}
	/**
	 * @private 
	 */		
	private function _setProgress(skin:ISkin ,value:Number, total:Number):void
	{
		var progressWidth:int = int(value * this.width/total);
		skin.updateDisplayList(progressWidth,3);
	}
	
	/**
	 * @private 
	 */
	private function mouseDownHandler(event:MouseEvent):void
	{
		if(this._loadValue == 0 || this._playTotal == 0)
		{
			return;
		}

		if(mouseX > int(_loadValue * this.width/_loadTotal))
		{
			return;
		}
		
		_playBar.updateDisplayList(mouseX,3);
		
		var changepg:Number = mouseX * _playTotal / this.width;
		var playItem:MP3Info = PlayModel.getInstance().playItem;
		var playEvent:SoundPlayEvent = new SoundPlayEvent(playItem);
			playEvent.position = changepg;
		CairngormEventDispatcher.getInstance().dispatchEvent(playEvent);

	}
}
}