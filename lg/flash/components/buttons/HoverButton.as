/**
* HoverButton Class by Giraldo Rosales.
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

package lg.flash.components.buttons {
	//LG Classes
	import lg.flash.elements.Image;
	import lg.flash.elements.VisualElement;
	import lg.flash.events.ElementEvent;
	
	public class HoverButton extends VisualElement {
		private var _outClip:VisualElement;
		private var _overClip:VisualElement;
		private var _clickClip:VisualElement;
		
		public function HoverButton(obj:Object) {
			super();
			
			button();
			
			data.out		= null;
			data.over		= null;
			data.click		= null;
			data.duration	= 0;
			data.stretch	= false;
			
			//Set Attributes
			setAttributes(obj);
			
			_outClip		= data.out as VisualElement;
			_outClip.ghost();
			_outClip.setPos(0, 0);
			addChild(_outClip);
			
			if(data.over) {
				_overClip	= data.over as VisualElement;
				_overClip.ghost();
				_overClip.hide();
				_overClip.setPos(0, 0);
				addChild(_overClip);
			}
			
			if(data.click) {
				_clickClip	= data.click as VisualElement;
				_clickClip.ghost();
				_clickClip.hide();
				_clickClip.setPos(0, 0);
				addChild(_clickClip);
			}
			
			hover(onButtonOver, onButtonOut);
			click(onButtonClick);
			mousedown(onButtonClick);
			
			isSetup = true;
		}
		
		private function onButtonOut(e:ElementEvent):void {
			if(_outClip) _outClip.animate({duration:data.duration, alpha:1});
			if(_overClip) _overClip.animate({duration:data.duration, alpha:0});
			if(_clickClip) _clickClip.animate({duration:data.duration, alpha:0});
		}
		
		private function onButtonOver(e:ElementEvent):void {
			if(_outClip) _outClip.animate({duration:data.duration, alpha:0});
			if(_overClip) _overClip.animate({duration:data.duration, alpha:1});
			if(_clickClip) _clickClip.animate({duration:data.duration, alpha:0});
		}
		
		private function onButtonClick(e:ElementEvent):void {
			if(_outClip) _outClip.animate({duration:data.duration, alpha:0});
				
			if(_clickClip) {
				_clickClip.animate({duration:data.duration, alpha:1});
				if(_overClip) _overClip.animate({duration:data.duration, alpha:0});
			} else {
				if(_overClip) _overClip.animate({duration:data.duration, alpha:1});	
			}
		}
		
		public override function set width(value:Number):void {
			data.width		= value;
			
			if(!isNaN(data.width)) {
				if(_outClip) _outClip.width		= data.width;
				if(_overClip) _overClip.width		= data.width;
				if(_clickClip) _clickClip.width	= data.width;
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
			
			if(!isNaN(data.height)) {
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