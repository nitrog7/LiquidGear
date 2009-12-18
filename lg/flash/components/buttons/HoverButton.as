/**
* HoverButton Class by Giraldo Rosales.
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

package lg.flash.components.buttons {
	//LG Classes
	import lg.flash.events.ElementEvent;
	import lg.flash.elements.VisualElement;
	
	public class HoverButton extends VisualElement {
		private var _outClip:VisualElement;
		private var _overClip:VisualElement;
		private var _clickClip:VisualElement;
		
		public function HoverButton(obj:Object) {
			super();
			
			cacheAsBitmap	= true;
			button();
			
			data.out		= null;
			data.over		= null;
			data.click		= null;
			data.duration	= 0;
			data.stretch	= false;
			
			//Set Attributes
			setAttributes(obj);
			
			_outClip			= data.out as VisualElement;
			
			if(data.over) {
				_overClip		= data.over as VisualElement;
			} else {
				_overClip		= data.out as VisualElement;
			}
			
			if(data.click) {
				_clickClip		= data.click as VisualElement;
			} else {
				_clickClip		= data.out as VisualElement;
			}
			
			_outClip.ghost();
			_overClip.ghost();
			_clickClip.ghost();
			
			_outClip.hidden		= false;
			_overClip.hidden	= true;
			_clickClip.hidden	= true;
			
			addChild(_outClip);
			addChild(_overClip);
			addChild(_clickClip);
			
			_outClip.setPos(0, 0);
			_overClip.setPos(0, 0);
			_clickClip.setPos(0, 0);
			
			hover(onButtonOver, onButtonOut);
			click(onButtonClick);
			mousedown(onButtonClick);
			
			isSetup = true;
		}
		
		private function onButtonOut(e:ElementEvent):void {
			if(data.duration > 0) {
				_overClip.animate({duration:data.duration, autoAlpha:0});
				_outClip.animate({duration:data.duration, autoAlpha:1});
				_clickClip.animate({duration:data.duration, autoAlpha:0});
			} else {
				_overClip.hidden	= true;
				_outClip.hidden		= false;
				_clickClip.hidden	= true;
			}
		}
		
		private function onButtonOver(e:ElementEvent):void {
			if(data.duration > 0) {
				_overClip.animate({duration:data.duration, autoAlpha:1});
				_outClip.animate({duration:data.duration, autoAlpha:0});
				_clickClip.animate({duration:data.duration, autoAlpha:0});
			} else {
				_overClip.hidden	= false;
				_outClip.hidden		= true;
				_clickClip.hidden	= true;
			}
		}
		
		private function onButtonClick(e:ElementEvent):void {
			if(data.duration > 0) {
				_overClip.animate({duration:data.duration, autoAlpha:0});
				_outClip.animate({duration:data.duration, autoAlpha:0});
				_clickClip.animate({duration:data.duration, autoAlpha:1});
			} else {
				_overClip.hidden	= true;
				_outClip.hidden		= true;
				_clickClip.hidden	= false;
			}
		}
		
		public override function set width(value:Number):void {
			data.width		= value;
			
			if(data.width != undefined && data.width >= 0) {
				_outClip.width		= data.width;
				_overClip.width		= data.width;
				_clickClip.width	= data.width;
			}
		}
		
		public override function get width():Number {
			if(data.width != undefined && data.width >= 0) {
				return data.width;
			} else {
				return super.width;
			}
		}
		
		public override function set height(value:Number):void {
			data.height			= value;
			
			if(data.width != undefined && data.width >= 0) {
				_outClip.height		= data.height;
				_overClip.height	= data.height;
				_clickClip.height	= data.height;
			}
		}
		
		public override function get height():Number {
			if(data.height != undefined && data.height >= 0) {
				return data.height;
			} else {
				return super.height;
			}
		}
		
		public override function kill():void {
			unbind('element_mouseout', onButtonOut);
			unbind('element_mouseover', onButtonOver);
			
			removeChild(_outClip);
			removeChild(_overClip);
			removeChild(_clickClip);
			
			_outClip	= null;
			_overClip	= null;
			_clickClip	= null;
		}
	}
}