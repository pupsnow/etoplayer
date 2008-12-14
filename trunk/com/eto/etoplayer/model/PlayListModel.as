package com.eto.etoplayer.model
{
import com.eto.etoplayer.interfaces.IEventDispatcherModel;
import com.eto.etoplayer.util.MP3ID3Util;
import com.eto.etoplayer.vo.MP3Info;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

import mx.collections.XMLListCollection;

/**
 * 
 * @author Riyco
 * 
 */	
public class PlayListModel extends EventDispatcher implements IEventDispatcherModel
{
	//--------------------------------------------------------------------------
	//
	//			Contructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Contructor
	 */	
	public function PlayListModel()
	{
		dataProvider = new XMLListCollection();
	}
	
	//--------------------------------------------------------------------------
	//
	//			property
	//
	//--------------------------------------------------------------------------
	
	[Bindable]
	public var maxVerticalScrollPosition:Number
	//------------------------------
	//	dataProvider
	//------------------------------
	
	public var dataProvider:XMLListCollection
	
	//------------------------------
	//	verticalScrollPosition
	//------------------------------
	private var _verticalScrollPosition:int = 0;

	[Bindable(event="verticalScrollPositionChange")]
	public function get verticalScrollPosition():int
	{
		//trace(_verticalScrollPosition);
		return _verticalScrollPosition;
	}
	
	//------------------------------
	//	selectedIndex
	//------------------------------
	
	private var _selectedIndex:int = -1;
	
	[Bindable(event="selectedItemChange")]
	public function get selectedIndex():int
	{
		return _selectedIndex;
	}
	
	//------------------------------
	//	selectedItem
	//------------------------------
	
	private var _selectedItem:Object
	
	[Bindable(event="selectedItemChange")]
	public function get selectedItem():Object
	{
		return _selectedItem;
	}
	
	public function setSelectedItem(item:Object, autoPosition:Boolean = false, ignoreIsEqual:Boolean = false):void
	{
		if(_selectedItem == item && !ignoreIsEqual)
		{
			return;
		}
		
		_selectedItem = item;
		_selectedIndex = dataProvider.getItemIndex(selectedItem);
		
		dispatchEvent(new Event("selectedItemChange"));
		
		if(autoPosition)
		{
			_verticalScrollPosition = _selectedIndex - 3;
			//trace(vsIndex + ":" + maxVerticalScrollPosition);
			_verticalScrollPosition = Math.max(0,_verticalScrollPosition);
			_verticalScrollPosition = Math.min(maxVerticalScrollPosition,
														_verticalScrollPosition);
			trace(_verticalScrollPosition);
			dispatchEvent(new Event("verticalScrollPositionChange"));
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//		Method
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Add each of media info. to PlayList 
	 */		
	public function addMediaFiles(mediaFiles:Array):XMLListCollection
	{
		var returnValue:XMLListCollection = new XMLListCollection();
		
		for(var i:int = 0; i<mediaFiles.length;i++)
		{
			var mediaFile:File = mediaFiles[i];
			
			var fileStream:FileStream = new FileStream();
			fileStream.open(mediaFile, FileMode.READ);
					
			var id3:MP3Info = MP3ID3Util.read(fileStream,File.systemCharset);
			if(!id3 || id3.title == "")
			{
				id3 = new MP3Info();
				var fullname:String = mediaFile.name;
				var name:String = fullname.substring(0,fullname.lastIndexOf("."));
				id3.title = name;
			}
			id3.url = mediaFile.nativePath;
			var item:XML = id3.toXML()
			dataProvider.addItemAt(item,0);
			returnValue.addItem(item);
		}
		
		return returnValue; 
	}
	
	/**
	 * Removes playlist`s items by the items param.
	 * @return removed items. 
	 */		
	public function removeItems(items:Array):XMLListCollection
	{
		var returnValue:XMLListCollection = new XMLListCollection();
		for(var i:int=0;i<items.length;i++)
		{
			var item:Object = items[i];
			if(item == selectedItem)
			{
				setSelectedItem(null);
			}
			var index:int = dataProvider.getItemIndex(item)
			var returnItem:Object = dataProvider.removeItemAt(index);
			returnValue.addItem(returnItem);
		}
		return returnValue;
	}
	
	/**
	 * remove each of playlist item. 
	 */		
	public function removeAll(clearSelectedItem:Boolean = true):void
	{
		dataProvider.removeAll();
		if(clearSelectedItem)
		{
			setSelectedItem(null);
		}
	}
}
}