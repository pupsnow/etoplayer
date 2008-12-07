package com.eto.etoplayer.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.eto.etoplayer.core.SoundFacade;
	import com.eto.etoplayer.model.PlayModel;
	
	/**
	 * 
	 * @author Riyco
	 * 
	 */	
	public class SoundPauseCommand implements ICommand
	{
		public function SoundPauseCommand()
		{
			
		}

		public function execute(event:CairngormEvent):void
		{
			var soundFacade:SoundFacade = SoundFacade(PlayModel.getInstance().mediaFacade);
			soundFacade.pause();
		}
		
	}
}