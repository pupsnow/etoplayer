package com.eto.etoplayer.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.eto.etoplayer.events.VersionUpdateEvent;
	import com.eto.etoplayer.model.ApplicationModel;
	import com.eto.etoplayer.view.VersionUpdateAlert;
	
	import flash.desktop.Updater;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;

	public class VersionUpdateCommand implements ICommand
	{
		/**
		 * model
		 * @private 
		 */		
		private var appModel:ApplicationModel;
		
		/**
		 *  Constructor.
		 */
		public function VersionUpdateCommand()
		{
			appModel = ApplicationModel.getInstance();
			updataLoader = new URLLoader();
		}
		
		//--------------------------------------------------
		//		get updateinfo,
		//		checked,is it need to update.
		//--------------------------------------------------
		
		/**
		 * Loader 
		 * @private 
		 */		
		private var updataLoader:URLLoader
		
		/**
		 * Get update info. from Remote-Service.
		 * @param event 
		 */		
		public function execute(event:CairngormEvent):void
		{
			var e:VersionUpdateEvent = VersionUpdateEvent(event);
			
			var updataRequest:URLRequest = new URLRequest(appModel.versionVo.updateInfoUrl);
				updataLoader.load(updataRequest);
				updataLoader.addEventListener(Event.COMPLETE,loaderCompleteHandler);
		}
		
		/**
		 * Excute When update-configration file was loaded.
		 * Pop up a dialog box,user can choose between update new version or not.
		 * @param event 
		 * @see com.eto.etoplayer.view.VersionUpdateAlert
		 */		
		private function loaderCompleteHandler(event:Event):void
   		{
   			try 
			{
				var result:XML=new XML(updataLoader.data);
				if (appModel.versionVo.version != result.version) 
				{
					appModel.versionVo.newVersion = String(result.version);
					appModel.versionVo.updateUrl = result.location;
						
					var alertComp:VersionUpdateAlert = VersionUpdateAlert.show(result.note);
					appModel.updateAlert = alertComp;
					alertComp.addEventListener("updateApp",updateRequest);				
				}
			} 
			catch (e:TypeError) 
			{
				mx.controls.Alert.show("Can not load update info.\n"+e.message);
			}
   		}
   		
   		//--------------------------------------------------
		//		Excute When Remote has new version,
		//		download and update local program.
		//--------------------------------------------------
		
   		private var urlStream:URLStream;
   		private var fileData:ByteArray;
   		
   		private function updateRequest(event:CairngormEvent):void
   		{
   			var urlReq:URLRequest = new URLRequest(appModel.versionVo.updateUrl);
   			
			urlStream = new URLStream() ;
			fileData = new ByteArray() ;
			
			urlStream.addEventListener(ProgressEvent.PROGRESS,loadProgress)
			urlStream.addEventListener(Event.COMPLETE,loaded);

			urlStream.load(urlReq);
   		}
   		
   		private function loadProgress(event:ProgressEvent):void
   		{
   			appModel.updateAlert.setProgress(event.bytesLoaded,event.bytesTotal);
   		}
   		
   		private function loaded(event:Event):void 
   		{
			urlStream.readBytes(fileData,0,urlStream.bytesAvailable);
			writeAirFile();
		}
		
		private function writeAirFile():void
		{
			var file:File=File.applicationStorageDirectory.resolvePath("etoplayer.air");
			var fileStream:FileStream=new FileStream() ;
			fileStream.addEventListener(Event.CLOSE,fileClosed);
			fileStream.openAsync(file,FileMode.WRITE);
			fileStream.writeBytes(fileData,0,fileData.length);
			fileStream.close();
		}
		
		private function fileClosed(event:Event):void 
		{
			var updater:Updater=new Updater() ; 
			var airFile:File=File.applicationStorageDirectory.resolvePath("etoplayer.air");
			updater.update(airFile,appModel.versionVo.newVersion);
		}
		
	}
}