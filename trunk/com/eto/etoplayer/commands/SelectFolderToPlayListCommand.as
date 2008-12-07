package com.eto.etoplayer.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.eto.etoplayer.core.FileFiters;
	import com.eto.etoplayer.core.LocalFilePath;
	import com.eto.etoplayer.filesystem.TextFile;
	import com.eto.etoplayer.model.PlayListModel;
	import com.eto.etoplayer.model.PlayModel;
	
	import flash.events.Event;
	import flash.filesystem.File;
	
	import mx.collections.XMLListCollection;

	public class SelectFolderToPlayListCommand implements ICommand
	{
		public function SelectFolderToPlayListCommand()
		{
		}

		public function execute(event:CairngormEvent):void
		{
			var directory:File = new File();
				directory.addEventListener(Event.SELECT,selectHandle);
				directory.browseForDirectory("请选择您音乐文件所在的文件夹"); 
		}
		
		private function selectHandle(event:Event):void
		{
			var directory:File = File(event.target);
			var directoryFiles:Array = directory.getDirectoryListing();
			
			var mediaFiles:Array = directoryFiles.filter(isSupportType);
			addMedias(mediaFiles);
		}
		
		/**
		 * @private
		 * Add each of media info. to PlayList and saveing PlayList-dataProvider in 
		 * Local as xml file.
		 */		
		private function addMedias(mediaFiles:Array):void
		{
			var playlistmodel:PlayListModel = PlayModel.getInstance().playListModel;
			var addItems:XMLListCollection = playlistmodel.addMediaFiles(mediaFiles);
			
			//write favorites file
			var favoritesFile:TextFile = new TextFile(LocalFilePath.favoritesPath);
			favoritesFile.append(addItems.toXMLString()); 
		}
		
		/**
		 * @private
		 * Validates selected files. 
		 */		
		private function isSupportType(element:*, index:int, arr:Array):Boolean 
		{
			var file:File = File(element);
			return FileFiters.isMediaFile(file);
        }
		
	}
}