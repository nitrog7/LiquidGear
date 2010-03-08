/**
 * Tween Class by Giraldo Rosales.
* Visit www.liquidgear.net for documentation and updates.
*
*
* Copyright (c) 2010 Nitrogen Design, Inc. All rights reserved.
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
	import lg.flash.motion.Tweener;
	import lg.flash.motion.tweens.ITween;
	import lg.flash.motion.tweens.ITweenGroup;
	
	/**
	*	<p>Extends BetweenAS3 functionality.</p>
	*/
	public class Tween extends ElementDispatcher {
		public var tween:ITween;
		public var serial:ITweenGroup;
		
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
			
			var element:Object		= obj.target;
			
			//Set defaults
			data.duration			= 0;
			data.delay				= 0;
			data.autoPlay			= true;
			data.ease				= null;
			data.visible			= null;
			data.onChange			= null;
			data.onChangeParams		= null;
			data.onPlay				= null;
			data.onPlayParams		= null;
			data.onStop				= null;
			data.onStopParams		= null;
			data.onUpdate			= null;
			data.onUpdateParams		= null;
			
			//Only get properties that are in the element
			var tweenObj:Object		= {};
			var dspObj:DisplayObject;
			
			for(var s:String in obj) {
				if(element.hasOwnProperty(s)) {
					if(s == 'alpha' && element is DisplayObject) {
						dspObj	= element as DisplayObject;
						
						if(obj.alpha == 0 && dspObj.visible) {
							data.visible	= false;
						} else if(obj.alpha > 0 && !dspObj.visible) {
							data.visible	= true;
						}
					}
					
					if(!(s in data)) {
						tweenObj[s]	= obj[s];
					}
				}
				
				data[s]	= obj[s];
			}
			
			var tween:ITween	= Tweener.to(element, tweenObj, data.duration, data.ease);
			
			if(data.delay > 0) {
				Tweener.delay(tween, data.delay);
			}
			
			var tweenFnc:ITween;
			
			//Auto hide
			if(data.visible != null && dspObj) {
				if(data.visible) {
					var tweenShow:ITween	= Tweener.func(onShowElement, [dspObj]);
					serial					= Tweener.serial(tweenShow, tween);
				} else {
					var tweenHide:ITween	= Tweener.func(onHideElement, [dspObj]);
					serial					= Tweener.serial(tween, tweenHide);
				}
				
				tweenFnc	= serial as ITween;
			} else {
				tweenFnc	= tween;
			}
			
			//Set functions
			var fnc:Function;
			
			if(data.onComplete != null) {
				fnc					= data.onComplete as Function;
				tweenFnc.onComplete	= fnc;
				
				if(data.onCompleteParams != null) {
					tweenFnc.onCompleteParams	= data.onCompleteParams as Array;
				}
			}
			
			if(data.onPlay != null) {
				fnc				= data.onPlay as Function;
				tweenFnc.onPlay	= fnc;
				
				if(data.onPlayParams != null) {
					tweenFnc.onPlayParams	= data.onPlayParams as Array;
				}
			}
			
			if(data.onStop != null) {
				fnc				= data.onStop as Function;
				tweenFnc.onStop	= fnc;
				
				if(data.onStopParams != null) {
					tweenFnc.onStopParams	= data.onStopParams as Array;
				}
			}
			
			if(data.onUpdate != null) {
				fnc					= data.onUpdate as Function;
				tweenFnc.onUpdate	= fnc;
				
				if(data.onUpdateParams != null) {
					tweenFnc.onUpdateParams	= data.onUpdateParams as Array;
				}
			}
			
			//Autoplay
			if(data.autoPlay) {
				tweenFnc.play();
			}
		}
		
		/** @private **/
		private function onShowElement(element:DisplayObject):void {
			element.visible	= true;
		}
		
		/** @private **/
		private function onHideElement(element:DisplayObject):void {
			element.visible	= false;
		}
		
		/** Play animation. **/
		public function play():void {
			if(serial) {
				serial.play();
			}
			else if(tween) {
				tween.play();
			}
		}
		
		/** Stop animation. **/
		public function stop():void {
			if(serial) {
				serial.stop();
			}
			else if(tween) {
				tween.stop();
			}
		}
		
		/** Reference to the TweenMax object **/
		public function get currentProgress():Number {
			if(tween) {
				return tween.position;
			} else {
				return 0;
			}
		}
	}
}