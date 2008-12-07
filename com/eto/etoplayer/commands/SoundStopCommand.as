package com.eto.etoplayer.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.eto.etoplayer.model.PlayModel;
	import com.eto.etoplayer.core.SoundFacade;

	public class SoundStopCommand implements ICommand
	{
		public function SoundStopCommand()
		{
		}

		public function execute(event:CairngormEvent):void
		{
			var model:PlayModel = PlayModel.getInstance();
			var soundFacade:SoundFacade = SoundFacade(model.mediaFacade);
			
			soundFacade.stop();
		}
		
	}
}