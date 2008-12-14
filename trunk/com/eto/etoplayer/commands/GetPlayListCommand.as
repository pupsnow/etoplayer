package com.eto.etoplayer.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.eto.etoplayer.core.LocalFilePath;
	import com.eto.etoplayer.filesystem.TextFile;
	import com.eto.etoplayer.model.PlayListModel;
	import com.eto.etoplayer.model.PlayModel;

	/**
	 * 
	 * @author Riyco
	 * 
	 */
	public class GetPlayListCommand implements ICommand
	{
		public function GetPlayListCommand()
		{
		}
		private var playListModel:PlayListModel = PlayModel.getInstance().playListModel;
		
		public function execute(event:CairngormEvent):void
		{
			var favoritesFile:TextFile = new TextFile(LocalFilePath.favoritesPath);
			var source:String = favoritesFile.read();
			if(source == "" ||source == null)
			{
				return ;
			}
			var xmllist:XMLList = new XMLList(source);
			playListModel.dataProvider.source = new XMLList(source);
			playListModel.setSelectedItem(playListModel.dataProvider[0]);
		}
		
	}
}