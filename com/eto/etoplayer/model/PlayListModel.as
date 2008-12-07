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
		//-------------------------------------------------------------
		//		Contructor
		//-------------------------------------------------------------
		
		public function PlayListModel()
		{
			dataProvider = new XMLListCollection();
		}
		
		//-------------------------------------------------------------
		//		dataProvider
		//-------------------------------------------------------------
		
		public var dataProvider:XMLListCollection
		
		//-------------------------------------------------------------
		//		selectedIndex
		//-------------------------------------------------------------
		
		[Bindable]
		public var selectedIndex:int = -1;
		
		//-------------------------------------------------------------
		//		selectedItem
		//-------------------------------------------------------------
		
		private var _selectedItem:MP3Info
		
		[Bindable(event="selectedItemChange")]
		public function get selectedItem():MP3Info
		{
			return _selectedItem;
		}
		
		public function setSelectedItem(item:Object,
										indexChangeEnable:Boolean = false):void
		{
			if(indexChangeEnable)
			{
				selectedIndex = dataProvider.getItemIndex(item);
			}
			
			_selectedItem = new MP3Info(item);
			dispatchEvent(new Event("selectedItemChange"));
		}
		
		//-------------------------------------------------------------
		//
		//		Method
		//
		//-------------------------------------------------------------
		
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
				var index:int = dataProvider.getItemIndex(items[i])
				var item:Object = dataProvider.removeItemAt(index);
				returnValue.addItem(item);
			}
			return returnValue;
		}
		
		/**
		 * remove each of playlist item. 
		 */		
		public function removeAll():void
		{
			dataProvider.removeAll();
		}
	}
}