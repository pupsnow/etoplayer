package com.eto.etoplayer.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.eto.etoplayer.business.WebPlayListLoader;
	import com.eto.etoplayer.business.events.DelegateResultEvent;
	import com.eto.etoplayer.events.GetWebPlayListEvent;
	import com.eto.etoplayer.model.ApplicationModel;
	import com.eto.etoplayer.model.PlayListModel;
	import com.eto.etoplayer.model.PlayModel;
	
	import mx.collections.XMLListCollection;
	
	/**
	 * 
	 * @author Riyco
	 * 
	 */	
	public class GetWebPlayListCommand implements ICommand
	{
		private var appModel:ApplicationModel;
		
		public function GetWebPlayListCommand()
		{
			appModel = ApplicationModel.getInstance();
		}

		public function execute(event:CairngormEvent):void
		{
			var e:GetWebPlayListEvent = GetWebPlayListEvent(event);
			
			var delegate:WebPlayListLoader = new WebPlayListLoader();
				delegate.load();
				delegate.addEventListener(DelegateResultEvent.DELEGATE_RESULT,loaderCompleteHandler);
		}
		
		private function loaderCompleteHandler(event:DelegateResultEvent):void
   		{
   			try 
			{
				var result:XML=new XML(event.result);
				var playListData:XMLList = result.children();
				
				if(playListData)
				{
					var playListModel:PlayListModel = PlayModel.getInstance().playListModel;
					playListModel.setSelectedItem(playListData[0]);
					
					XMLListCollection(playListModel.dataProvider).source = playListData;
				}
				
			} 
			catch (e:TypeError)  
			{
				throw new Error("Can not load favorite info.\n"+e.message);
			}
   		}
	}
}