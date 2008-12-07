package com.eto.etoplayer.business
{
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import mx.rpc.AbstractOperation;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.mxml.WebService;
	
	public class GetLyricListDelegate
	{
		private var _responder:IResponder = null ;
		
		private var _operation:AbstractOperation;
		
		public function GetLyricListDelegate(responder:IResponder)
		{
			_responder = responder;
		}
		
		public function send(keyword:String):void
		{
			var web:WebService = 
					ServiceLocator.getInstance().getWebService("lrcWebService") as WebService;
					
			_operation = web.getOperation("LRC");
			_operation.addEventListener(ResultEvent.RESULT,resultHandler);
			_operation.send(keyword);
		}
		
		private function resultHandler(event:ResultEvent):void
		{
			_responder.result(event.result);
			
			_operation.removeEventListener(ResultEvent.RESULT,resultHandler);
			_operation = null;
		}
	}
}