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
package lg.flash.motion.core.tweens
{
	import lg.flash.motion.core.easing.IEasing;
	import lg.flash.motion.core.updaters.IUpdater;
	import lg.flash.motion.tweens.IObjectTween;
	
	/**
	 * IObjectTween 完全版.
	 * 
	 * @author	yossy:beinteractive
	 */
	public interface IIObjectTween extends IObjectTween, IITween
	{
		/**
		 * このトゥイーンに掛ける時間 (秒) を設定します.
		 */
		function get time():Number;
		
		/**
		 * @private
		 */
		function set time(value:Number):void;
		
		/**
		 * このトゥイーンで使用するイージングを設定します.
		 */
		function get easing():IEasing;
		
		/**
		 * @private
		 */
		function set easing(value:IEasing):void;
		
		/**
		 * このトゥイーンで使用するアップデータを設定します.
		 */
		function get updater():IUpdater;
		
		/**
		 * @private
		 */
		function set updater(value:IUpdater):void;
	}
}