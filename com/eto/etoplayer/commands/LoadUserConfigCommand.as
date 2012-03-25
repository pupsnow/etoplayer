package com.eto.etoplayer.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.eto.etoplayer.core.LocalFilePath;
	import com.eto.etoplayer.data.UserConfig;
	import com.eto.etoplayer.filesystem.TextFile;

	public class LoadUserConfigCommand implements ICommand
	{
		public function LoadUserConfigCommand()
		{
		}

		public function execute(event:CairngormEvent):void
		{
			var textFile:TextFile = new TextFile(LocalFilePath.userConfig);
			var configText:String = textFile.read();
			if(configText)
			{
				UserConfig.configXML = new XML(configText);
			}
		}
	}
}