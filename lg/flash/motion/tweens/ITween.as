/**
 * ITween Class by yossy:beinteractive.
 * Visit www.liquidgear.net for documentation and updates.
 *
 *
 * Copyright (c) 2009 BeInteractive! (www.be-interactive.org) and
 *                    Spark project  (www.libspark.org)
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 **/

package lg.flash.motion.tweens {
	import flash.events.IEventDispatcher;
	
	/**
	 * Tween the control.
	 * @author	yossy:beinteractive
	 */
	public interface ITween extends IEventDispatcher {
		/** Tween duration in seconds. */
		function get duration():Number;
		
		/** Current position. */
		function get position():Number;
		
		/** Tween is currently playing, true or false. */
		function get isPlaying():Boolean;
		
		/** Stop tweening on completion. */
		function get stopOnComplete():Boolean;
		
		/** @private */
		function set stopOnComplete(value:Boolean):void;
		/** @private */
		function get onPlay():Function;
		/** @private */
		function set onPlay(value:Function):void;
		/** @private */
		function get onPlayParams():Array;
		/** @private */
		function set onPlayParams(value:Array):void;
		/** @private */
		function get onStop():Function;
		/** @private */
		function set onStop(value:Function):void;
		/** @private */
		function get onStopParams():Array;
		/** @private */
		function set onStopParams(value:Array):void;
		/** @private */
		function get onUpdate():Function;
		/** @private */
		function set onUpdate(value:Function):void;
		/** @private */
		function get onUpdateParams():Array;
		/** @private */
		function set onUpdateParams(value:Array):void;
		/** @private */
		function get onComplete():Function;
		/** @private */
		function set onComplete(value:Function):void;
		/** @private */
		function get onCompleteParams():Array;
		/** @private */
		function set onCompleteParams(value:Array):void;
		
		/** Start playing tween from current position. */
		function play():void;
		
		/** Stop tween animation. */
		function stop():void;
		
		/** Pause or resume playback. */
		function togglePause():void;
		
		/** 
		 * Start playing from specified position.
		 * 
		 * @param	position	Start playing from position in seconds.
		 */
		function gotoAndPlay(position:Number):void;
		
		/**
		 * Goto specified position and stop playing.
		 * 
		 * @param	position	Stop at position in seconds.
		 */
		function gotoAndStop(position:Number):void;
		
		/**
		 * Creates a clone of ITween.
		 * 
		 * @return	Clone of ITween.
		 */
		function clone():ITween;
	}
}