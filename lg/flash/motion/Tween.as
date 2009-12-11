/**
* Tween Class by Giraldo Rosales.
* Visit www.liquidgear.net for documentation and updates.
*
*
* Copyright (c) 2009 Nitrogen Design, Inc. All rights reserved.
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
	//Flash Classes
	import flash.events.Event;
	
	//LG Classes
	import lg.flash.elements.Element;
	import lg.flash.elements.VisualElement;
	import lg.flash.events.ElementEvent;
	import lg.flash.events.TweenEvent;
	import lg.flash.motion.TweenMax;
	import lg.flash.motion.plugins.*;
	
	/**
	*	<p>Extends GTween functionality to provide additional features.</p>
	*/
	public class Tween extends Element {
		public var element:VisualElement;
		
		/** @private **/
		private var _tween:TweenMax;
		/** 
		*	Constructs a new Tween object
		*	@param obj Object containing all properties to construct the Shape class.
		**/
		public function Tween(obj:Object=null) {
			//Set defaults
			data.duration		= 0;
			data.overwrite		= 2;
			
			var ignore:Array	= ['duration', 'target'];
			var tweenObj:Object	= {};
			
			//Set Attributes
			for(var s:String in obj) {
				if(ignore.indexOf(s) < 0) {
					tweenObj[s] = obj[s];
				}
				data[s] = obj[s];
			}
			
			if('target' in data) {
				element	= data.target as VisualElement;
			}
			
			TweenPlugin.activate([FramePlugin, BevelFilterPlugin, BlurFilterPlugin, RemoveTintPlugin, TintPlugin, DropShadowFilterPlugin, VisiblePlugin, ColorMatrixFilterPlugin, VolumePlugin, HexColorsPlugin, GlowFilterPlugin, AutoAlphaPlugin, EndArrayPlugin]);
			
			_tween	= new TweenMax(data.target, data.duration, tweenObj);
			_tween.addEventListener(TweenEvent.START, onInit);
			_tween.addEventListener(TweenEvent.UPDATE, onChange);
			_tween.addEventListener(TweenEvent.COMPLETE, onComplete);
		}
		
		/** Reference to the TweenMax object **/
		public function get tweener():TweenMax {
			return _tween;
		}
		
		/** Reference to the TweenMax object **/
		public function get currentProgress():Number {
			if(_tween) {
				return _tween.currentProgress;
			} else {
				return 0;
			}
		}
		
		/** If Element is tweening **/
		public static function isTweening(el:Element):Boolean {
			return TweenMax.isTweening(el);
		}
		
		
		/** @private **/
		private function onInit(e:TweenEvent):void {
			if(element) {
				element.trigger('element_tween_start', e);
			} else {
				trigger('element_tween_start', e);
			}
		}
		
		/** @private **/
		private function onChange(e:TweenEvent):void {
			if(element) {
				element.trigger('element_tween_update', e);
			} else {
				trigger('element_tween_update', e);
			}
		}
		
		/** @private **/
		private function onComplete(e:TweenEvent):void {
			if(element) {
				element.trigger('element_tween_end', e);
			} else {
				trigger('element_tween_end', e);
			}
		}
	}
}