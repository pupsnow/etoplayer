package com.eto.etoplayer.core
{
import com.eto.etoplayer.interfaces.IMediaFacade;
import com.eto.etoplayer.states.PlayState;
import com.eto.etoplayer.util.TimeFormatter;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.events.TimerEvent;
import flash.media.ID3Info;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundLoaderContext;
import flash.media.SoundMixer;
import flash.media.SoundTransform;
import flash.net.URLRequest;
import flash.utils.Timer;

/**
 * Provides a slightly simpler interface to the sound-related classes in the 
 * flash.media package. Dispatches "playProgress" ProgressEvents and adds 
 * pause and resume functionality.
 * 
 * @author Riyco
 */      
public class SoundFacade extends EventDispatcher implements IMediaFacade
{
	//--------------------------------------------------------------------------
	//
	//			const
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Defines the "playProgress" event type.
	 */
	public static const PLAY_PROGRESS:String = "playProgress";
	
	/**
	 * Defines the "playStart" event type.
	 */
	public static const PLAY_START:String = "playStart";
	
	//--------------------------------------------------------------------------
	//
	//			Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	function SoundFacade(soundurl:String = null, autoLoad:Boolean = true, 
							autoPlay:Boolean = true, streaming:Boolean = true, 
							bufferTime:int = -1):void
	{
		// sets boolean values that determine the behavior of this object
	    this.autoLoad = autoLoad;
	    this.autoPlay = autoPlay;
	    this.isStreaming = streaming;
	    
	    // defaults to the global bufferTime value
	    if (bufferTime < 0)
	    {
	        bufferTime = SoundMixer.bufferTime;
	    }
        // keeps buffer time reasonable, between 0 and 30 seconds
	    this.bufferTime = Math.min(Math.max(0, bufferTime), 30);
	    
	    if(soundurl && autoLoad)
	    	load(soundurl);
	}
	
    //--------------------------------------------------------------------------
	//
	//				variable
	//
	//--------------------------------------------------------------------------
	
	/**
     * The Sound object used to load the sound file.
     */
	public var sound:Sound;
	
    /**
     * The SoundChannel object used to play and track playback progess
     * of the sound.
     */		
	private var channel:SoundChannel;
	
	/**
	 * The Timer that's used to update the progress display.
	 */
	private var playTimer:Timer;
	
	/**
	 * Identifies when the sound file has been fully loaded.
	 */
	private var isLoaded:Boolean = false;
	
	/**
	 * Identifies when the sound file has been fully loaded.
	 */
	private var isReadyToPlay:Boolean = false;
	
	/**
	 * Identifies when the sound file is being played.
	 */
	private var isPlaying:Boolean = false;
	
	/**
	 * Specifies that the sound file can be played while it is being loaded.
	 */
	private var isStreaming:Boolean = true;
	
	/**
	 * Indicates that sound loading should start as soon as this object is created.
	 */
	private var autoLoad:Boolean = true;
	
	/**
	 * Indicates that sound playing should start as soon as enough sound data has been loaded.
	 * If this is a streaming sound, playback will begin as soon as enough data, as specified
	 * by the bufferTime property, has been loaded.
	 */
	private var autoPlay:Boolean = true;
	
	/**
	 * Defines how often to dispatch the playback progress event.
	 */
	private var progressInterval:int = 500;
	
	//--------------------------------------------------------------------------
	//
	//					property
	//
	//--------------------------------------------------------------------------
	
	//------------------------------
	//		url
	//------------------------------
	
	/**
	 * @private
	 * The URL of the sound file to load.
	 */
	private var _url:String;
	
	/**
	 * Set URL of the sound file,load a new sound file. 
	 */
	private function set url(soundurl:String):void
	{
		_url = soundurl;
	}
	
	public function get url():String
	{
		return _url
	}
	
	//------------------------------
	//		volume
	//------------------------------
	
	private var _volume:Number = 0.8;
	
	public function get volume():Number
	{
		return _volume
	}
	
	public function set volume(vol:Number):void
	{
		_volume = vol;
		if(isPlaying)
		{
			setChannelVolume(vol)
		}
	}
	
	//------------------------------
	//		position
	//------------------------------
	
	/**
	 * @private
	 */
	private var _pausePosition:int = 0;
	
	/**
	 * @private
	 * The position of the playhead in the sound data 
	 * when the playback was last paused.
	 */
	[Bindable(event="pausePositionChange")]
	public function get pausePosition():int
	{
		return _pausePosition
	}
	
	private var _displayTime:String
	
	[Bindable(event="pausePositionChange")]
	public function get displayTime():String
	{
		return _displayTime;
	}
	
	/**
	 * @private 
	 */		
	private function setPausePosition(position:int):void
	{
		_pausePosition = position;
		_displayTime = TimeFormatter.MSELToMMSS(position);
		dispatchEvent(new Event("pausePositionChange"));
	}
	
	//------------------------------
	//		buffer time
	//------------------------------
	
	/**
	 * @private
	 */
	private var _bufferTime:int = 3000;
	
	/**
	 * The buffer time to use when loading this object's sound file.
	 */	
	public function get bufferTime():int
	{
		return _bufferTime;
	}
	
	/**
	 * @private
	 */		
	public function set bufferTime(buffer:int):void
	{
		_bufferTime = buffer;
	}
	
	//------------------------------
	//		currentState
	//------------------------------
	
	private var _currentState:String = "";
	
	/**
	 * The currentState specials the play state
	 * @see com.eto.etoplayer.states.PlayState;
	 */	
	[Bindable("currentStateChange")]
	public function get currentState():String
	{
		return _currentState;
	}
	
	/**
	 * @private
	 */		
	private function setCurrentState(state:String):void
	{
		_currentState = state
		
		dispatchEvent(new Event("currentStateChange"));
	}	
	
	//--------------------------------------------------------------------------
	//
	//					method
	//
	//--------------------------------------------------------------------------
	
	/** 
	 * @private
	 */				
	public function load(url:String):void
	{
		_url = url;
		
		isReadyToPlay = false;
		
		if (isPlaying)
		{
			stop();
		}
		
		isLoaded = false;
		
		if(sound)
			disposeSound();
			
		sound = new Sound();
		
		sound.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
		sound.addEventListener(Event.OPEN, onLoadOpen);
		sound.addEventListener(Event.COMPLETE, onLoadComplete);
		sound.addEventListener(Event.ID3, onID3);
		sound.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		sound.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onIOError);
		
		var request:URLRequest = new URLRequest(url);
		
		var context:SoundLoaderContext = new SoundLoaderContext(bufferTime, true);
		
		sound.load(request, context);
		
		//setCurrentState(PlayState.LOADING);
	}
	
	public function play(pos:int = 0):void
	{	
		trace("play");
		if(isReadyToPlay)
		{
			if(channel)
				disposeChannel();
			
			channel = sound.play(pos);
			setChannelVolume(volume);
			channel.addEventListener(Event.SOUND_COMPLETE, onPlayComplete);
			
			isPlaying = true;
			
			playTimer = new Timer(progressInterval);
			playTimer.addEventListener(TimerEvent.TIMER, onPlayTimer);
			playTimer.start();
			
			if(currentState == PlayState.READY_TO_PLAY)
			{
				dispatchEvent(new Event(PLAY_START));
			}
			
			setCurrentState(PlayState.PLAYING);
		}
	}
	
	public function stop(pos:int = 0):void
	{
		if (isPlaying)
		{
			disposeChannel();
			isPlaying = false;
		}
		if (isStreaming && !isLoaded)
		{
		    // stop streaming
		    disposeSound();
		    isReadyToPlay = false;
		}
		
		setPausePosition(pos);
		setCurrentState(PlayState.READY_TO_PLAY);
	}
	
	public function pause():void
	{
		setPausePosition(channel.position);
		disposeChannel();
		
		isPlaying = false;
		setCurrentState(PlayState.PAUSE);
	}
	
	public function resume():void
	{
		play(pausePosition);
	}
	
	public function replay():void
	{
		stop();
		isPlaying = false;
		play(0);
	}
	
	private function onLoadOpen(event:Event):void
	{
		if (isStreaming)
		{
			isReadyToPlay = true;
			setCurrentState(PlayState.READY_TO_PLAY);
			if (autoPlay)
			{
				play();
			}
		}
		this.dispatchEvent(event.clone());
	}
	
	private function onLoadProgress(event:ProgressEvent):void
	{   
		this.dispatchEvent(event.clone());
	}
	
	private function onLoadComplete(event:Event):void
	{
		isReadyToPlay = true;
		isLoaded = true;
		dispatchEvent(event.clone());

		// if the sound hasn't started playing yet, start it now
		if (autoPlay && !isPlaying)
		{
			play();
		}
	}

    private function onPlayComplete(event:Event):void
    {
        setPausePosition(0);
        disposeChannel();
        isPlaying = false;
        
        dispatchEvent(event.clone());
    }
	
	private function onID3(event:Event):void
	{
	    try
	    {
		    var id3:ID3Info = event.target.id3;
		    
		    dispatchEvent(event.clone());
		}
		catch (err:SecurityError)
		{
		}
	}

	private function onIOError(event:IOErrorEvent):void
	{
	    dispatchEvent(event.clone());
	}
	
	private function onPlayTimer(event:TimerEvent):void 
	{
		trace("timer");
		var estimatedLength:int = 
			Math.ceil(sound.length / (sound.bytesLoaded / sound.bytesTotal));
		
		setPausePosition(channel.position);		
		
		var progEvent:ProgressEvent = 
			new ProgressEvent(PLAY_PROGRESS, false, false, channel.position, estimatedLength);
			
		dispatchEvent(progEvent);
	}
    
    private function setChannelVolume(vol:Number):void
	{
		var stf:SoundTransform = channel.soundTransform;
		stf.volume = vol;
		channel.soundTransform = stf;
	}
	
	private function disposeSound():void
	{
		//if(is
		//sound.close();
		if(sound)
		{
			sound.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			sound.removeEventListener(Event.OPEN, onLoadOpen);
			sound.removeEventListener(Event.COMPLETE, onLoadComplete);
			sound.removeEventListener(Event.ID3, onID3);
			sound.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			sound.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onIOError);
		
			sound = null;
		}
	}
	
	private function disposeChannel():void
	{
		channel.stop();
		channel.removeEventListener(Event.SOUND_COMPLETE, onPlayComplete);
		channel = null;
		
		playTimer.stop();
		playTimer.removeEventListener(TimerEvent.TIMER,onPlayTimer);
		playTimer = null;
	}
}
}