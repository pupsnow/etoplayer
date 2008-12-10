package com.eto.etoplayer.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.eto.etoplayer.core.LocalFilePath;
	import com.eto.etoplayer.core.UserConfig;
	import com.eto.etoplayer.filesystem.TextFile;

	public class SaveUserConfigCommand implements ICommand
	{
		public function SaveUserConfigCommand()
		{
		}

		public function execute(event:CairngormEvent):void
		{
			var textFile:TextFile = new TextFile(LocalFilePath.userConfig);
			textFile.write(UserConfig.toXMLString());
		}
		
	}
}