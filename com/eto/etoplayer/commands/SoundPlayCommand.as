package com.eto.etoplayer.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.eto.etoplayer.core.ServerLocation;
	import com.eto.etoplayer.core.SoundFacade;
	import com.eto.etoplayer.events.SoundPlayEvent;
	import com.eto.etoplayer.model.PlayModel;

	public class SoundPlayCommand implements ICommand
	{
		public function SoundPlayCommand()
		{
			
		}
		
		public function execute(event:CairngormEvent):void
		{
			var model:PlayModel = PlayModel.getInstance();
		
			var e:SoundPlayEvent = SoundPlayEvent(event);
			
			var soundFacade:SoundFacade = SoundFacade(model.mediaFacade);
			
			if(e.item)
			{
				model.playListModel.setSelectedItem(e.item);
			}
			if(soundFacade.url == e.url)
			{
				soundFacade.play(e.position);
			}
			else
			{
				var url:String =  e.url;
				soundFacade.load(url);
			}
		}
	}
}