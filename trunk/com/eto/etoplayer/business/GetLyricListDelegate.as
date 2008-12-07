package com.eto.etoplayer.business
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.eto.etoplayer.vo.GetLyricListVo;
	
	import mx.rpc.AbstractOperation;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.utils.ObjectUtil;
	
	public class GetLyricListDelegate
	{
		private var _responder:IResponder = null ;
		
		private var _operation:AbstractOperation;
		
		private var web:HTTPService;
		
		public function GetLyricListDelegate(responder:IResponder)
		{
			_responder = responder;
		}
		
		public function send(vo:GetLyricListVo):void
		{
			/* var web:WebService = 
					ServiceLocator.getInstance().getWebService("lrcWebService") as WebService; 		
			_operation = web.getOperation("LRC");
			_operation.addEventListener(ResultEvent.RESULT,resultHandler);
			_operation.send(keyword); */
			if(web)
			{
				web.cancel();
			}
			web = ServiceLocator.getInstance().getHTTPService("getLyricList");
			web.addEventListener(ResultEvent.RESULT,resultHandler);
			web.send(vo);
		}
		
		private function resultHandler(event:ResultEvent):void
		{
			
			trace(event.result.toString());
			_responder.result(event.result);
			
			web.removeEventListener(ResultEvent.RESULT,resultHandler);
			//web = null;
			//_operation = null;
		}
	}
}