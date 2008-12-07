package com.eto.etoplayer.events
{
import com.adobe.cairngorm.control.CairngormEvent;

import flash.desktop.Clipboard;

/**
 * @author Riyco
 */
public class ClipboardToPlayListEvent extends CairngormEvent
{
	public static const CLIPBOARD_TO_PLAYLIST:String = "clipboardToPlayList";
	
	private var _autoPlay:Boolean = false;
	public function get autoPlay():Boolean
	{
		return _autoPlay;
	}
	
	private var _clipboard:Clipboard;
	public function get clipboard():Clipboard
	{
		return _clipboard;
	}
	
	public function ClipboardToPlayListEvent(
								clipboard:Clipboard,autoPlay:Boolean = false)
	{
		super(CLIPBOARD_TO_PLAYLIST);
		
		_clipboard = clipboard;
		_autoPlay = autoPlay;
	}
	
}

}