package com.eto.etoplayer.commands
{
import com.adobe.cairngorm.commands.ICommand;
import com.adobe.cairngorm.control.CairngormEvent;
import com.eto.etoplayer.core.FileFiters;
import com.eto.etoplayer.core.LocalFilePath;
import com.eto.etoplayer.filesystem.TextFile;
import com.eto.etoplayer.model.PlayListModel;
import com.eto.etoplayer.model.PlayModel;

import flash.events.FileListEvent;
import flash.filesystem.File;

import mx.collections.XMLListCollection;

public class SelectFileToPlayListCommand implements ICommand
{
	public function SelectFileToPlayListCommand()
	{
		
	}

	public function execute(event:CairngormEvent):void
	{
		var file:File = new File();
		file.addEventListener(FileListEvent.SELECT_MULTIPLE,selectedHandler);
		file.browseForOpenMultiple(
						"请选择一个或多个媒体文件^_^",FileFiters.mediaFileFiters);
	}
	
	private function selectedHandler(event:FileListEvent):void
	{
		var mediaFiles:Array = event.files;
		var playlistmodel:PlayListModel = PlayModel.getInstance().playListModel;
		var addItems:XMLListCollection = playlistmodel.addMediaFiles(mediaFiles);
		
		//write favorites file
		var favoritesFile:TextFile = new TextFile(LocalFilePath.favoritesPath);
		favoritesFile.append(addItems.toXMLString()); 
	}
	
}
}