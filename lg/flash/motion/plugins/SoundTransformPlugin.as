﻿/** * SoundTransformPlugin Class by Giraldo Rosales. * Visit www.liquidgear.net for documentation and updates. * * Based on SoundTransformPlugin by Grant Skinner. *  * Copyright (c) 2011 Nitrogen Labs, Inc. All rights reserved. *  * Permission is hereby granted, free of charge, to any person * obtaining a copy of this software and associated documentation * files (the "Software"), to deal in the Software without * restriction, including without limitation the rights to use, * copy, modify, merge, publish, distribute, sublicense, and/or sell * copies of the Software, and to permit persons to whom the * Software is furnished to do so, subject to the following * conditions: *  * The above copyright notice and this permission notice shall be * included in all copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR * OTHER DEALINGS IN THE SOFTWARE. **/package lg.flash.motion.plugins {	import flash.media.Sound;	import flash.media.SoundChannel;	import flash.media.SoundTransform;		import lg.flash.motion.Tween;	import lg.flash.motion.plugins.ITweenPlugin;		/**	* Plugin for Tween. Tweens the volume, pan, leftToLeft, leftToRight, rightToLeft, and rightToRight	* properties of the target's soundTransform object.	* <br/><br/>	* Supports the following <code>pluginData</code> properties:<UL>	* <LI> SoundTransformEnabled: overrides the enabled property for the plugin on a per tween basis.	* </UL>	**/	public class SoundTransformPlugin implements ITweenPlugin {		/** Specifies whether this plugin is enabled for all tweens by default. **/		public static var enabled:Boolean=true;				/** @private **/		protected static var instance:SoundTransformPlugin;		/** @private **/		protected static var tweenProperties:Array = ["leftToLeft", "leftToRight", "pan", "rightToLeft", "rightToRight", "volume"];				/**		* Installs this plugin for use with all Tween instances.		**/		public static function install():void {			if (instance) { return; }			instance = new SoundTransformPlugin();			Tween.installPlugin(instance, tweenProperties, true);		}				/** @private **/		public function init(tween:Tween, name:String, value:Number):Number {			if (!((enabled && tween.pluginData.SoundTransformEnabled == null) || tween.pluginData.SoundTransformEnabled)) { return value; }						return tween.target.soundTransform[name];		}				/** @private **/		public function tween(tween:Tween, name:String, value:Number, initValue:Number, rangeValue:Number, ratio:Number, end:Boolean):Number {			if (!((enabled && tween.pluginData.SoundTransformEnabled == null) || tween.pluginData.SoundTransformEnabled)) { return value; }						var soundTransform:SoundTransform = tween.target.soundTransform;			soundTransform[name] =  value;			tween.target.soundTransform = soundTransform;						// tell Tween not to use the default assignment behaviour:			return NaN;		}	}}