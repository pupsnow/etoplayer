package com.eto.etoplayer.commands
{
import com.adobe.cairngorm.commands.ICommand;
import com.adobe.cairngorm.control.CairngormEvent;
import com.eto.etoplayer.core.SoundFacade;
import com.eto.etoplayer.data.UserConfig;
import com.eto.etoplayer.events.VolumeChangeEvent;
import com.eto.etoplayer.model.PlayModel;
import com.eto.etoplayer.states.PlayState;

public class VolumeChangeCommand implements ICommand
{
	public function execute(event:CairngormEvent):void
	{
		var e:VolumeChangeEvent = VolumeChangeEvent(event);
		
		var soundFacade:SoundFacade = SoundFacade(PlayModel.getInstance().mediaFacade);
		
		if(soundFacade.currentState == PlayState.PLAYING)
		{
			soundFacade.volume = e.value;
		}
		trace("volumeChange");
		if(e.saveChange)
		{
			trace("volumeChangeSave");
			UserConfig.volume = e.value;
			UserConfig.save();
		}
	}
}
}