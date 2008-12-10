package com.eto.etoplayer.control
{
import com.adobe.cairngorm.control.FrontController;
import com.eto.etoplayer.commands.*;
import com.eto.etoplayer.events.*;

public class ApplicationController extends FrontController
{
	
	public function ApplicationController()
	{
		initialiseCommands()
	}
	
	private function initialiseCommands():void
	{
		//---------------------------------------------------------------
		//					version control
		//---------------------------------------------------------------
		
		addCommand(VersionUpdateEvent.VERSION_UPDATE,VersionUpdateCommand);
		
		//---------------------------------------------------------------
		//					user set control
		//---------------------------------------------------------------
		
		addCommand(LoadUserConfigEvent.LOAD_USER_CONFIG,LoadUserConfigCommand);
		addCommand(SaveUserConfigEvent.SAVE_USER_CONFIG,SaveUserConfigCommand);
		
		//---------------------------------------------------------------
		//					play control
		//---------------------------------------------------------------
		
		addCommand(GetWebPlayListEvent.GET_WEB_PLAY_LIST,GetWebPlayListCommand);
		addCommand(SoundPlayEvent.SOUND_PLAY,SoundPlayCommand);
		addCommand(SoundPauseEvent.SOUND_PAUSE,SoundPauseCommand);
		addCommand(SoundStopEvent.SOUND_STOP,SoundStopCommand);
		addCommand(VolumeChangeEvent.VOLUME_CHANGE,VolumeChangeCommand);
		
		//---------------------------------------------------------------
		//					lyric control
		//---------------------------------------------------------------
		
		addCommand(GetLyricListEvent.GET_LRC_LIST,GetLyricListCommand);
		addCommand(GetLyricFileEvent.GET_LYRIC_FILE,GetLyricFileCommand);
		
		//---------------------------------------------------------------
		//					playlist control
		//---------------------------------------------------------------
		
		addCommand(GetPlayListEvent.GET_PLAY_LIST,GetPlayListCommand);
		addCommand(SelectFileToPlayListEvent.SELECT_FILE_TO_PLAY_LIST,
												 SelectFileToPlayListCommand);
		addCommand(SelectFolderToPlayListEvent.SELECT_FOLDER_TO_PLAYLIST,
												 SelectFolderToPlayListCommand);
		addCommand(RemovePlayListItemsEvent.REMOVE_PLAY_LIST_ITEM,
												 RemovePlayListItemsCommand);
		addCommand(ClipboardToPlayListEvent.CLIPBOARD_TO_PLAYLIST,
												 ClipboardToPlayListCommand);
		addCommand(PlayListSortEvent.PLAY_LIST_SORT,PlayListSortCommand);
	}
}
}