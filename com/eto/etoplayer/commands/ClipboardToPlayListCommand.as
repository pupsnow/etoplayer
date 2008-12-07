package com.eto.etoplayer.commands
{
import com.adobe.cairngorm.commands.ICommand;
import com.adobe.cairngorm.control.CairngormEvent;
import com.adobe.cairngorm.control.CairngormEventDispatcher;
import com.eto.etoplayer.core.FileFiters;
import com.eto.etoplayer.core.LocalFilePath;
import com.eto.etoplayer.events.ClipboardToPlayListEvent;
import com.eto.etoplayer.events.SoundPlayEvent;
import com.eto.etoplayer.filesystem.TextFile;
import com.eto.etoplayer.model.PlayListModel;
import com.eto.etoplayer.model.PlayModel;

import flash.desktop.Clipboard;
import flash.desktop.ClipboardFormats;
import flash.filesystem.File;

import mx.collections.XMLListCollection;

public class ClipboardToPlayListCommand implements ICommand
{
	private var dropFiles:Array = new Array();
	
	public function ClipboardToPlayListCommand()
	{
	}
	
	public function execute(event:CairngormEvent):void
	{
		var ctEvent:ClipboardToPlayListEvent = ClipboardToPlayListEvent(event);
		var clipboard:Clipboard = ctEvent.clipboard;
		
		var hasFiles:Boolean = 
						clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT);
		if(hasFiles)
		{
			var files:Array = 
				  clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			addFileToList(files);
			
			if(ctEvent.autoPlay)
			{
				autoPlay();
			}
		}
	}
	
	private function addFileToList(files:Array):void
	{
		for(var i:int = 0;i<files.length;i++)
		{
			var file:File = File(files[i]);
			if(file.isDirectory)
			{
				addDirectory(file);
			}
			else
			{
				pushDropFiles(file);
			}
		}
		var playlistModel:PlayListModel = 
								PlayModel.getInstance().playListModel;
		var xmlcon:XMLListCollection = 
								playlistModel.addMediaFiles(dropFiles);
		
		var favoritesFile:TextFile = 
								new TextFile(LocalFilePath.favoritesPath);
		favoritesFile.append(xmlcon.toXMLString()); 
	}
	
	private function autoPlay():void
	{
		var playlistModel:PlayListModel = PlayModel.getInstance().playListModel;
		var item:Object = playlistModel.dataProvider[0];
		//var url:String = new 
		var event:SoundPlayEvent = new SoundPlayEvent(item.@url,item);
		CairngormEventDispatcher.getInstance().dispatchEvent(event);
	}
	
	private function pushDropFiles(file:File):void
	{
		if(FileFiters.isMediaFile(file))
		{
			dropFiles.push(file);
		}
	}
	
	private function addDirectory(folder:File):void
	{
		var files:Array = folder.getDirectoryListing()
		for(var i:int = 0;i<files.length;i++)
		{
			var file:File = File(files[i]);
			if(!file.isDirectory)
			{
				pushDropFiles(file);
			}
		}
	}
	
	
}
}