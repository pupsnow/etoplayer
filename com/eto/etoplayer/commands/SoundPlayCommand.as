package com.eto.etoplayer.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.eto.etoplayer.events.SoundPlayEvent;
	import com.eto.etoplayer.model.PlayModel;
	import com.eto.etoplayer.vo.MP3Info;

	public class SoundPlayCommand implements ICommand
	{
		public function SoundPlayCommand()
		{
			
		}
		
		public function execute(event:CairngormEvent):void
		{
			var model:PlayModel = PlayModel.getInstance();
		
			var e:SoundPlayEvent = SoundPlayEvent(event);
			
			model.playItem = e.item;
			model.play(e.position);
		}
	}
}