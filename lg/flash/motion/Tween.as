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
	import lg.flash.motion.Tweener;
	import lg.flash.motion.core.easing.IEasing;
	import lg.flash.motion.tweens.ITween;
	import lg.flash.motion.tweens.ITweenGroup;
	
	/**
	*	<p>Extends BetweenAS3 functionality.</p>
	*/
	public class Tween extends ElementDispatcher {
		public var target:Object		= 0;
		public var ease:IEasing;
		public var autoPlay:Boolean		= true;
		public var tween:ITween;
		public var serial:ITweenGroup;
		
		private var _tweens:Array		= [];
		private var _parallel:ITweenGroup;
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
			
			target					= obj.target;
			
			//Set defaults
			data.target				= null;
			data.duration			= 0.01;
			data.delay				= 0;
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
			data.onComplete			= null;
			data.onCompleteParams	= null;
			
			//Only get properties that are in the element
			var tweenObj:Object		= {};
			var dspObj:DisplayObject;
			var ignore:Array		= ['delay'];
			
			for(var s:String in obj) {
				if(target.hasOwnProperty(s)) {
					if(s == 'alpha' && target is DisplayObject) {
						dspObj	= target as DisplayObject;
						
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
				else if(hasOwnProperty(s) && ignore.indexOf(s) < 0) {
					this[s]	= obj[s];
				} else {
					data[s]	= obj[s];
				}
			}
			
			//Create tween
			var tween:ITween	= Tweener.to(target, tweenObj, duration, ease);
			var tweenFnc:ITween;
			
			//Auto hide
			if(data.visible != null && dspObj) {
				if(data.visible) {
					var tweenShow:ITween	= Tweener.func(onShowElement, [dspObj]);
					serial					= Tweener.serial([tweenShow, tween]);
				} else {
					var tweenHide:ITween	= Tweener.func(onHideElement, [dspObj]);
					serial					= Tweener.serial([tween, tweenHide]);
				}
				
				tweenFnc	= serial as ITween;
			} else {
				tweenFnc	= tween;
			}
			
			_tweens.push(tweenFnc);
			
			//Set delay
			setDelay(data.delay);
			
			//Combine tweens
			_parallel		= Tweener.parallel(_tweens);
			
			//Set functions
			var fnc:Function;
			
			if(data.onComplete != null) {
				fnc						= data.onComplete as Function;
				_parallel.onComplete	= fnc;
				
				if(data.onCompleteParams != null) {
					_parallel.onCompleteParams	= data.onCompleteParams as Array;
				}
			}
			
			if(data.onPlay != null) {
				fnc					= data.onPlay as Function;
				_parallel.onPlay	= fnc;
				
				if(data.onPlayParams != null) {
					_parallel.onPlayParams	= data.onPlayParams as Array;
				}
			}
			
			if(data.onStop != null) {
				fnc				= data.onStop as Function;
				_parallel.onStop	= fnc;
				
				if(data.onStopParams != null) {
					_parallel.onStopParams	= data.onStopParams as Array;
				}
			}
			
			if(data.onUpdate != null) {
				fnc					= data.onUpdate as Function;
				_parallel.onUpdate	= fnc;
				
				if(data.onUpdateParams != null) {
					_parallel.onUpdateParams	= data.onUpdateParams as Array;
				}
			}
			
			//Autoplay
			if(autoPlay) {
				play();
			}
		}
		
		public function set duration(value:Number):void {
			if(value <= 0) {
				data.duration	= 0.01;
			} else {
				data.duration	= value;
			}
		}
		public function get duration():Number {
			return data.duration;
		}
		
		/** @private **/
		private function onShowElement(element:DisplayObject):void {
			element.visible	= true;
		}
		
		/** @private **/
		private function onHideElement(element:DisplayObject):void {
			element.visible	= false;
		}
		
		public function get delay():Number {
			var value:Number	= data.delay as Number;
			return value;
		}
		
		public function setDelay(value:Number):void {
			data.delay	= value;
			
			if(value > 0) {
				var tweenLen:int	= _tweens.length;
				var t:ITween;
				var d:ITween;
				var delayArr:Array	= [];
				
				for(var g:int=0; g<tweenLen; g++) {
					t			= _tweens[g] as ITween;
					d			= Tweener.delay(t, delay);
					delayArr[g]	= d;
				}
				
				_tweens	= delayArr;
			}
		}
		
		/** Play animation. **/
		public function play():void {
			_parallel.play();
		}
		
		/** Stop animation. **/
		public function stop():void {
			_parallel.stop();
		}
		
		/** Reference to the TweenMax object **/
		public function get currentProgress():Number {
			if(_parallel) {
				return _parallel.position;
			} else {
				return 0;
			}
		}
		
		/** Indicates whether tween is playing. **/
		public function get isPlaying():Boolean {
			if(_parallel) {
				return _parallel.isPlaying;
			} else {
				return false;
			}
		}
		
		/** Goto tween position and play. **/
		public function gotoAndPlay(position:Number):void {
			if(_parallel) {
				_parallel.gotoAndPlay(position);
			}
		}
		
		/** Goto tween position and stop. **/
		public function gotoAndStop(position:Number):void {
			if(_parallel) {
				_parallel.gotoAndStop(position);
			}
		}
		
		/** Play tween in reverse. **/
		public function reverse():void {
			if(_parallel) {
				Tweener.reverse(_parallel);
			}
		}
		
		/** Repeat a tween. **/
		public function loop(times:int):void {
			if(_parallel) {
				Tweener.repeat(_parallel, times);
			}
		}
		
		/** Scale time duration for a tween. **/
		public function timeScale(amount:Number):void {
			if(_parallel) {
				Tweener.scale(_parallel, amount);
			}
		}
		
		public function set bezier(obj:Object):void {
			var t:ITween;
			var to:Object		= (obj.to != undefined) ? obj.to as Object : null;
			var from:Object		= (obj.from != undefined) ? obj.from as Object : null;
			var through:Object	= (obj.through != undefined) ? obj.through as Object : null;
			
			if(!through) {
				return;
			}
			
			if(to && !from) {
				t	= Tweener.bezierTo(target, to, through, duration, ease);
			}
			else if(!to && from) {
				t	= Tweener.bezierFrom(target, from, through, duration, ease);
			}
			else if(obj.to != undefined && obj.from != undefined) {
				t	= Tweener.bezier(target, to, from, through, duration, ease);
			}
			
			if(t) {
				_tweens.push(t);
			}
		}
	}
}