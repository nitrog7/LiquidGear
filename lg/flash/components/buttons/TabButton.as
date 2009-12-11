/**
* TabButton Class by Giraldo Rosales.
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
	//Flash Classes
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.geom.*;
	import flash.filters.*;
	
	//LG Classes
	import lg.flash.events.*;
	import lg.flash.elements.Element;
	import lg.flash.motion.*;
	import lg.flash.motion.easing.*;
	
	public class TabButton extends Element {
		private var mc:Object				= {};
		
		private var _bgColor:uint			= 0x009ddc;
		private var _fgColor:uint			= 0x000000;
		private var _bgOver:uint			= 0x009ddc;
		private var _fgOver:uint			= 0x000000;
		
		private var _radius:int				= 6;
		private var _size:int				= 9;
		private var _align:String			= 'left';
		private var _selected:Boolean		= false;
		private var _toggle:Boolean			= false;
		
		private var _btnWidth:int			= 0;
		private var _btnHeight:int			= 0;
		
		private var _textColor:uint			= 0xFFFFFF;
		private var _textOverColor:uint		= 0xFFFFFF;
		private var _textSelectedColor:uint	= 0xFFFFFF;
		
		public function TabButton() {
			super();
		}
		
		public function init():void {
			button();
			
			mc['btn']		= new Sprite();
			mc['grad1']		= new Shape();
			mc['grad2']		= new Shape();
			mc['mask1']		= new Shape();
			mc['mask2']		= new Shape();
			mc['mask3']		= new Shape();
			mc['mask4']		= new Shape();
			mc['stroke']	= new Shape();
			mc['labelBg']	= new Shape();
		
			addChild(mc['btn']);
			mc['btn'].addChild(mc['labelBg']);
			mc['btn'].addChild(mc['grad1']);
			mc['btn'].addChild(mc['grad2']);
			mc['btn'].addChild(mc['mask1']);
			mc['btn'].addChild(mc['mask2']);
			mc['btn'].addChild(mc['mask3']);
			mc['btn'].addChild(mc['stroke']);
			addChild(mc['mask4']);
			
			_bgColor	= uint(vars['backgroundColor']);
			_fgColor	= uint(vars['foregroundColor']);
			_bgOver		= uint(vars['backgroundOver']);
			_fgOver		= uint(vars['foregroundOver']);
			
			mc['grad1'].mask	= mc['mask1'];
			mc['grad2'].mask	= mc['mask2'];
			mc['btn'].mask		= mc['mask3'];
			mask				= mc['mask4'];
			
			//Listeners
			hover(onHoverOver, onHoverOut);
			mousedown(onHoverDown);
			click(onHoverClick);
			
			//Position label
			addLabel();
			label.wordWrap	= false;
			label.multiline	= false;
			label.toFront();
			label.format	= vars['format'];
			label.htmlText	= vars['content'];
			
			//Size
			resizeTab();
		}
		
		public function create(w:int, h:int, fg:uint, bg:uint):void {
			mc['labelBg'].graphics.clear();
			mc['labelBg'].graphics.beginFill(bg, 1);
			mc['labelBg'].graphics.drawRect(0, 0, w, h);
			mc['labelBg'].graphics.endFill();
			
			var gradMatrix:Matrix;
			gradMatrix	= new Matrix();
			gradMatrix.createGradientBox(w, h, Math.PI*.5);
			
			mc['grad1'].graphics.clear();
			mc['grad1'].graphics.beginGradientFill(GradientType.LINEAR, [fg, fg], [.8, .5], [127, 255], gradMatrix);
			mc['grad1'].graphics.drawRect(0, 0, w, h);
			mc['grad1'].graphics.endFill();
			
			mc['mask1'].graphics.clear();
			mc['mask1'].graphics.beginFill(0x000000, 1);
			mc['mask1'].graphics.drawRect(0, h*.5, w, h*.5);
			mc['mask1'].graphics.endFill();
			
			mc['grad2'].graphics.clear();
			mc['grad2'].graphics.beginGradientFill(GradientType.LINEAR, [bg, fg], [0, .6], [0, 255], gradMatrix);
			mc['grad2'].graphics.drawRect(0, 0, w, h);
			mc['grad2'].graphics.endFill();
			
			mc['mask2'].graphics.clear();
			mc['mask2'].graphics.beginFill(0x000000, 1);
			mc['mask2'].graphics.drawRect(0, 0, w, h*.5);
			mc['mask2'].graphics.endFill();
			
			//Outline
			mc['stroke'].graphics.clear();
			mc['stroke'].graphics.lineStyle(1, uint(vars['lineColor']), 1);
			//mc['stroke'].graphics.lineGradientStyle(GradientType.LINEAR, [bg, fg], [0, .8], [0, 255], gradMatrix);
			mc['stroke'].graphics.beginFill(0x000000, 0);
			mc['stroke'].graphics.drawRoundRect(0, 0, w, h * 1.3, _radius);
			mc['stroke'].graphics.endFill();
			
			mc['mask3'].graphics.clear();
			mc['mask3'].graphics.beginFill(bg, 1);
			mc['mask3'].graphics.drawRoundRect(0, 0, w+1, h * 1.3, _radius);
			mc['mask3'].graphics.endFill();
			
			mc['mask4'].graphics.clear();
			mc['mask4'].graphics.beginFill(bg, 1);
			mc['mask4'].graphics.drawRect(0, 0, w+1, h);
			mc['mask4'].graphics.endFill();
			
			//Scale9
			//mc['btn'].scale9Grid	= new Rectangle(10, 4, w - 20, h - 8);
		}
		
		//Set size
		public override function set width(value:Number):void {
			vars['width']		= value;
			resizeTab();
		}
		public override function get width():Number {
			return mc['btn'].width;
		}
		public override function set height(value:Number):void {
			vars['height']		= value;
			resizeTab();
		}
		public override function get height():Number {
			return mc['btn'].height;
		}
		
		private function resizeTab():void {
			if(vars['width'] == undefined)
				_btnWidth	= label.textWidth + 20;
			else
				_btnWidth	= vars['width'];
			
			if(vars['height'] == undefined)
				_btnHeight	= label.textHeight * 2;
			else
				_btnHeight	= vars['height'];
			
			
			//Label
			label.x	= 7;//(_btnWidth/2) - (label.textWidth/2 - 3);
			label.y	= (_btnHeight*.5) - (label.textHeight*.5);
			
			//Button
			if('btn' in mc)
				create(_btnWidth, _btnHeight, _fgColor, _bgColor);
				
			mc['btn'].y	= _btnHeight;
		}
		
		//Toggle selected
		public function set selected(value:Boolean):void {
			var event:ElementEvent	= new ElementEvent(ElementEvent.CHANGE);
			_selected				= value;
			
			if(_selected) {
				//gotoAndStop('selected');
				label.color	= _textSelectedColor;
				create(_btnWidth, _btnHeight, _fgOver, _bgOver);
				tabOver();
				
				//Remove rollover listeners
				unbind(ElementEvent.OVER, onHoverOver);
				unbind(ElementEvent.OUT, onHoverOut);
			} else {
				//gotoAndStop('out');
				label.color	= _textColor;
				create(_btnWidth, _btnHeight, _fgColor, _bgColor);
				tabOut();
				
				//Add rollover listeners
				hover(onHoverOver, onHoverOut);
				
				//Send out action call
				event	= new ElementEvent(ElementEvent.CHANGE);
			}
			
			event.params	= vars;
			dispatchEvent(event);
		}
		public function get selected():Boolean {
			return _selected;
		}
		
		//Toggle select option
		public function set toggleBtn(value:Boolean):void {
			_toggle = value;
		}
		public function get toggleBtn():Boolean {
			return _toggle;
		}
		
		
		//Set text rollover color
		public function set textOverColor(value:uint):void {
			_textOverColor = value;
		}
		public function get textOverColor():uint {
			return _textOverColor;
		}
		
		//Set text selected color
		public function set textSelectedColor(value:uint):void {
			_textSelectedColor = value;
		}
		public function get textSelectedColor():uint {
			return _textSelectedColor;
		}
		
		//Set listeners
		private function onHoverOver(e:MouseEvent=null) {
			Tween.to(mc['btn'], .3, {y:0});
			
			if(!selected || !_toggle) {
				label.color	= _textOverColor;
			}
		}
		
		private function onHoverOut(e:MouseEvent=null) {
			Tween.to(mc['btn'], .3, {y:_btnHeight});
			
			if(!selected || !_toggle) {
				label.color	= _textColor;
			}
		}
		
		private function onHoverClick(e:MouseEvent):void {
			if(_toggle) {
				if(_selected)
					selected	= false;
				else
					selected	= true;
			}
		}
		
		private function onHoverDown(e:MouseEvent):void {
			label.color	= _textSelectedColor;
		}
		
		private function tabOver():void {
			Tween.to(mc['btn'], .5, {y:0});
		}
		
		
		private function tabOut():void {
			Tween.to(mc['btn'], .5, {y:_btnHeight});
		}
	}
}