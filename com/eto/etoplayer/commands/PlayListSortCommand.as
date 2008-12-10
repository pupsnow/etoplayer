package com.eto.etoplayer.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.eto.etoplayer.events.PlayListSortEvent;
	import com.eto.etoplayer.model.PlayListModel;
	import com.eto.etoplayer.model.PlayModel;
	import com.eto.etoplayer.states.PlayListSortPattern;

	public class PlayListSortCommand implements ICommand
	{
		private var playList:PlayListModel = 
									PlayModel.getInstance().playListModel;
		
		private var fieldName:String = null;
		
		public function execute(event:CairngormEvent):void
		{
			var e:PlayListSortEvent = PlayListSortEvent(event);
			var sign:String = e.sortOn;
			
			switch(sign)
			{
				case PlayListSortPattern.TITLE : fieldName = "@title";break;
				case PlayListSortPattern.ARTIST : fieldName = "@artist";break;
				case PlayListSortPattern.ALBUM : fieldName = "@album";break;
				default : break;
			}
			if(!fieldName)
			{
				return ;
			}
			var sortArr:Array = new Array();
			var datap:XMLList = playList.dataProvider.source;
			//trace(playList.dataProvider.source.toXMLString());
			for(var i:int = 0;i<datap.length();i++)
			{
				var item:Object = datap[i];
				var sortStr:String = item[fieldName].toString();
				item.@sort = sortStr.charCodeAt(0);
				//trace(item.toXMLString());
				//trace(item.toString());
				sortArr.push(item);
			}
			sortArr.sortOn("@sort",Array.NUMERIC);
			playList.removeAll();
			
			for(var ii:int = 0;ii<sortArr.length;ii++)
			{
				playList.dataProvider.addItem(sortArr[ii]);
			} 
			
			trace(playList.dataProvider.toXMLString());
		}
		
		/* private function sortOnChar(argone:Object,argtwo:Object):Number
		{
			trace(argone.toString());
			var strone:String = argone.fieldName;
			var strtwo:String = argtwo.fieldName;
			
			var numone:Number = strone.charCodeAt(0);
			var numtwo:Number = strtwo.charCodeAt(0);
			trace(strone + ":" + numone + "  " + strtwo + ":" + numtwo);
			if(numone > numtwo) 
			{
		        return 1;
		    } 
		    else if(numone < numtwo) 
		    {
		        return -1;
		    } 
		    else  
		    {
		        return 0;
		    }

		} */
	}
}