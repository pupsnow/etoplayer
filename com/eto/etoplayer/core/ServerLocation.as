package com.eto.etoplayer.core
{
	import flash.net.Socket;
	
	/**
	 * 
	 * @author Riyco
	 * 
	 */	
	public class ServerLocation
	{
		/** 
		 * 
		 */		
		public function ServerLocation()
		{
		}
		
		private static const LOCATIONS:Array = 
				["etostudio.gicp.net","127.0.0.1"];
				
		private static const HTTP_PORT:int = 80;
		
		/* public static function get location():String
		{
			//var 
			return "etostudio.gicp.net";
		} */
		
		public static function getHttpLocation():String
		{
			/* var socket:Socket = new Socket();
			for(var i:int = 0;i<LOCATIONS.length;i++)
			{
				socket.connect(locations[i],HTTP_PORT);
			} */
			
			return "http://" + LOCATIONS[1];
		}
		
		public static function get webPlayListAddress():String
		{
			return getHttpLocation() + "/etoplayer/favorite.xml";
		}
	}
}