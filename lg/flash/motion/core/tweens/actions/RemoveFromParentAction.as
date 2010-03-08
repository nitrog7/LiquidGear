﻿/*
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
package lg.flash.motion.core.tweens.actions
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import lg.flash.motion.core.ticker.ITicker;
	import lg.flash.motion.core.tweens.AbstractActionTween;
	
	/**
	 * 指定された DisplayObject を親から削除する動作を行うアクショントゥイーンです.
	 * 
	 * @author	yossy:beinteractive
	 */
	public class RemoveFromParentAction extends AbstractActionTween
	{
		public function RemoveFromParentAction(ticker:ITicker, target:DisplayObject)
		{
			super(ticker);
			
			_target = target;
		}
		
		private var _target:DisplayObject;
		private var _parent:DisplayObjectContainer;
		
		public function get target():DisplayObject
		{
			return _target;
		}
		
		override protected function action():void 
		{
			if (_target != null && _target.parent != null) {
				_parent = _target.parent;
				_parent.removeChild(_target);
			}
		}
		
		override protected function rollback():void 
		{
			if (_target != null && _parent != null) {
				_parent.addChild(_target);
				_parent = null;
			}
		}
	}
}