/**
* ScrubberBar Class by Giraldo Rosales.
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
 
package lg.flash.components {
	//Flash
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	//LG
	import lg.flash.elements.VisualElement;
	import lg.flash.elements.Shape;
	import lg.flash.events.ElementEvent;
	import lg.flash.components.Scrubber;
	
	public class ScrubberBar extends VisualElement {		
		public var progressBar:VisualElement;
		public var backgroundBar:VisualElement;
		public var loadedBar:VisualElement;
		public var scrubber:Scrubber;
		public var value:Number	= 0;
		
		private var _barMask:Shape;
		private var _loadMask:Shape;
		private var _adjust:int;
		private var _adjustLoad:int;
		
		public function ScrubberBar(obj:Object) {
			super();
			holder();
			
			if(!obj.backgroundBar || !obj.progressBar) {
				return;
			}
			
			//Set Attributes
			graphics.clear();
			graphics.beginFill(0x000000, 0);
			graphics.drawRect(0, 0, obj.backgroundBar.width, obj.backgroundBar.height);
			graphics.endFill();
			
			for(var s:String in obj) {
				if(s in this && s != 'stage') {
					this[s] = obj[s];
				}
				data[s] = obj[s];
			}
			
			setPos(backgroundBar.x, backgroundBar.y);
			backgroundBar.setPos(0, 0);
			progressBar.setPos(0, 0);
			
			//Progress bar mask
			_barMask			= new Shape({id:'barMask', x:0, y:0, width:0, height:progressBar.height, fillAlpha:1});
			progressBar.mask	= _barMask;
			progressBar.ghost();
			
			//Load bar mask
			if(loadedBar) {
				_loadMask		= new Shape({id:'loadMask', x:0, y:0, width:0, height:loadedBar.height, fillAlpha:1});
				loadedBar.setPos(0, 0);
				loadedBar.mask	= _loadMask;
				loadedBar.ghost();
			}
			
			
			if(progressBar is Shape) {
				var pBar:Shape			= progressBar as Shape;
				data.progressBarColor	= pBar.color;
				data.progressBarGrad	= pBar.gradientColor;
			}
			
			addChild(backgroundBar);
			
			if(loadedBar) {
				addChild(loadedBar);
				addChild(_loadMask);	
			}
			
			addChild(progressBar);
			addChild(_barMask);	
			
			//Add click control to bar
			backgroundBar.button();
			backgroundBar.mouseover(onOverBar);
			backgroundBar.mouseout(onOutBar);
			backgroundBar.click(onClickBar);
			
			if(scrubber) {
				addChild(scrubber);
				//Add click control to scrub
				scrubber.mouseover(onOverBar);
				scrubber.mouseout(onOutBar);
				
				scrubber.mousedown(onDownScrub);
				scrubber.mouseout(onOutScrub);
				scrubber.mousemove(onMoveScrub);
				
				data.stage.addEventListener('mouseLeave', onUpScrub);
				data.stage.addEventListener('mouseUp', onUpScrub);
			}
			
			//Update initial progress
			update({current:0, duration:0});
		}
		
		public function get isScrubbing():Boolean {
			if(scrubber) {
				return scrubber.isDown;
			}
			
			return false;
		}
		
		private function onOverBar(e:ElementEvent):void {
			if(progressBar is Shape) {
				var pBar:Shape		= progressBar as Shape;
				pBar.color 			= 0xf1ba43;
				pBar.gradientColor	= 0xe26409;
			}
		}
		
		private function onOutBar(e:ElementEvent):void {
			if(progressBar is Shape) {
				var pBar:Shape		= progressBar as Shape;
				pBar.color 			= data.progressBarColor;
				pBar.gradientColor	= data.progressBarGrad;
			}
		}
		
		private function onClickBar(e:ElementEvent):void {
			adjust(backgroundBar.mouseX);
			trigger('element_click');
		}
		
		private function onDownScrub(e:ElementEvent):void {
			if(enabled) {
				scrubber.isDown	= true;
				var bounds:Rectangle	= new Rectangle(backgroundBar.x, 0, backgroundBar.x + backgroundBar.width, 0);
				scrubber.startDrag(false, bounds);
				scrubber.bind('element_enter', onMoveScrub);
			}
		}
		
		private function onMoveScrub(e:ElementEvent):void {
			if(enabled) {
				adjust(scrubber.x);
			}
		}
		
		private function onOutScrub(e:ElementEvent):void {
			if(!scrubber.isDown) {
				scrubber.unbind('element_enter', onMoveScrub);
				scrubber.stopDrag();
			}
		}
		
		private function onUpScrub(e:Event):void {
			scrubber.isDown	= false;
			scrubber.unbind('element_enter', onMoveScrub);
			scrubber.stopDrag();
		}
		
		public function adjust(num:int):void {
			if(num == _adjust) {
				return;
			}
			var clickScale:Number;
			_adjust	= num;
			
			clickScale		= num/backgroundBar.width;
			_barMask.width	= num;
				
			value = clickScale;
			
			if(scrubber && !scrubber.isDown) {
				scrubber.x	= num;
			}
		}
		
		public function adjustLoad(num:int):void {
			if(num == _adjustLoad) {
				return;
			}
			var clickScale:Number;
			_adjustLoad	= num;
			
			clickScale		= num/backgroundBar.width;
			_loadMask.width	= num;
		}
		
		public function adjustScale(num:Number):void {
			var clickScale:Number	= num * backgroundBar.width;
			_barMask.width			= clickScale;
			value					= clickScale;
			
			if(scrubber && !scrubber.isDown) {
				scrubber.x	= clickScale;
			}
		}
		
		public override function set enabled(value:Boolean):void {
			data.enabled	= value;
			
			if(value) {
				backgroundBar.click(onClickBar);
			} else {
				backgroundBar.unbind('element_click', onClickBar);
			}
		}
		
		public override function update(obj:Object=null):void {
			if(!obj || !_barMask) {
				return;
			}
			
			var duration:int	= int(obj.duration);
			
			if(duration > 0) {
				var current:int	= int(obj.current);
				var len:int		= (current / duration) * backgroundBar.data.width;
				
				//if(len != NaN) {
					adjust(len);
				//}
			} else {
				adjust(0);
			}
			
		}
	}
}