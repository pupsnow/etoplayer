package com.eto.etoplayer.business.abstract
{
	import com.adobe.cairngorm.business.ServiceLocator;

	public class AbstractServices extends ServiceLocator
	{
		public function AbstractServices()
		{
			super();
			
			initialize();
		}
		
		protected function initialize():void
		{
			
		}
	}
}