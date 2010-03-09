/*
 * BetweenAS3
 * 
 * Licensed under the MIT License
 * 
 * Copyright (c) 2009 BeInteractive! (www.be-interactive.org) and
 *                    Spark project  (www.libspark.org)
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 */
package lg.flash.motion.core.tweens
{
	import lg.flash.motion.tweens.ITween;
	
	/**
	 * @author	yossy:beinteractive
	 */
	public class TweenDecorator extends AbstractTween {
		protected var _baseTween:IITween;
		
		public function TweenDecorator(baseTween:IITween, position:Number) {
			super(baseTween.ticker, position);
			
			_baseTween	= baseTween;
			_duration	= baseTween.duration;
		}
		
		public function get baseTween():IITween {
			return _baseTween;
		}
		
		/** @inheritDoc **/
		public override function play():void  {
			if (!_isPlaying) {
				_baseTween.firePlay();
				super.play();
			}
		}
		
		/** @inheritDoc **/
		public override function firePlay():void {
			super.firePlay();
			_baseTween.firePlay();
		}
		
		/** @inheritDoc **/
		public override function stop():void {
			if (_isPlaying) {
				super.stop();
				_baseTween.fireStop();
			}
		}
		
		/** @inheritDoc **/
		public override function fireStop():void {
			super.fireStop();
			_baseTween.fireStop();
		}
		
		/** @inheritDoc **/
		protected override function internalUpdate(time:Number):void {
			_baseTween.update(time);
		}
	}
}