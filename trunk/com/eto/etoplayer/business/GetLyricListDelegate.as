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
		_responder.result(event.result);
		
		web.removeEventListener(ResultEvent.RESULT,resultHandler);
	}
}
}