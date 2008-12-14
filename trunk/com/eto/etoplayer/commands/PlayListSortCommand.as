package com.eto.etoplayer.commands
{
import com.adobe.cairngorm.commands.ICommand;
import com.adobe.cairngorm.control.CairngormEvent;
import com.eto.etoplayer.core.LocalFilePath;
import com.eto.etoplayer.events.PlayListSortEvent;
import com.eto.etoplayer.filesystem.TextFile;
import com.eto.etoplayer.model.PlayListModel;
import com.eto.etoplayer.model.PlayModel;
import com.eto.etoplayer.states.PlayListSortPattern;
import com.eto.etoplayer.util.ChractorCheckList;

import flash.utils.Dictionary;

public class PlayListSortCommand implements ICommand
{
	private var playList:PlayListModel = PlayModel.getInstance().playListModel
	
	private var fieldName:String = null;
	
	private var chineseList:Dictionary = null;
	
	function PlayListSortCommand()
	{
		chineseList = new ChractorCheckList().getList();
	}
	
	public function execute(event:CairngormEvent):void
	{
		var e:PlayListSortEvent = PlayListSortEvent(event);
		var sign:String = e.sortOn;
		
		
		switch(sign)
		{
			case PlayListSortPattern.TITLE : fieldName = "@title";break;
			case PlayListSortPattern.ARTIST : fieldName = "@artist";break;
			case PlayListSortPattern.ALBUM : fieldName = "@ablum";break;
			default : break;
		}
		if(!fieldName)
		{
			return ;
		}
		var sortArr:Array = new Array();
		var datap:XMLList = playList.dataProvider.source;

		for(var i:int = 0;i<datap.length();i++)
		{
			var item:Object = datap[i];
			var sortStr:String = item[fieldName].toString().charAt(0);;
			
			var numASCII:Number = sortStr.charCodeAt(0);
			if(numASCII>=19968 && numASCII<= 40869)
			{
				item.@sort = getCNPinyin(sortStr);
			}
			else
			{
				item.@sort = sortStr;
			}
			sortArr.push(item);
		}
		sortArr.sortOn("@sort");
		playList.removeAll(false);
		
		for(var ii:int = 0;ii<sortArr.length;ii++)
		{
			playList.dataProvider.addItem(sortArr[ii]);
		}
		 
		playList.setSelectedItem(playList.selectedItem,true,true);
		
		//write favorites file
		var favoritesFile:TextFile = new TextFile(LocalFilePath.favoritesPath);
		favoritesFile.write(playList.dataProvider.toXMLString());
	}
	
	private function getCNPinyin(checkStr:String):String
	{
		for(var i:String in chineseList)
		{
			if(String(chineseList[i]).indexOf(checkStr) != -1)
			{
				
				return i;
			}
		}
		
		return "";
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