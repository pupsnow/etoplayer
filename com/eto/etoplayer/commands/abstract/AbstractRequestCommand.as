package com.eto.etoplayer.commands.abstract
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.rpc.IResponder;

	public class AbstractRequestCommand implements IResponder, ICommand
	{
		public function AbstractRequestCommand()
		{
			//throw new Error("This class can not be instantiated");
		}

		public function result(data:Object):void
		{
		}
		
		public function fault(info:Object):void
		{
		}
		
		public function execute(event:CairngormEvent):void
		{
		}
		
	}
}