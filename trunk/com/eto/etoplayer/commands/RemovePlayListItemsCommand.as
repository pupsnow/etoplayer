package com.eto.etoplayer.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.eto.etoplayer.core.LocalFilePath;
	import com.eto.etoplayer.events.RemovePlayListItemsEvent;
	import com.eto.etoplayer.filesystem.TextFile;
	import com.eto.etoplayer.model.PlayListModel;
	import com.eto.etoplayer.model.PlayModel;
	
	/**
	 * 
	 * @author Riyco
	 * 
	 */	
	public class RemovePlayListItemsCommand implements ICommand
	{
		public function RemovePlayListItemsCommand()
		{
		}

		public function execute(event:CairngormEvent):void
		{
			var removeEvent:RemovePlayListItemsEvent = 
									RemovePlayListItemsEvent(event);
			var playListModel:PlayListModel = PlayModel.getInstance().playListModel;
			
			if(removeEvent.isRemoveAll)
			{
				playListModel.removeAll();
			}
			else
			{
				var items:Array =  removeEvent.removeItems;
				playListModel.removeItems(items);
			}
			
			var favoritesFile:TextFile = new TextFile(LocalFilePath.favoritesPath);
			favoritesFile.write(playListModel.dataProvider.toXMLString());
		}
	}
}