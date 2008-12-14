package com.eto.etoplayer.commands
{
import com.adobe.cairngorm.commands.ICommand;
import com.adobe.cairngorm.control.CairngormEvent;
import com.eto.etoplayer.events.SearchPlayListEvent;
import com.eto.etoplayer.model.PlayListModel;
import com.eto.etoplayer.model.PlayModel;
import com.eto.etoplayer.vo.MP3Info;

import mx.utils.StringUtil;

public class SearchPlayListCommand implements ICommand
{
	private var playList:PlayListModel = PlayModel.getInstance().playListModel;

	public function execute(event:CairngormEvent):void
	{
		var sevent:SearchPlayListEvent = SearchPlayListEvent(event);
		var keyword:String = sevent.keyword;
		if(keyword && StringUtil.trim(keyword)!="")
		{
			searchExtute(keyword);
		}
	}
	
	private function searchExtute(keyword:String):void
	{
		for(var i:int=0;i<playList.dataProvider.length;i++)
		{
			var mp3info:MP3Info = new MP3Info(playList.dataProvider[i])
			var indexof:int = mp3info.indexOf(keyword);
			if(indexof!= -1)
			{
				updateListPosition(playList.dataProvider[i]);
				break;
			}
			
		}
	}
	
	private function updateListPosition(item:Object):void
	{
		playList.setSelectedItem(item,true);
	}
}
}