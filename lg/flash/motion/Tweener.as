/**
 * Tweener Class by yossy:beinteractive.
 * 
 * Modified by Giraldo Rosales
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

package lg.flash.motion {
	//Flash
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	//LG
	import lg.flash.motion.core.easing.IEasing;
	import lg.flash.motion.core.easing.IPhysicalEasing;
	import lg.flash.motion.core.ticker.ITicker;
	import lg.flash.motion.core.tweens.actions.AddChildAction;
	import lg.flash.motion.core.tweens.actions.FunctionAction;
	import lg.flash.motion.core.tweens.actions.RemoveFromParentAction;
	import lg.flash.motion.core.tweens.decorators.DelayedTween;
	import lg.flash.motion.core.tweens.decorators.RepeatedTween;
	import lg.flash.motion.core.tweens.decorators.ReversedTween;
	import lg.flash.motion.core.tweens.decorators.ScaledTween;
	import lg.flash.motion.core.tweens.decorators.SlicedTween;
	import lg.flash.motion.core.tweens.groups.ParallelTween;
	import lg.flash.motion.core.tweens.groups.SerialTween;
	import lg.flash.motion.core.tweens.IITween;
	import lg.flash.motion.core.tweens.ObjectTween;
	import lg.flash.motion.core.tweens.PhysicalTween;
	import lg.flash.motion.core.tweens.TweenDecorator;
	import lg.flash.motion.core.updaters.BezierUpdater;
	import lg.flash.motion.core.updaters.display.DisplayObjectUpdater;
	import lg.flash.motion.core.updaters.display.MovieClipUpdater;
	import lg.flash.motion.core.updaters.geom.PointUpdater;
	import lg.flash.motion.core.updaters.ObjectUpdater;
	import lg.flash.motion.core.updaters.UpdaterFactory;
	import lg.flash.motion.core.utils.ClassRegistry;
	import lg.flash.motion.easing.Linear;
	import lg.flash.motion.easing.Physical;
	import lg.flash.motion.tickers.EnterFrameTicker;
	import lg.flash.motion.tweens.IObjectTween;
	import lg.flash.motion.tweens.ITween;
	import lg.flash.motion.tweens.ITweenGroup;
	
	/**
	 * @author	yossy:beinteractive
	 */
	public class Tweener {
		// TODO
		// SmartRotation
		// frame based
		
		/** @private **/
		private static var _ticker:ITicker;
		/** @private **/
		private static var _updaterClassRegistry:ClassRegistry;
		/** @private **/
		private static var _updaterFactory:UpdaterFactory;
		
		{
			_ticker = new EnterFrameTicker();
			_ticker.start();
			
			_updaterClassRegistry = new ClassRegistry();
			_updaterFactory = new UpdaterFactory(_updaterClassRegistry);
			
			ObjectUpdater.register(_updaterClassRegistry);
			DisplayObjectUpdater.register(_updaterClassRegistry);
			MovieClipUpdater.register(_updaterClassRegistry);
			PointUpdater.register(_updaterClassRegistry);
		}
		
		/**
		 * Create a new tween. Set the start and ending values.
		 * 
		 * @param	target	Tween target
		 * @param	to		End value
		 * @param	from	Start value
		 * @param	time	Duration of animation
		 * @param	easing	Easing function
		 * @return	Tween created
		 */
		public static function tween(target:Object, to:Object, from:Object = null, time:Number = 1.0, easing:IEasing = null):IObjectTween {
			var tween:ObjectTween	= new ObjectTween(_ticker);
			tween.updater	= _updaterFactory.create(target, to, from);
			tween.time		= time;
			tween.easing	= easing || Linear.easeNone;
			return tween;
		}
		
		/**
		 * Create a new tween. Starting from the current position and sets a destination.
		 * 
		 * @param	target	Tween target
		 * @param	to		End value
		 * @param	time	Duration of animation
		 * @param	easing	Easing function
		 * @return	Tween created
		 */
		public static function to(target:Object, to:Object, time:Number = 1.0, easing:IEasing = null):IObjectTween {
			var tween:ObjectTween = new ObjectTween(_ticker);
			tween.updater	= _updaterFactory.create(target, to, null);
			tween.time		= time;
			tween.easing	= easing || Linear.easeNone;
			return tween;
		}
		
		/**
		 * Create a new tween. Set the start position and the destination is set to the current position.
		 * 
		 * @param	target	Tween target
		 * @param	from	Start value
		 * @param	time	Duration of animation
		 * @param	easing	Easing function
		 * @return	Tween created
		 */
		public static function from(target:Object, from:Object, time:Number = 1.0, easing:IEasing = null):IObjectTween {
			var tween:ObjectTween = new ObjectTween(_ticker);
			tween.updater = _updaterFactory.create(target, null, from);
			tween.time = time;
			tween.easing = easing || Linear.easeNone;
			return tween;
		}
		
		/**
		 * Tween the object and then apply the value.
		 * 
		 * @param	target		Tween target
		 * @param	to			Start value
		 * @param	from		End value
		 * @param	time		Duration of animation
		 * @param	applyTime	Time to apply
		 * @param	easing		Easing function
		 */
		public static function apply(target:Object, to:Object, from:Object = null, time:Number = 1.0, applyTime:Number = 1.0, easing:IEasing = null):void {
			var tween:ObjectTween = new ObjectTween(_ticker);
			tween.updater = _updaterFactory.create(target, to, from);
			tween.time = time;
			tween.easing = easing || Linear.easeNone;
			tween.update(applyTime);
		}
		
		/**
		 * Create a new bezier tween. Set the start and ending values.
		 * 
		 * @param	target			Tween target
		 * @param	to				Start value
		 * @param	from			End value
		 * @param	controlPoint	Control points
		 * @param	time			Duration of animation
		 * @param	easing			Easing function
		 * @return	Tween created
		 */
		public static function bezier(target:Object, to:Object, from:Object = null, controlPoint:Object = null, time:Number = 1.0, easing:IEasing = null):IObjectTween {
			var tween:ObjectTween = new ObjectTween(_ticker);
			tween.updater = _updaterFactory.createBezier(target, to, from, controlPoint);
			tween.time = time;
			tween.easing = easing || Linear.easeNone;
			return tween;
		}
		
		/**
		 * Create a new bezier tween. Starting from the current position and sets a destination.
		 * 
		 * @param	target			Tween target
		 * @param	to				Start value
		 * @param	controlPoint	Control points
		 * @param	time			Duration of animation
		 * @param	easing			Easing function
		 * @return	Tween created
		 */
		public static function bezierTo(target:Object, to:Object, controlPoint:Object = null, time:Number = 1.0, easing:IEasing = null):IObjectTween {
			var tween:ObjectTween = new ObjectTween(_ticker);
			tween.updater = _updaterFactory.createBezier(target, to, null, controlPoint);
			tween.time = time;
			tween.easing = easing || Linear.easeNone;
			return tween;
		}
		
		/**
		 * Create a new bezier tween. Set the start position and the destination is set to the current position.
		 * 
		 * @param	target			Tween target
		 * @param	from			End value
		 * @param	controlPoint	Control points
		 * @param	time			Duration of animation
		 * @param	easing			Easing function
		 * @return	Tween created
		 */
		public static function bezierFrom(target:Object, from:Object, controlPoint:Object = null, time:Number = 1.0, easing:IEasing = null):IObjectTween {
			var tween:ObjectTween = new ObjectTween(_ticker);
			tween.updater = _updaterFactory.createBezier(target, null, from, controlPoint);
			tween.time = time;
			tween.easing = easing || Linear.easeNone;
			return tween;
		}
		
		/**
		 * Create a new physical tween. Set the start and ending values.
		 * 
		 * @param	target	Tween target
		 * @param	to		Start value
		 * @param	from	End value
		 * @param	easing	Easing function
		 * @return	Tween created
		 */
		public static function physical(target:Object, to:Object, from:Object = null, easing:IPhysicalEasing = null):IObjectTween {
			var tween:PhysicalTween = new PhysicalTween(_ticker);
			tween.updater = _updaterFactory.createPhysical(target, to, from, easing || Physical.exponential());
			return tween;
		}
		
		/**
		 * Create a new physical tween. Starting from the current position and sets a destination.
		 * 
		 * @param	target	Tween target
		 * @param	to		Start value
		 * @param	easing	Easing function
		 * @return	Tween created
		 */
		public static function physicalTo(target:Object, to:Object, easing:IPhysicalEasing = null):IObjectTween {
			var tween:PhysicalTween = new PhysicalTween(_ticker);
			tween.updater = _updaterFactory.createPhysical(target, to, null, easing || Physical.exponential());
			return tween;
		}
		
		/**
		 * Create a new physical tween. Set the start position and the destination is set to the current position.
		 * 
		 * @param	target	Tween target
		 * @param	from	End value
		 * @param	easing	Easing function
		 * @return	Tween created
		 */
		public static function physicalFrom(target:Object, from:Object, easing:IPhysicalEasing = null):IObjectTween {
			var tween:PhysicalTween = new PhysicalTween(_ticker);
			tween.updater = _updaterFactory.createPhysical(target, null, from, easing || Physical.exponential());
			return tween;
		}
		
		/**
		 * Tween physical and apply the values.
		 * 
		 * @param	target		Tween target
		 * @param	to			Start value
		 * @param	from		End value
		 * @param	applyTime	Time to apply
		 * @param	easing		Easing function
		 */
		public static function physicalApply(target:Object, to:Object, from:Object = null, applyTime:Number = 1.0, easing:IPhysicalEasing = null):void {
			var tween:PhysicalTween = new PhysicalTween(_ticker);
			tween.updater = _updaterFactory.createPhysical(target, to, from, easing || Physical.exponential());
			tween.update(applyTime);
		}
		
		/**
		 * Run concurrent tweens.
		 * 
		 * @param	...tweens	Array of tweens
		 * @return	Tween created
		 */
		public static function parallel(...tweens:Array):ITweenGroup {
			return parallelTweens(tweens);
		}
		
		/**
		 * Run all tweens in the array concurrently.
		 * 
		 * @param	tweens	Array of tweens
		 * @return	Tween created
		 */
		public static function parallelTweens(tweens:Array):ITweenGroup {
			return new ParallelTween(tweens, _ticker, 0);
		}
		
		/**
		 * Run tweens in order, one after the other.
		 * 
		 * @param	...tweens	Array of tweens
		 * @return	Tween created
		 */
		public static function serial(...tweens:Array):ITweenGroup {
			return serialTweens(tweens);
		}
		
		/**
		 * Run tweens in order, one after the other.
		 * 
		 * @param	tweens	結合するトゥイーンの配列
		 * @return	Tween created
		 */
		public static function serialTweens(tweens:Array):ITweenGroup {
			return new SerialTween(tweens, _ticker, 0);
		}
		
		/**
		 * Run the tween in reverse.
		 * 
		 * @param	tween			Original tween
		 * @param	reversePosition	If you set the position to the same position from which to create the tween, then true, otherwise false
		 * @return	Tween created
		 */
		public static function reverse(tween:ITween, reversePosition:Boolean = true):ITween {
			var pos:Number = reversePosition ? tween.duration - tween.position : 0.0;
			
			if (tween is ReversedTween) {
				return new TweenDecorator((tween as ReversedTween).baseTween, pos);
			}
			
			if ((tween as Object).constructor == TweenDecorator) {
				tween = (tween as TweenDecorator).baseTween;
			}
			
			return new ReversedTween(tween as IITween, pos);
		}
		
		/**
		 * Loop the tween.
		 * 
		 * @param	tween		Original tween
		 * @param	repeatCount	Number of times to repeat
		 * @return	Tween created
		 */
		public static function repeat(tween:ITween, repeatCount:uint):ITween {
			return new RepeatedTween(tween as IITween, repeatCount);
		}
		
		/**
		 * Scale the tween time.
		 * 
		 * @param	tween	Original tween
		 * @param	scale	Scale value
		 * @return	Tween created
		 */
		public static function scale(tween:ITween, scale:Number):ITween {
			return new ScaledTween(tween as IITween, scale);
		}
		
		/**
		 * Remove a tween.
		 * 
		 * @param	tween		Original tween
		 * @param	begin		Start time
		 * @param	end			End time
		 * @param	isPercent	If you specify a percentage of time to cut, set to true, otherwise false
		 * @return	Tween created
		 */
		public static function slice(tween:ITween, begin:Number, end:Number, isPercent:Boolean = false):ITween {
			if(isPercent) {
				begin = tween.duration * begin;
				end = tween.duration * end;
			}
			
			if(begin > end) {
				return new ReversedTween(new SlicedTween(tween as IITween, end, begin), 0);
			}
			
			return new SlicedTween(tween as IITween, begin, end);
		}
		
		/**
		 * Specify a delay for a tween.
		 * 
		 * @param	tween		Original tween
		 * @param	delay		Delay time before animation (seconds)
		 * @param	postDelay	Delay time after animation (seconds)
		 * @return	Tween created
		 */
		public static function delay(tween:ITween, delay:Number, postDelay:Number = 0.0):ITween {
			return new DelayedTween(tween as IITween, delay, postDelay);
		}
		
		/**
		 * Add a child to a parent after the tween.
		 * 
		 * @param	target	Child
		 * @param	parent	Parent
		 * @return	Tween created
		 */
		public static function addChild(target:DisplayObject, parent:DisplayObjectContainer):ITween {
			return new AddChildAction(_ticker, target, parent);
		}
		
		/**
		 * Remove a child from a parent after the tween.
		 * 
		 * @param	target	Child
		 * @return	Tween created
		 */
		public static function removeFromParent(target:DisplayObject):ITween {
			return new RemoveFromParentAction(_ticker, target);
		}
		
		/**
		 * Create a tween to perform the specified function.
		 * 
		 * @param	func			Function to perform
		 * @param	params			Function parameters
		 * @param	useRollback		Use a rollback function
		 * @param	rollbackFunc	Rollback function
		 * @param	rollbackParams	Rollback function parameters
		 * @return
		 */
		public static function func(func:Function, params:Array = null, useRollback:Boolean = false, rollbackFunc:Function = null, rollbackParams:Array = null):ITween {
			return new FunctionAction(_ticker, func, params, useRollback, rollbackFunc, rollbackParams);
		}
	}
}