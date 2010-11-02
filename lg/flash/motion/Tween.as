/**
 * Tween Class by Giraldo Rosales.
* Visit www.liquidgear.net for documentation and updates.
*
*
* Copyright (c) 2010 Nitrogen Labs, Inc. All rights reserved.
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
	import flash.events.Event;
	
	import lg.flash.elements.Element;
	import lg.flash.elements.VisualElement;
	import lg.flash.events.ElementDispatcher;
	import lg.flash.events.ElementEvent;
	import lg.flash.motion.TweenMax;
	import lg.flash.motion.easing.Linear;
	import lg.flash.motion.events.TweenEvent;
	
	/**
	*	<p>Extends BetweenAS3 functionality.</p>
	*/
	public class Tween extends ElementDispatcher {
		public var tween:TweenMax;
		
		/** 
		*	Constructs a new Tween object
		*	@param obj Object containing all properties to construct the class.
		**/
		public function Tween(obj:Object=null) {
			super();
			
			//Set target
			if(!('target' in obj)) {
				return;
			}
			
			//Default
			var dsp:Object		= obj.target;
			
			//Set defaults
			data.duration			= 0;
			data.delay				= 0;
			data.immediateRender	= true;
			data.overwrite			= 2;
			
			//Get properties
			var propObj:Object	= {};
			var ignore:Array	= ['duration'];
			var extra:Array		= ['autoAlpha','delay','paused','ease','easeParams','reversed','immediateRender','overwrite','startAt','bezier','bezierThrough',
				'repeat','repeatDelay','yoyo','onInit','onInitParams','onStart','onStartParams','onComplete','onCompleteParams','immediateRender',
				'onUpdate','onUpdateParams','onRepeat','onRepeatParams','onReverseComplete','onReverseCompleteParams','overwrite'];
			
			if(obj.alpha != undefined) {
				obj.autoAlpha	= obj.alpha;
				delete obj.alpha;
			}
			
			for(var s:String in obj) {
				if((s in dsp || extra.indexOf(s) >= 0) && ignore.indexOf(s) < 0) {
					propObj[s]	= obj[s];
				}
				
				data[s]	= obj[s];
			}
			
			//Create tween
			tween	= TweenMax.to(dsp, data.duration, propObj);
		}
		
		/** The current progress of the tween. **/
		public function set currentProgress(value:Number):void {
			tween.currentProgress	= value;
		}
		public function get currentProgress():Number {
			return tween.currentProgress;
		}
		
		/** The length of the delay in frames or seconds **/
		public function set delay(value:Number):void {
			tween.delay	= value;
		}
		public function get delay():Number {
			return tween.delay;
		}
		
		/** The length of the tween in frames or seconds **/
		public function set duration(value:Number):void {
			if(value <= 0) {
				data.duration	= 0;
			} else {
				data.duration	= value;
			}
			
			tween.duration	= data.duration;
		}
		public function get duration():Number {
			return data.duration;
		}
		
		/** Callback for the change event. **/
		public function set onChange(value:Function):void {
			data.onChange	= value;
			
			if(value != null) {
				tween.addEventListener(TweenEvent.UPDATE, updateTween);
			} else {
				tween.removeEventListener(TweenEvent.UPDATE, updateTween);
			}
		}
		public function get onChange():Function {
			return data.onChange;
		}
		/** Callback parameters for the change event. **/
		public function set onChangeParams(value:Array):void {
			data.onChangeParams	= value;
		}
		public function get onChangeParams():Array {
			var value:Array	= data.onChangeParams as Array;
			
			if(value && value.length == 0) {
				value	= null;
			}
			
			return value;
		}
		private function updateTween(t:TweenEvent):void {
			var fnc:Function	= data.onChange as Function;
			
			if(data.onChangeParams) {
				fnc(data.onChangeParams);
			} else if (fnc != null) {
				fnc();
			}
		}
		
		/** Callback for the complete event. **/
		public function set onComplete(value:Function):void {
			data.onComplete		= value;
			
			if(value != null) {
				tween.addEventListener(TweenEvent.COMPLETE, finishTween);
			} else {
				tween.removeEventListener(TweenEvent.COMPLETE, finishTween);
			}
		}
		public function get onComplete():Function {
			return data.onComplete;
		}
		/** Callback parameters for the complete event. **/
		public function set onCompleteParams(value:Array):void {
			data.onCompleteParams	= value;
		}
		public function get onCompleteParams():Array {
			var value:Array	= data.onCompleteParams as Array;
			
			if(value && value.length == 0) {
				value	= null;
			}
			
			return value;
		}
		private function finishTween(t:TweenEvent):void {
			var fnc:Function	= data.onComplete as Function;
			
			if (fnc != null) {
				if(data.onCompleteParams) {
					fnc(data.onCompleteParams);
				} else {
					fnc();
				}
			}
		}
		
		/** Callback for the init event. **/
		public function set onInit(value:Function):void {
			data.onInit	= value;
			
			if(value != null) {
				tween.addEventListener(TweenEvent.INIT, finishTween);
			} else {
				tween.removeEventListener(TweenEvent.INIT, startTween);
			}
		}
		public function get onInit():Function {
			return data.onInit;
		}
		/** Callback parameters for the init event. **/
		public function set onInitParams(value:Array):void {
			data.onInitParams	= value;
		}
		public function get onInitParams():Array {
			var value:Array	= data.onInitParams as Array;
			
			if(value && value.length == 0) {
				value	= null;
			}
			
			return value;
		}
		private function startTween(t:TweenEvent):void {
			var fnc:Function	= data.onInit as Function;
			
			if(data.onInitParams) {
				fnc(data.onInitParams);
			} else if (fnc != null) {
				fnc();
			}
		}
		
		/** The target object to tween. **/
		public function set target(value:Object):void {
			tween.target	= value;
		}
		public function get target():Object {
			var dsp:Object;
			
			if(tween) {
				dsp	= tween.target;
			}
			
			return dsp;
		}
		
		/** Play animation. **/
		public function play():void {
			tween.paused	= false;
		}
		
		/** Stop animation. **/
		public function stop():void {
			tween.paused	= true;
		}
	}
}