﻿/*** GTweener by Grant Skinner. Oct 19, 2009* Visit www.gskinner.com/blog for documentation, updates and more free code.*** Copyright (c) 2009 Grant Skinner* * Permission is hereby granted, free of charge, to any person* obtaining a copy of this software and associated documentation* files (the "Software"), to deal in the Software without* restriction, including without limitation the rights to use,* copy, modify, merge, publish, distribute, sublicense, and/or sell* copies of the Software, and to permit persons to whom the* Software is furnished to do so, subject to the following* conditions:* * The above copyright notice and this permission notice shall be* included in all copies or substantial portions of the Software.* * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR* OTHER DEALINGS IN THE SOFTWARE.**/package lg.flash.motion {	import flash.utils.Dictionary;	import lg.flash.motion.GTween;		/**	* <b>GTweener ©2009 Grant Skinner, gskinner.com. Visit www.gskinner.com/libraries/gtween/ for documentation, updates and more free code. Licensed under the MIT license - see the source file header for more information.</b>	* <hr>	* GTweener is an experimental class that provides a static interface and basic	* override management for GTween. It adds about 1kb to GTween. With GTweener, if you tween a value that is	* already being tweened, the new tween will override the old tween for only that	* value. The old tween will continue tweening other values uninterrupted.	* <br/><br/>	* GTweener also serves as an interesting example for utilizing GTween's "*" plugin	* registration feature, where a plugin can be registered to run for every tween.	* <br/><br/>	* GTweener introduces a small amount overhead to GTween, which may have a limited impact	* on performance critical scenarios with large numbers (thousands) of tweens.	**/	public class GTweener {			// Protected Static Properties:		/** @private **/		protected static var tweens:Dictionary;		/** @private **/		protected static var instance:GTweener;			// Initialization:		staticInit();		/** @private **/		protected static function staticInit():void {			tweens = new Dictionary(true);			instance = new GTweener();						// register to be called any time a tween inits or tweens:			GTween.installPlugin(instance, ["*"]);		}				/** @private **/		public function init(tween:GTween, name:String, value:Number):Number {			// don't do anything.			return value;		}				/** @private **/		public function tween(tween:GTween, name:String, value:Number, initValue:Number, rangeValue:Number, ratio:Number, end:Boolean):Number {			// if the tween has just completed and it is currently being managed by GTweener			// then remove it:			if (end && tween.pluginData.GTweener) {				remove(tween);			}			return value;		}		// Public Static Methods:		/**		* Tweens the target to the specified values.		**/		public static function to(target:Object=null, duration:Number=1, values:Object=null, props:Object=null, pluginData:Object=null):GTween {			var tween:GTween = new GTween(target, duration, values, props, pluginData);			add(tween);			return tween;		}				/**		* Tweens the target from the specified values to its current values.		**/		public static function from(target:Object=null, duration:Number=1, values:Object=null, props:Object=null, pluginData:Object=null):GTween {			var tween:GTween = to(target, duration, values, props, pluginData);			tween.swapValues();			return tween;		}				/**		* Adds a tween to be managed by GTweener.		**/		public static function add(tween:GTween):void {			var target:Object = tween.target;			var list:Array = tweens[target];			if (list) {				clearValues(target,tween.getValues());			} else {				list = tweens[target] = [];			}			list.push(tween);			tween.pluginData.GTweener = true;		}				/**		* Gets the tween that is actively tweening the specified property of the target, or null		* if none.		**/		public static function getTween(target:Object, name:String):GTween {			var list:Array = tweens[target];			if (list == null) { return null; }			var l:uint = list.length;			for (var i:uint=0; i<l; i++) {				var tween:GTween = list[i];				if (!isNaN(tween.getValue(name))) { return tween; }			}			return null;		}				/**		* Returns an array of all tweens that GTweener is managing for the specified target.		**/		public static function getTweens(target:Object):Array {			return tweens[target] || [];		}				/**		* Pauses all tweens that GTweener is managing for the specified target.		**/		public static function pauseTweens(target:Object,paused:Boolean=true):void {			var list:Array = tweens[target];			if (list == null) { return; }			var l:uint = list.length;			for (var i:uint=0; i<l; i++) {				list[i].paused = paused;			}		}				/**		* Resumes all tweens that GTweener is managing for the specified target.		**/		public static function resumeTweens(target:Object):void {			pauseTweens(target,false);		}				/**		* Removes a tween from being managed by GTweener.		**/		public static function remove(tween:GTween):void {			delete(tween.pluginData.GTweener);			var list:Array = tweens[tween.target];			if (list == null) { return; }			var l:uint = list.length;			for (var i:uint=0; i<l; i++) {				if (list[i] == tween) {					list.splice(i,1);					return;				}			}		}				/**		* Removes all tweens that GTweener is managing for the specified target.		**/		public static function removeTweens(target:Object):void {			pauseTweens(target);			var list:Array = tweens[target];			if (list == null) { return; }			var l:uint = list.length;			for (var i:uint=0; i<l; i++) {				delete(list[i].pluginData.GTweener);			}			delete(tweens[target]);		}			// Protected Static Methods:		/** @private **/		protected static function clearValues(target:Object, values:Object):void {			for (var n:String in values) {				var tween:GTween = getTween(target,n);				if (tween) { tween.deleteValue(n); }			}		}			}	}