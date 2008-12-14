package com.eto.etoplayer.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.eto.etoplayer.vo.MP3Info;
	
	/**
	 * 
	 * @author Riyco
	 * @see com.eto.etoplayer.commands.SoundPlayCommand;
	 */	
	public class SoundPlayEvent extends CairngormEvent
	{
		/**
		 * A static const of event type 
		 */		
		public static const SOUND_PLAY:String = "soundPlay";
		
		public var position:Number = 0;
		
		private var _item:MP3Info;
		
		public function get item():MP3Info
		{
			return _item
		}
		/**
		 * Constructor.
		 */
		public function SoundPlayEvent(item:MP3Info,position:Number = 0)
		{
			_item = item;
			this.position = position	
			super(SOUND_PLAY);
		}
		
	}
}