package com.eto.etoplayer.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
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
		
		/**
		 * The URL of the sound file to load. 
		 */		
		public var url:String;
		
		public var position:Number = 0;
		
		private var _item:Object;
		public function get item():Object
		{
			return _item
		}
		/**
		 * Constructor.
		 */
		public function SoundPlayEvent(url:String = null,item:Object = null)
		{
			if(url)
				this.url = url;
			_item = item;	
			super(SOUND_PLAY);
		}
		
	}
}