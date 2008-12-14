package com.eto.etoplayer.vo
{
	import com.eto.etoplayer.core.ServerLocation;
	
	[Bindable]
	public class VersionVo
	{
		/**
		 * version id.
		 */			
		public var version:String = "Alpha 0.4";
		
		/**
		 * new version id.
		 */		
		public var newVersion:String = null;
		
		/**
		 * Currently valid update config file URL.
		 */			
		public var updateInfoUrl:String = "http://www.etoplayer.com/download/updateInfo.xml";
		
		/**
		 * Currently valid update program URL.
		 */
		public var updateUrl:String = null;
			
		public function VersionVo()
		{
			
		}

	}
}