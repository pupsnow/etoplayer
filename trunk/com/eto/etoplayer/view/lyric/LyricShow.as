package com.eto.etoplayer.view.lyric
{
import caurina.transitions.Tweener;

import com.eto.etoplayer.util.TimeFormatter;

import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.text.TextLineMetrics;

/**
 *  Dispatched when lyricText's position changes from mouse adjust.
 *
 *  @eventType com.eto.etoplayer.view.lyric.PositionChangeEvent.POSITION_CHANGE
 */
[Event(name="positionChange", type="com.eto.etoplayer.view.lyric.PositionChangeEvent")]

/**
 *  Dispatched when lyricText's time position is changing by MouseWheel.
 */
[Event(name="lyrciDataEdited", type="flash.events.Event")]

/**
 * 
 * @author Riyco Zhang
 * 
 */	
public class LyricShow extends Sprite
{
	//------------------------------------------------------------
	//
	//			style
	//
	//------------------------------------------------------------
	
	//----------------------------------------------
	//		fontSize
	//----------------------------------------------
	
	/**
	 * @private 
	 */		
	private var _fontSize:Number = 12;
	
	/**
	 * text size
	 */		
	public function set fontSize(size:Number):void
	{
		_fontSize = size;
	}
	
	/**
	 * @private 
	 */		
	public function get fontSize():Number
	{
		return _fontSize;
	}
	
	//----------------------------------------------
	//		textColor
	//----------------------------------------------
	
	/**
	 *  @private 
	 */				
	private var _textColor:uint = 0xbfbfbf;
	
	/**
	 * nomal text color. 
	 */		
	public function set textColor(color:uint):void
	{
		_textColor = color;
	}
	
	/**
	 * @private
	 */		
	public function get textColor():uint
	{
		return _textColor
	}
	
	//---------------------------------
	//		highlightColor
	//---------------------------------
	
	/**
	 * @private 
	 */			
	private var _highlightColor:uint = 0xff7a31;
	
	/**
	 * high light text color. 
	 */
	public function set highlightColor(color:uint):void
	{
		_highlightColor = color;
	}
	
	/**
	 * @private
	 */		
	public function get highlightColor():uint
	{
		return _highlightColor
	}
	
	//---------------------------------
	//		backgroudColor
	//---------------------------------
	
	/**
	 * @private 
	 */			
	private var _backgroudColor:uint = 0x000000;
	
	/**
	 * high light text color. 
	 */
	public function set backgroudColor(color:uint):void
	{
		_backgroudColor = color;
	}
	
	/**
	 * @private
	 */		
	public function get backgroudColor():uint
	{
		return _backgroudColor
	}
	
	//------------------------------------------------------------
	//
	//			Constractor
	//
	//------------------------------------------------------------
	
	/**
	 * Constractor
	 */		
	public function LyricShow()
	{
		super();
		
		addEventListener(MouseEvent.MOUSE_DOWN,startAdjustPlayPosition);
		addEventListener(MouseEvent.MOUSE_MOVE,adjustingPlayPosition);
		addEventListener(MouseEvent.MOUSE_UP,endAdjustPlayPosition);
		addEventListener(MouseEvent.ROLL_OUT,endAdjustPlayPosition);
		
		createChildren();
	}
	
	//------------------------------------------------------------
	//
	//			children
	//
	//------------------------------------------------------------
	
	/**
	 * @private
	 */		
	private var backgroudSprite:Sprite;
	
	/**
	 * @private
	 */		
	private var effectSprite:Sprite;
	
	/**
	 * @private
	 * Base text frame.Gather normal text frame and high light text frame.
	 */		
	private var textFrame:Sprite;
	
	/**
	 * @private 
	 * mask of normal frame. 
	 */		
	private var textFrameMask:Sprite;
	
	/**
	 * @private
	 * high light text 
	 */	
	private var normalText:TextField;
	
	/**
	 * @private
	 * mask of special high light text.
	 */		
	private var highLightTextMask:Sprite;
	
	/**
	 * @private
	 * high light text 
	 */		
	private var highLightText:TextField;
	
	/**
	 * @private
	 * A Sprite to show the current time position 
	 * which be adjust to by mouse move. I is create when mouse down.
	 */		
	private var adjustPositionClew:Sprite
	
	/**
	 * @private
	 * A Child of adjustPositionClew create by mouse down. 
	 */		
	private var adjustPositionClewText:TextField
	
	//--------------------------------------------------------------------------
    //
    //  	Variables
    //
    //--------------------------------------------------------------------------
	
	/**
	 * @private
	 * A boolean value special weather the text was set or not.
	 */		
	private var _isTextCreated:Boolean = false;
	
	private function get isTextCreated():Boolean
	{
		return _isTextCreated; 
	}
	
	private function set isTextCreated(bl:Boolean):void
	{
		_isTextCreated = bl;
		buttonMode = bl;
	}
	
	public function isTextCreate():Boolean
	{
		return isTextCreate();
	}
	/**
	 * @private
	 * A boolean value special this.
	 */
	private var adjusting:Boolean = false;
	
	/**
	 * @private
	 * A Number special the middle of y of this component position .
	 */	
	private var middleY:int = 0;
	
	/**
	 * @private
	 * A number special the how many lines above the line of 
	 * music time on 00:00 of lyric text;  
	 */	
	private var numHeadLines:int = 0;
	
	/**
	 * @private
	 * A number special the height of textFiled above the line of 
	 * music time on 00:00 of lyric text;  
	 */		
	private var topHight:int = 0;
	
	/**
	 * @private
	 * The lineHeight value is the height of the text of each line.
	 */		
	private var lineHeight:int = 0; 
	
	/**
	 * @private
	 * A number special the next line which will move on. 
	 * The step 0 begin with music time 00:00,it means it is 
	 * not contant the lyric head ,just working for Array which
	 * in LyricData`s parameters.
	 *  
	 */		
	public var step:int = 0;
	
	/**
	 * @private
	 * The textMoveBy value is record the move px of the text when
	 * it is begin move up.  
	 */		
	private var textMoveBy:int = 0; 
	
	/**
	 * @private 
	 */		
	private var startAdjustMouseY:int = 0;
	
	/**
	 * @private 
	 */		
	private var statrAdjustTextY:int = 0;
	
	/**
     *  @private
     *  The value of the unscaledWidth parameter during the most recent
     *  call to updateDisplayList;
     */
    private var oldUnscaledWidth:Number;
    
    /**
     *  @private
     *  The value of the oldUnscaledHeight parameter during the most recent
     *  call to updateDisplayList;
     */
    private var oldUnscaledHeight:Number;
     
	//------------------------------------------------------------
	//
	//			proportys
	//
	//------------------------------------------------------------
	
	//-------------------------------
	//		lyricData
	//-------------------------------
	
	/**
	 * @private 
	 */		
	private var _lyricData:LyricData;
	
	/**
	 * Set a type of LyricData Object
	 * @see com.eto.etoplayer.view.lyric.LyricData;
	 */		
	public function set lyricData(data:LyricData):void
	{
		if(isTextCreated)
		{
			setText("");
			
			resetTextPosition();
			
			isTextCreated = false;
		}
		
		_lyricData = data;
		
		if(data)
		{
			commitLyricData(_lyricData);
			isTextCreated = true;
			
			//update diaplay list
			updateDisplayList(oldUnscaledWidth,oldUnscaledHeight);
		}
	}
	
	/** 
	 * @private 
	 */		
	private function commitLyricData(data:LyricData):void
	{
		var arrText:Array = _lyricData.contents;
		var length_:int = arrText.length;
		if(length_ > 5)
		{
			//set lyric text head
			var num:Number = 0;
			var lyricText:String = "";
			
			if(_lyricData.title!="")
			{
				lyricText += getFormatText(_lyricData.title);
				num++;
			}
			if(_lyricData.artist!="")
			{
				lyricText += getFormatText(_lyricData.artist);
				num++;
			}
			if(_lyricData.album!="")
			{
				lyricText += getFormatText(_lyricData.album);
				num++;
			}
			if(_lyricData.madeBy!="")
			{
				lyricText += getFormatText(_lyricData.madeBy);
				num++;
			}
			//set lyric text body.
			for(var i:int=0;i<arrText.length;i++)
			{
				lyricText+= getFormatText(arrText[i]);
			}
			
			//set the textFlied`s text proporty
			setText(lyricText);
			
			//update variables
			var lineMetrics:TextLineMetrics = normalText.getLineMetrics(1);
			lineHeight = lineMetrics.ascent + lineMetrics.descent + lineMetrics.leading;
			
			numHeadLines = num;
			topHight = numHeadLines * lineHeight + 2;
		}
	}
	
	//-------------------------------
	//		text
	//-------------------------------
	
	/**
	 * String of lyric text. 
	 */	
	public function get text():String
	{
		if(normalText)
			return normalText.text;
			
		return "";
	}
	
	/**
	 * @private
	 * Set both two textFlied`s text perproty.
	 */		
	private function setText(lyricText:String):void
	{
		normalText.text = lyricText;
		highLightText.text = lyricText;
	}
	
	//-------------------------------
	//		position
	//-------------------------------
	
	/**
	 * @private 
	 */		
	private var _position:int = 0;
	
	/**
	 * @private
	 */		
	private function get position():int
	{
		return _position;
	}
	
	/**
	 * ..........
	 * @param position 
	 */		
	public function setPosition(position:Number):void
	{
		if(lyricData && !adjusting)
		{
			_position = position;
			textMoveByPosition(position);
		}
	}
	
	/**
	 * @private
	 * @return LyricData
	 */		
	public function get lyricData():LyricData
	{
		return _lyricData;
	}
	
	/**
	 * @private
	 * format adding text.
	 */		
	private function getFormatText(text:String):String
	{
		return text + "\n";
	}
	
	//--------------------------------------------------------------------------
    //
    //  		Methods:createChildren
    //
    //--------------------------------------------------------------------------
	
	/**
	 * @private 
	 * Create all children.
	 */		
	protected function createChildren():void
	{
		if(!backgroudSprite)
		{
			backgroudSprite = new Sprite();
			addChild(backgroudSprite);
		}
		
		// Create a mask frame to mask the text frame. 
		if(!textFrameMask)
		{
			textFrameMask = new Sprite();
			//textFrameMask.cacheAsBitmap = true;
			addChild(textFrameMask);
		}
		
		//create base text frame
		if(!textFrame)
		{
			textFrame = new Sprite();
			//textFrame.cacheAsBitmap = true;
			textFrame.mask = textFrameMask;
			//textFrame.cacheAsBitmap = true;
			//
			addChild(textFrame); 
		}
		
		// Add normal display text to normalFrame
		if(!normalText)
		{
			normalText = new TextField();
			normalText.cacheAsBitmap = true;
			//normalText.mask = textFrameMask;
			textFrame.addChild(normalText);
		}
		
		// Create a mask frame to mask the high light text frame.
		if(!highLightTextMask)
		{
			highLightTextMask = new Sprite();
			addChild(highLightTextMask);
		}
		
		// Add hight light display text to hightLightFrame
		if(!highLightText)
		{
			highLightText = new TextField();
			highLightText.cacheAsBitmap = true;
			highLightText.mask = highLightTextMask;
			textFrame.addChild(highLightText);
		}
		
		if(!effectSprite)
		{
			effectSprite = new Sprite();
			addChild(effectSprite);
		}
		childrenCreated();
	}
	
	/**
	 * @private
	 * You do not call this method directly.
	 * It is called in the last of createChildren. 
	 */		
	protected function childrenCreated():void
	{
		setSharedTextProperty(normalText);
		normalText.textColor = textColor;
		
		setSharedTextProperty(highLightText);
		highLightText.textColor = highlightColor;
	}
	
	/**
	 * Processes the properties set on the component.
	 */		
	public function commitProperties():void
	{
		//......
	}
	
	/**
	 * @private 
	 * @param tf The textFiled need to update display.
	 */		
	private function setSharedTextProperty(textFiled:TextField):void
	{
		var format:TextFormat = new TextFormat();
		format.size = 12;
		format.font = "Arial";
		format.bold = false;
		format.align = TextFormatAlign.CENTER;
		textFiled.defaultTextFormat = format;
		
		textFiled.x = 0;
		textFiled.y = 0
		textFiled.multiline = true;
		textFiled.wordWrap = true;
		textFiled.focusRect = false;
		textFiled.mouseEnabled = false;
		textFiled.autoSize = TextFieldAutoSize.CENTER;
	}
	
	/**
	 * @private 
	 * Calls this method when style has been changed
	 */		
	protected function styleChange():void
	{
		//....
	}
	
	/**
	 *  Calculates the default size, and optionally the default minimum size,
	 *  of the component.
	 */		
	public function measure():void
	{
		//..............
	}
	
	//--------------------------------------------------------------------------
    //
    //  		Methods:update display
    //
    //--------------------------------------------------------------------------
    
	/**
	 * Draws the object and/or sizes and positions its children. 
	 * @param unscaledWidth Specifies the width of the component, in pixels,
 	 * in the component's coordinates, regardless of the value of the
 	 * <code>scaleX</code> property of the component.
     *
     * @param unscaledHeight Specifies the height of the component, in pixels,
     * in the component's coordinates, regardless of the value of the
     * <code>scaleY</code> property of the component.
	 * 
	 */		
	public function updateDisplayList(unscaledWidth:Number,unscaledHeight:Number):void
	{
		//trace("updateDisplayList");
		//Specials the middle line`s Y.
		middleY = int(unscaledHeight/2) ;
		
		//Updates backgroud.
		var backGraphics:Graphics = backgroudSprite.graphics;
			backGraphics.clear();
			backGraphics.beginFill(backgroudColor);
			backGraphics.drawRect(0,0,unscaledWidth,unscaledHeight);
			backGraphics.endFill();
		
		//Updates display children when text has been set.
		if(isTextCreated)
		{
            
			//Draws text mask frame.
			var textMastDraw:Graphics = textFrameMask.graphics;
			textMastDraw.clear();
			textMastDraw.beginFill(0x000000,1)
			textMastDraw.drawRect(0,0,unscaledWidth,unscaledHeight);
			textMastDraw.endFill();
			
			//Draws text mask effect;
			var effectHeight:int = 50;
			var colors:Array = [0x000000, 0x000000];
			var alphas:Array = [1, 0];
			var ratios:Array = [0, 255];
			var matrixTop:Matrix = new Matrix();
			matrixTop.createGradientBox(unscaledWidth,effectHeight,Math.PI/2,0,0); 
			var matrixBottom:Matrix = new Matrix();
			matrixBottom.createGradientBox(unscaledWidth,effectHeight,
											- Math.PI/2,
											0,unscaledHeight-effectHeight);
			var textFrameDraw:Graphics = effectSprite.graphics;
			textFrameDraw.clear();
			textFrameDraw.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,matrixTop);
			textFrameDraw.drawRect(0,0,unscaledWidth,effectHeight);
			textFrameDraw.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,matrixBottom);
			textFrameDraw.drawRect(0,unscaledHeight - effectHeight,unscaledWidth,effectHeight);
			
			//Draws high light text mask.
			var highlightMaskDraw:Graphics = highLightTextMask.graphics;
			highlightMaskDraw.clear();
			highlightMaskDraw.beginFill(0x0000000);
			highlightMaskDraw.drawRect(0,0,unscaledWidth,lineHeight + 1);
			highlightMaskDraw.endFill();
			//Set the highLightTextMask position
			highLightTextMask.y = getHighLightTextMaskY() ;
			
			updateDisplayText(normalText,unscaledWidth,unscaledHeight);
			updateDisplayText(highLightText,unscaledWidth,unscaledHeight);
		}
		
		oldUnscaledWidth = unscaledWidth;
		oldUnscaledHeight = unscaledHeight;
	}
	
	/**
	 * @private 
	 * @param textFiled The textFiled need to update display.
	 * 
	 */		
	private function updateDisplayText(textFiled:TextField,unscaledWidth:Number,unscaledHeight:Number):void
	{
		textFrame.x = 0;
		textFrame.y = getTextInitializeY() - textMoveBy;
		
		//Do not need set height here,it set by auto.
		textFiled.width = unscaledWidth;
	}
	
	/**
	 * @private
	 * @param num Number of move to step.
	 */
	private function textMoveByPosition(pos:int,byTime:Boolean = true):void
	{
		var times:Array = lyricData.times;
		var num:Number = 0;
		for(var i:int=0;i<times.length;i++)
		{
			var compareNum:int = position;
			if(byTime)
			{
				compareNum += 500; 
			}
			if((compareNum + 500)<= Number(times[i]))
			{
				//trace(compareNum)
				num = i - 1;
				num = Math.max(num,0);
				break;
			}
		}
		
		textMoveByStep(num);
	}
	
	/**
	 * @private
	 * @param num Number of move to step.
	 */	
	private function textMoveByStep(num:int):void
	{
		var gap:int = num - step;
		if(gap == 0)
		{
			//textFrame.y -= 1;
		}
		else if(gap == 1 || gap == 2 )
		{
			step = num;
			textMoveBy = lineHeight*step;
			addEventListener(Event.EXIT_FRAME,textTweenerMove)
		}
		else if(gap > 1 || gap < 0)
		{
			step = num;
			textMoveBy = lineHeight*step;
			textFrame.y = getTextInitializeY() - lineHeight*step
		}
	}

	/**
	 * @private 
	 */		
	private function textTweenerMove(event:Event):void
	{
		if(!adjusting)
		{
			//trace("textMoveByTimePosition")
			var moveToY:int = getTextInitializeY() - textMoveBy;
		
			//var currposition:int = _lyricData.times[step];
			//var gap:Number = 2;
			textFrame.y -= 2; 
			if(textFrame.y <= moveToY)
				removeEventListener(Event.EXIT_FRAME,textTweenerMove);
		}
	}
	
	//--------------------------------------------------------------------------
    //
    //  		Event handler
    //
    //--------------------------------------------------------------------------
    
	private function startAdjustPlayPosition(event:MouseEvent):void
	{
		if(!adjusting && isTextCreated)
		{
			if(Tweener.isTweening(textFrame))
				Tweener.pauseTweens(textFrame);
				
			showAdjustStandLine();
		
			startAdjustMouseY = mouseY;
			statrAdjustTextY = textFrame.y;
		
			adjusting = true;
		}
	}
	
	private function adjustingPlayPosition(event:MouseEvent):void
	{
		if(adjusting)
		{
			textFrame.y = statrAdjustTextY + (mouseY - startAdjustMouseY );
			
			var middlePoint:Point = new Point(oldUnscaledWidth/2,middleY);
			var middleGolbePoint:Point = localToGlobal(middlePoint);
			var textLocalPoint:Point = normalText.globalToLocal(middleGolbePoint);
			
			//Counts the times index
			var textIndex:int = normalText.getLineIndexAtPoint(textLocalPoint.x,textLocalPoint.y +2)
			var timeIndex:int = textIndex - numHeadLines;
			if(timeIndex<0)
			{
				timeIndex = 0;
			}
			
			var tp:int = lyricData.times[timeIndex];
			
			_position = tp;
			//trace(position);
			adjustPositionClewText.text = TimeFormatter.MSELToMMSS(position);
			
			//trace(gp.x + ":" + gp.y + "-" + lp.x + ":" + lp.y + "=" + String(textField.getLineIndexAtPoint(lp.x,int(lp.y) +2)))
		}
	}
	
	private function endAdjustPlayPosition(event:MouseEvent):void
	{
		if(adjusting)
		{
			//trace("endAdjustPlayPosition");
			clearAdjustStandLine();
		
			adjusting = false;
		
			var changeEvent:PositionChangeEvent = new PositionChangeEvent(position);
			dispatchEvent(changeEvent);
		}
	}
	
	//--------------------------------------------------------------------------
    //
    //  		Methods:private
    //
    //--------------------------------------------------------------------------
    
	/**
	 * @private
	 * Resets the textFrame`s point and variables that about moving. 
	 */		
	private function resetTextPosition():void
	{
		textFrame.x = 0;
		textFrame.y = getTextInitializeY();
		
		step = 0;
		textMoveBy = 0;
			
	}
	
	/**
	 * @private
	 * @return highLightTextMask`s y
	 */		
	private function getHighLightTextMaskY():int
	{
		return middleY - highLightTextMask.height/2;
	}
	
	/**
	 * @private
	 * @return The textFrame`s y when lyric show beginning.
	 */	
	private function getTextInitializeY():int
	{
		return getHighLightTextMaskY() - topHight
	}
	
	/**
	 * @private
	 * create the stand line and time clew at the middle of the component. 
	 */		
	private function showAdjustStandLine():void
	{
		if(isTextCreated && !adjusting)
		{
			//draws stand line
			adjustPositionClew = new Sprite();
			var g:Graphics = adjustPositionClew.graphics;
			g.lineStyle(1,0xff9122,0.5);
			g.moveTo(0,0);
			g.lineTo(oldUnscaledWidth,0);
			adjustPositionClew.x = 0;
			adjustPositionClew.y = middleY;
			
			//create the time show
			adjustPositionClewText = new TextField();
			var style:TextFormat = new TextFormat();
			style.color = 0xff9122;
			style.size = 9;
			style.align = TextFormatAlign.RIGHT;
			adjustPositionClewText.defaultTextFormat = style;
			adjustPositionClewText.text = "00:00"
			adjustPositionClewText.x = oldUnscaledWidth - 100;;
			adjustPositionClewText.y = 3;
			
			adjustPositionClew.addChild(adjustPositionClewText);
			
			addChild(adjustPositionClew);
		}
	}
	
	/**
	 * @private
	 * remove the stand line and time clew.  
	 */	
	private function clearAdjustStandLine():void
	{
		if(adjusting)
		{
			adjustPositionClew.graphics.clear();
			adjustPositionClew.removeChild(adjustPositionClewText);
			adjustPositionClewText = null;
			removeChild(adjustPositionClew);
			adjustPositionClew = null;
		}
	}
	
	/**
	 * 
	 * @param event
	 * 
	 */	
	public function adjuestLyricStepPosition(adjuestSecound:int,step:int):void
	{
		if(step<0 || step>=lyricData.times.length || adjuestSecound ==0)
		{
			return;
		}
		if(adjuestSecound<0)
		{
			aheadLyricStepPosition(adjuestSecound,step);
		}
		else if(adjuestSecound>0)
		{
			delayLyricStepPosition(adjuestSecound,step);
		}
		dispatchEvent(new Event("lyrciDataEdited"));
	}
	
	private function aheadLyricStepPosition(adjuestSecound:int,step:int):void
	{
		var times:Array = this.lyricData.times;
		var adjuestTime:int = times[step] + adjuestSecound;
		if(adjuestTime > 0)
		{
			var prevStep:int = Math.max(0,step-1);
			if(step == 0 || adjuestTime > times[prevStep])
			{
				times[step] = adjuestTime;
			}
			else
			{
				textMoveByStep(prevStep);
			}
		}
	}
	
	private function delayLyricStepPosition(adjuestSecound:int,step:int):void
	{
		var times:Array = this.lyricData.times;
		var adjuestTime:int = times[step] + adjuestSecound;
		var lastindex:int = times.length -1
		var nextSetp:int = Math.min(lastindex,step + 1);
		if(step == lastindex || adjuestTime < times[nextSetp])
		{
			times[step] = adjuestTime;
		}
		else
		{
			textMoveByStep(nextSetp);
		}
		
	}
	
	private var lock:Boolean = true;
	public function adjuestLyricAllPosition(millisecond:int):void
	{
		if(lock)
		{
			lock = false;
		}
		else
		{
			return;
		}
		var times:Array = lyricData.times
		/* var adjHeadNum:int = times[0] + millisecond
		if(adjHeadNum <0)
		{
			times[0] = 0;
		} 
		else
		{
			times[0] = adjHeadNum;
		} */
		var slength:int = times.length;
		for(var i:int = 0; i<slength;i++)
		{
			var adjNum:Number = times[i] + millisecond;
			//if(adjNum>500)
			//{
				times[i] = adjNum;
			//}
			//else
			//{
				//times[i] = times[i]/2;
			//}
		}
		//trace("position:"+this.position);
		//trace("position:"+this.lyricData.times.toString());
		textMoveByPosition(this.position,false);
		
		lock = true;
		dispatchEvent(new Event("lyrciDataEdited"));	
	}
}
}