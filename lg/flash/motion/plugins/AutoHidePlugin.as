﻿/*** AutoHidePlugin by Grant Skinner. Nov 3, 2009* Visit www.gskinner.com/blog for documentation, updates and more free code.*** Copyright (c) 2009 Grant Skinner* * Permission is hereby granted, free of charge, to any person* obtaining a copy of this software and associated documentation* files (the "Software"), to deal in the Software without* restriction, including without limitation the rights to use,* copy, modify, merge, publish, distribute, sublicense, and/or sell* copies of the Software, and to permit persons to whom the* Software is furnished to do so, subject to the following* conditions:* * The above copyright notice and this permission notice shall be* included in all copies or substantial portions of the Software.* * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR* OTHER DEALINGS IN THE SOFTWARE.**/package lg.flash.motion.plugins {	import lg.flash.motion.GTween;	import lg.flash.motion.plugins.IGTweenPlugin;		/**	* Plugin for GTween. Sets the visible of the target to false if its alpha is 0 or less.	* <br/><br/>	* Supports the following <code>pluginData</code> properties:<UL>	* <LI> AutoHideEnabled: overrides the enabled property for the plugin on a per tween basis.	* </UL>	**/	public class AutoHidePlugin implements IGTweenPlugin {			// Static interface:		/** Specifies whether this plugin is enabled for all tweens by default. **/		public static var enabled:Boolean=true;				/** @private **/		protected static var instance:AutoHidePlugin;		/** @private **/		protected static var tweenProperties:Array = ["alpha"];				/**		* Installs this plugin for use with all GTween instances.		**/		public static function install():void {			if (instance) { return; }			instance = new AutoHidePlugin();			GTween.installPlugin(instance,tweenProperties);		}			// Public methods:		/** @private **/		public function init(tween:GTween, name:String, value:Number):Number {			return value;		}				/** @private **/		public function tween(tween:GTween, name:String, value:Number, initValue:Number, rangeValue:Number, ratio:Number, end:Boolean):Number {			// only change the visibility if the plugin is enabled:			if (((tween.pluginData.AutoHideEnabled == null && enabled) || tween.pluginData.AutoHideEnabled)) {				if (tween.target.visible != (value > 0)) { tween.target.visible = (value > 0); }			}			return value;		}			}	}