package com.eto.etoplayer.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.eto.etoplayer.core.UserConfig;
	import com.eto.etoplayer.events.ChoosePlayParttenEvent;

	public class ChoosePlayPatternCommand implements ICommand
	{
		public function execute(event:CairngormEvent):void
		{
			var cevent:ChoosePlayParttenEvent = ChoosePlayParttenEvent(event);
			UserConfig.playPattern = cevent.partten;
			UserConfig.save();
		}
	}
}