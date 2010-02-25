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
	
	import lg.flash.elements.Element;
	import lg.flash.elements.VisualElement;
	import lg.flash.events.ElementDispatcher;
	import lg.flash.events.ElementEvent;
	import lg.flash.motion.GTween;
	import lg.flash.motion.plugins.*;
	
	/**
	*	<p>Extends GTween functionality to provide additional features.</p>
	*/
	public class Tween extends ElementDispatcher {
		public var element:VisualElement;
		
		/** @private **/
		private var _tween:GTween;
		/** 
		*	Constructs a new Tween object
		*	@param obj Object containing all properties to construct the Shape class.
		**/
		public function Tween(obj:Object=null) {
			//Set defaults
			data.duration			= 0;
			data.onChangeParams		= null;
			data.onCompleteParams	= null;
			data.onInitParams		= null;
			
			var propName:Array	= [
				'autoPlay',
				'calculatedPosition',
				'calculatedPositionOld',
				'data',
				'defaultDispatchEvents',
				'defaultEase',
				'delay',
				'dispatchEvents',
				'duration', 
				'ease',
				'nextTween',
				'pauseAll',
				'paused',
				'pluginData',
				'position',
				'positionOld',
				'proxy',
				'ratio',
				'ratioOld',
				'reflect',
				'repeatCount',
				'suppressEvents',
				'target',
				'timeScale',
				'timeScaleAll',
				'useFrames',
				'version'
			];
			
			//AutoHidePlugin properties
			var piAlphaEnable:int		= 0;
			
			//BlurPlugin properties
			var piBlurEnable:int		= 0;
			var piBlurProp:Array		= [
				'blur',
				'blurX',
				'blurY'
			];
			
			//ColorAdjustPlugin properties
			var piColorAdjustEnable:int	= 0;
			var piColorAdjustProp:Array	= [
				'brightness',
				'contrast',
				'hue'
			];
			
			//ColorTransformPlugin properties
			var piColorTransEnable:int	= 0;
			var piColorTransProp:Array	= [
				'redMultiplier',
				'greenMultiplier',
				'blueMultiplier',
				'alphaMultiplier',
				'redOffset',
				'greenOffset',
				'blueOffset',
				'alphaOffset',
				'tint'
			];
			
			//CurrentFramePlugin properties
			var piCurFrameEnable:int	= 0;
			var piCurFrameProp:Array	= ['currentFrame'];
			
			//MatrixPlugin properties
			var piMatrixEnable:int		= 0;
			var piMatrixProp:Array		= [
				'a',
				'b',
				'c',
				'd',
				'tx',
				'ty'
			];
			
			//MotionBlurPlugin properties
			var piMotionEnable:int		= 0;
			
			//SmartRotationPlugin properties
			var piRotationEnable:int	= 0;
			
			//SnappingPlugin properties
			var piSnapEnable:int		= 0;
			
			//SoundTransformPlugin properties
			var piSoundEnable:int		= 0;
			var piSoundProp:Array		= [
				'volume',
				'pan',
				'leftToLeft',
				'leftToRight',
				'rightToLeft',
				'rightToRight'
			];
			
			var tweenObj:Object	= {};
			var propObj:Object	= {};
			var plugObj:Object	= {};
			
			//Set Attributes
			for(var s:String in obj) {
				if(propName.indexOf(s) >= 0) {
					propObj[s] = obj[s];
				}
				else if(s == 'onChange') {
					data.onChange	= obj[s];
					
					if(obj.onChangeParams != undefined) {
						data.onChangeParams	= obj.onChangeParams;
					}
					
					propObj.onChange	= onChange;
				}
				else if(s == 'onComplete') {
					data.onComplete		= obj[s];
					
					if(obj.onCompleteParams != undefined) {
						data.onCompleteParams	= obj.onCompleteParams;
					}
					
					propObj.onComplete	= onComplete;
				}
				else if(s == 'onInit') {
					data.onInit		= obj[s];
					
					if(obj.onInitParams != undefined) {
						data.onInitParams	= obj.onInitParams;
					}
					
					propObj.onInit	= onInit;
				}
				else if(s == 'autoAlpha') {
					piAlphaEnable++;
					tweenObj.alpha	= obj[s];
				}
				else if(s == 'motionBlur') {
					piMotionEnable++;
					plugObj.strength	= obj[s];
				}
				else if(obj[s] && s == 'smartRotation') {
					piRotationEnable++;
				}
				else if(obj[s] && s == 'snap') {
					piSnapEnable++;
				}
				else if(propName.indexOf(s) < 0) {
					if(hasOwnProperty(s)) {
						tweenObj[s] 		= obj[s];
					}
				}
				
				if(piBlurProp.indexOf(s) >= 0) {
					piBlurEnable++;
				}
				
				if(piColorAdjustProp.indexOf(s) >= 0) {
					piColorAdjustEnable++;
				}
				
				if(piColorAdjustProp.indexOf(s) >= 0) {
					piColorTransEnable++;
				}
				
				if(piCurFrameProp.indexOf(s) >= 0) {
					piCurFrameEnable++;
				}
				
				if(piMatrixProp.indexOf(s) >= 0) {
					piMatrixEnable++;
				}
				
				if(piSoundProp.indexOf(s) >= 0) {
					piSoundEnable++;
				}
				
				data[s] = obj[s];
			}
			
			
			//Enable AutoHidePlugin
			if(piAlphaEnable) {
				AutoHidePlugin.install();
			}
			//Enable BlurPlugin
			if(piBlurEnable) {
				BlurPlugin.install();
			}
			//Enable ColorAdjustPlugin
			if(piColorAdjustEnable) {
				ColorAdjustPlugin.install();
			}
			//Enable ColorAdjustPlugin
			if(piColorTransEnable) {
				ColorTransformPlugin.install();
			}
			//Enable ColorAdjustPlugin
			if(piCurFrameProp) {
				CurrentFramePlugin.install();
			}
			//Enable MatrixPlugin
			if(piMatrixEnable) {
				MatrixPlugin.install();
			}
			//Enable MotionBlurPlugin
			if(piMotionEnable) {
				MotionBlurPlugin.install();
			}
			//Enable SmartRotationPlugin
			if(piRotationEnable) {
				SmartRotationPlugin.install();
			}
			//Enable SnappingPlugin
			if(piSoundEnable) {
				SnappingPlugin.install();
			}
			//Enable SoundTransformPlugin
			if(piSnapEnable) {
				SoundTransformPlugin.install();
			}
			
			//Set target
			if('target' in data) {
				element	= data.target as VisualElement;
			}
			
			//TweenPlugin.activate([FramePlugin, BevelFilterPlugin, BlurFilterPlugin, RemoveTintPlugin, TintPlugin, DropShadowFilterPlugin, VisiblePlugin, ColorMatrixFilterPlugin, VolumePlugin, HexColorsPlugin, GlowFilterPlugin, AutoAlphaPlugin, EndArrayPlugin]);
			
			_tween	= new GTween(data.target, data.duration, tweenObj, propObj);
			//_tween.addEventListener(TweenEvent.START, onInit);
			//_tween.addEventListener(TweenEvent.UPDATE, onChange);
			//_tween.addEventListener(TweenEvent.COMPLETE, onComplete);
		}
		
		/** Reference to the TweenMax object **/
		public function get tweener():GTween {
			return _tween;
		}
		
		/** Reference to the TweenMax object **/
		public function get currentProgress():Number {
			if(_tween) {
				return _tween.calculatedPosition;
			} else {
				return 0;
			}
		}
		
		/** @private **/
		private function onInit(tween:GTween):void {
			if(data.onInit) {
				var fnc:Function	= data.onInit as Function;
				
				if(data.onCompleteParams) {
					fnc(data.onInitParams);
				} else {
					fnc();
				}
			}
		}
		
		/** @private **/
		private function onChange(tween:GTween):void {
			if(data.onChange) {
				var fnc:Function	= data.onChange as Function;
				
				if(data.onCompleteParams) {
					fnc(data.onChangeParams);
				} else {
					fnc();
				}
			}
		}
		
		/** @private **/
		private function onComplete(tween:GTween):void {
			trace('Tween::onComplete');
			if(data.onComplete) {
				var fnc:Function	= data.onComplete as Function;
				
				if(data.onCompleteParams) {
					fnc(data.onCompleteParams);
				} else {
					fnc();
				}
			}
		}
	}
}