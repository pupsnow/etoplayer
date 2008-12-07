package com.eto.etoplayer.model
{
	import com.adobe.cairngorm.model.IModelLocator;
	import com.eto.etoplayer.view.VersionUpdateAlert;
	import com.eto.etoplayer.vo.VersionVo;

	public class ApplicationModel implements IModelLocator
	{
		/**
		 * @private 
		 */		
		private static var _model:ApplicationModel
		
		/** 
		 * @return A static instance of ApplicationModel class.
		 */		
		public static function getInstance():ApplicationModel
		{
			if(_model == null)
			{
				_model = new ApplicationModel();
			}
			return _model;
		}
		
		//---------------------------------------------------------
		//			vauleObject
		//---------------------------------------------------------
		
		/**
		 * Containing version and update-version; 
		 */		
		public var versionVo:VersionVo;
		
		
		//---------------------------------------------------------
		//			component
		//---------------------------------------------------------
		/**
		 * A UICompnent for update alert.
		 * show sth. about update.
		 */
		[Bindable]
		public var updateAlert:VersionUpdateAlert;
		
		//---------------------------------------------------------
		//			Constructor
		//---------------------------------------------------------
		
		/**
		 * Constructor.
		 */
		public function ApplicationModel()
		{
			versionVo = new VersionVo();
		}
	}
}