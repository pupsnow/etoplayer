package com.eto.etoplayer.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.eto.etoplayer.core.SoundFacade;
	import com.eto.etoplayer.events.VolumeChangeEvent;
	import com.eto.etoplayer.model.PlayModel;
	
	import flash.media.SoundTransform;

	public class VolumeChangeCommand implements ICommand
	{
		public function VolumeChangeCommand()
		{
		}

		public function execute(event:CairngormEvent):void
		{
			var e:VolumeChangeEvent = VolumeChangeEvent(event);
			
			var soundFacade:SoundFacade = SoundFacade(PlayModel.getInstance().mediaFacade);
			
			if(soundFacade.sound)
			{
				var songTransform:SoundTransform = soundFacade.channel.soundTransform;
				
				songTransform.volume = e.value;
				
				soundFacade.channel.soundTransform = songTransform;
			}
			
		}
		
	}
}