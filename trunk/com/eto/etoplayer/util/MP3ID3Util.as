package com.eto.etoplayer.util
{
	import com.eto.etoplayer.vo.ID3Genres;
	import com.eto.etoplayer.vo.MP3Info;
	
	import flash.filesystem.FileStream;
	import flash.utils.Endian;
	
	import mx.utils.StringUtil;
	
	/** 
	 * @author Administrator 
	 */	
	public class MP3ID3Util
	{
		
		function MP3ID3Util()
		{
		}
		 	
		public static function read(bytes:FileStream,characterSet:String):MP3Info
		{ 
			var id3:MP3Info = new MP3Info();
			
			try 
			{ 
				bytes.endian = Endian.BIG_ENDIAN;
				bytes.position = bytes.bytesAvailable - 128;
				if (bytes.readUTFBytes(3) == 'TAG')
				{ 
					id3.title = StringUtil.trim(bytes.readMultiByte(30, characterSet));
					id3.artist =  StringUtil.trim(bytes.readMultiByte(30, characterSet));
					id3.album = bytes.readMultiByte(30, characterSet);
					id3.year = bytes.readMultiByte(4, characterSet);
					
					/*if (bytes[bytes.position+28] == 0x0) 
					{ 
						id3.comment = bytes.readMultiByte(28,characterSet);
						bytes.readUnsignedByte();
						id3.track =  bytes.readUnsignedByte().toString();
					} 
					else 
					{ 
							id3.comment = bytes.readMultiByte(30, characterSet);
							//id3.track =  null;
					} */
					id3.genre = ID3Genres.getGenre(bytes.readUnsignedByte());
				} 
				else
				{ 
					return null;
				}
			} 
			catch (e:Error) 
			{ 
				throw new Error("ID3 parse error."+e.getStackTrace());
			}
			
			return id3;
		}
	}
}