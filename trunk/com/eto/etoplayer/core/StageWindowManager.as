package com.eto.etoplayer.core
{
import flash.desktop.NativeApplication;
import flash.desktop.SystemTrayIcon;
import flash.display.Loader;
import flash.display.NativeMenu;
import flash.display.NativeMenuItem;
import flash.display.NativeWindow;
import flash.events.Event;
import flash.events.ScreenMouseEvent;
import flash.net.URLRequest;

public class StageWindowManager
{
	private static var stageWindow:NativeWindow;
	private static var stageApplication:NativeApplication;
	
	private static var iconAlways:Boolean = false;
	
	public static function activeManager(nativeWindow:NativeWindow,
											showIconAlways:Boolean = false):void
	{
		if(!nativeWindow.stage)
		{
			throw new Error(
					"StageWindowManager only allow actives application window");
		}
		
		stageWindow = nativeWindow;
		stageApplication = NativeApplication.nativeApplication;
		iconAlways = showIconAlways;
		if(iconAlways)
		{
			showTrayIcon();
		}
	}
	
	public static function minimize():void
	{
		stageWindow.minimize();
	}
	
	public static function maximizeAsIcon():void
	{
		stageWindow.minimize();
		stageWindow.visible = false;
		if(!iconAlways)
		{
			showTrayIcon();
		}
	}
	
	public static function restoreFromIcon():void
	{
		stageWindow.visible = true;
   		stageWindow.restore();
	}
	
	public static function maximize():void
	{
		stageWindow.maximize();
	}
	
	public static function restore():void
	{
		stageWindow.restore();
	}
	
	public static function exit():void
	{
		stageApplication.exit();
	}
	
	private static function showTrayIcon():void
   	{
   		var iconLoader:Loader = new Loader();
   		iconLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,
   										iconLoaderCompleteHanler);
   		iconLoader.load(new URLRequest("assets/logo_16.png"));
   	}
   		
	private static function iconLoaderCompleteHanler(event:Event):void
   	{
   		var bitmaps:Array = [event.target.content.bitmapData];
   		createTrayIcon(bitmaps);
   	}
   	
	private static function createTrayIcon(bitmaps:Array):void
   	{
   		stageApplication.icon.bitmaps = bitmaps
   										
   		setIcomProperty();								
   	}
   	
   	private static function setIcomProperty():void
   	{
   		var iconMenu:NativeMenu = new NativeMenu();
   		
		var exitCommand:NativeMenuItem = 
							iconMenu.addItem(new NativeMenuItem("Exit"));
		exitCommand.addEventListener(Event.SELECT,
				function(event:Event):void
				{
					NativeApplication.nativeApplication.icon.bitmaps = [];
					NativeApplication.nativeApplication.exit();
				}
			);
		
		var systray:SystemTrayIcon = 
				NativeApplication.nativeApplication.icon as SystemTrayIcon;
		systray.tooltip = "etoplayer";
		systray.menu = iconMenu;
		systray.addEventListener(ScreenMouseEvent.CLICK,activeWindow);
   	}
   	
   	private static function activeWindow(event:ScreenMouseEvent):void
   	{
   		restoreFromIcon();
   	}
}
}