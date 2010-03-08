/**
* PushButton Class by Giraldo Rosales.
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

package lg.flash.components.buttons {
	//Flash Classes
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	//LG Classes
	import lg.flash.events.ElementEvent;
	import lg.flash.elements.Text;
	import lg.flash.elements.VisualElement;
	
	public class PushButton extends VisualElement {
		private var _label:Text;
		
		//Components
		private var _btn:Sprite			= new Sprite();
		private var _arrow:Sprite		= new Sprite();
		private var _tGrad:Sprite		= new Sprite();
		private var _bGrad:Sprite		= new Sprite();
		private var _gradMatrix:Matrix	= new Matrix();
		private var _borderSize:int		= 1;
		
		public function PushButton(obj:Object) {
			super();
			
			button();
			cacheAsBitmap	= true;
			
			data.backgroundColor	= 0x009ddc;
			data.foregroundColor	= 0x000000;
			data.bgHover			= 0x009ddc;
			data.fgHover			= 0x000000;
			data.bgSelected			= 0x009ddc;
			data.fgSelected			= 0x000000;
			data.radius				= 9;
			data.size				= 12;
			data.arrowSize			= 0;
			data.align				= 'left';
			data.selected			= false;
			data.toggle				= false;
			data.useArrow			= false;
			data.textColor			= 0xFFFFFF;
			data.textOverColor		= 0xFFFFFF;
			data.textSelectedColor	= 0xFFFFFF;
			
			//Set Attributes
			for(var s:String in obj) {
				if(s in this) {
					this[s] = obj[s];
				}
				data[s] = obj[s];
			}
		
			
			//Button
			addChild(_btn);
			_btn.addChild(_tGrad);
			_btn.addChild(_bGrad);
			
			if(useArrow) {
				addChild(_arrow);
			}
			
			//Listeners
			hover(onHoverOver, onHoverOut);
			mousedown(onHoverDown);
			click(onHoverClick);
			
			//Label
			_label		= new Text({id:'label', font:'_sans', color:textColor, embedFonts:false, bold:true, htmlText:data.label, size:data.size});
			addChild(_label);
			
			//Size
			isSetup	= true;
			resetSize();
		}
		
		private function resetSize():void {
			if(!isSetup || !_label) {
				return;
			}
			
			if(data.width < 0 && _label) {
				data.width	= _label.width * 1.5;
			}
			
			if(data.height < 0 && _label) {
				data.height	= _label.height * 1.5;
			}
			
			//Gradient
			_gradMatrix.createGradientBox(data.width, data.height*.5, Math.PI*.5);
			
			//Label
			if(_label) {
				_label.x	= (data.width*.5) - (_label.width*.5) - (arrowSize*.5) - 2;
				_label.y	= (data.height*.5) - (_label.height*.6);
			}
			
			//Arrow
			if(useArrow) {
				arrowSize		= _label.height * .9;
				_arrow.x		= (data.width*.5) + (_label.width*.5) + 2;
				_arrow.y		= (data.height*.5) - (arrowSize*.5);
			}
			
			//Button
			create();
		}
		
		public function create():void {
			if(!isSetup) {
				return;
			}
			
			if(selected) {
				setSelectedColor();
			} else {
				setDefaultColor();
			}
			
			//Arrow
			if(useArrow && _label) {
				arrowSize	= _label.height*.9;
				_arrow.graphics.beginFill(_label.color);
				_arrow.graphics.moveTo(0, 0);
				_arrow.graphics.lineTo(0, arrowSize);
				_arrow.graphics.lineTo(arrowSize*.5, arrowSize*.5);
				_arrow.graphics.lineTo(0, 0);
			}
		}
		
		//Set listeners
		private function onHoverOver(e:ElementEvent=null) {
			if(!selected || !toggleBtn) {
				setHoverColor();
				
				//Label
				_label.color	= textOverColor;
				
				if(useArrow) {
					_arrow.graphics.clear();
					_arrow.graphics.beginFill(textOverColor);
					_arrow.graphics.moveTo(0, 0);
					_arrow.graphics.lineTo(0, arrowSize);
					_arrow.graphics.lineTo(arrowSize*.5, arrowSize*.5);
					_arrow.graphics.lineTo(0, 0);
				}
			}
		}
		
		private function onHoverOut(e:ElementEvent=null) {
			if(!selected || !toggleBtn) {
				setDefaultColor();
				
				//Label
				_label.color	= textColor;
				
				if(useArrow) {
					_arrow.graphics.clear();
					_arrow.graphics.beginFill(textColor);
					_arrow.graphics.moveTo(0, 0);
					_arrow.graphics.lineTo(0, arrowSize);
					_arrow.graphics.lineTo(arrowSize*.5, arrowSize*.5);
					_arrow.graphics.lineTo(0, 0);
				}
			}
		}
		
		private function onHoverClick(e:ElementEvent):void {
			if(toggleBtn) {
				if(selected) {
					selected	= false;
				} else {
					selected	= true;
				}
			}
		}
		
		private function onHoverDown(e:ElementEvent):void {
			_label.color	= textSelectedColor;
			
			if(useArrow) {
				_arrow.graphics.clear();
				_arrow.graphics.beginFill(textSelectedColor);
				_arrow.graphics.moveTo(0, 0);
				_arrow.graphics.lineTo(0, arrowSize);
				_arrow.graphics.lineTo(arrowSize*.5, arrowSize*.5);
				_arrow.graphics.lineTo(0, 0);
			}
		}
		
		private function setDefaultColor():void {
			var gradH:int	= height * .5;
			var gradR:int	= radius * .5;
			
			_btn.graphics.clear();
			_btn.graphics.lineStyle(_borderSize, 0x000000, 1, true);
			_btn.graphics.beginFill(backgroundColor, 1);
			_btn.graphics.drawRoundRect(0, 0, width, height, radius);
			_btn.graphics.endFill();
			
			_tGrad.graphics.clear();
			_tGrad.graphics.beginGradientFill('linear', [backgroundColor, foregroundColor], [.5, .6], [0, 255], _gradMatrix);
			_tGrad.graphics.moveTo(0, gradR);
			_tGrad.graphics.curveTo(0, 0, gradR, 0);
			_tGrad.graphics.lineTo(width - gradR, 0);
			_tGrad.graphics.curveTo(width, 0, width, gradR);
			_tGrad.graphics.lineTo(width, gradH);
			_tGrad.graphics.lineTo(0, gradH);
			_tGrad.graphics.lineTo(0, gradR);
			_tGrad.graphics.endFill();
			
			_bGrad.y	= gradH;
			_bGrad.graphics.clear();
			_bGrad.graphics.beginGradientFill('linear', [foregroundColor, foregroundColor], [.8, .5], [0, 255], _gradMatrix);
			_bGrad.graphics.lineTo(width, 0);
			_bGrad.graphics.lineTo(width, gradH - gradR);
			_bGrad.graphics.curveTo(width, gradH, width - gradR, gradH);
			_bGrad.graphics.lineTo(gradR, gradH);
			_bGrad.graphics.curveTo(0, gradH, 0, gradH - gradR);
			_bGrad.graphics.lineTo(0, 0);
			_bGrad.graphics.endFill();
		}
		
		private function setHoverColor():void {
			var gradH:int	= height * .5;
			var gradR:int	= radius * .5;
			
			_btn.graphics.clear();
			_btn.graphics.lineStyle(_borderSize, bgHover, 1, true);
			_btn.graphics.beginFill(bgHover, 1);
			_btn.graphics.drawRoundRect(0, 0, width, height, radius);
			_btn.graphics.endFill();
			
			_tGrad.graphics.clear();
			_tGrad.graphics.beginGradientFill('linear', [bgHover, fgHover], [0, .6], [0, 255], _gradMatrix);
			_tGrad.graphics.moveTo(0, gradR);
			_tGrad.graphics.curveTo(0, 0, gradR, 0);
			_tGrad.graphics.lineTo(width - gradR, 0);
			_tGrad.graphics.curveTo(width, 0, width, gradR);
			_tGrad.graphics.lineTo(width, gradH);
			_tGrad.graphics.lineTo(0, gradH);
			_tGrad.graphics.lineTo(0, gradR);
			_tGrad.graphics.endFill();
			
			_bGrad.graphics.clear();
			_bGrad.graphics.beginGradientFill('linear', [fgHover, fgHover], [.8, .5], [127, 255], _gradMatrix);
			_bGrad.graphics.lineTo(width, 0);
			_bGrad.graphics.lineTo(width, gradH - gradR);
			_bGrad.graphics.curveTo(width, gradH, width - gradR, gradH);
			_bGrad.graphics.lineTo(gradR, gradH);
			_bGrad.graphics.curveTo(0, gradH, 0, gradH - gradR);
			_bGrad.graphics.lineTo(0, 0);
			_bGrad.graphics.endFill();
		}
		
		private function setSelectedColor():void {
			var gradH:int	= height * .5;
			var gradR:int	= radius * .5;
			
			_btn.graphics.clear();
			_btn.graphics.lineStyle(_borderSize, bgSelected, 1, true);
			_btn.graphics.beginFill(bgSelected, 1);
			_btn.graphics.drawRoundRect(0, 0, width, height, radius);
			_btn.graphics.endFill();
			
			_tGrad.graphics.clear();
			_tGrad.graphics.beginGradientFill('linear', [bgSelected, fgSelected], [0, .6], [0, 255], _gradMatrix);
			_tGrad.graphics.moveTo(0, gradR);
			_tGrad.graphics.curveTo(0, 0, gradR, 0);
			_tGrad.graphics.lineTo(width - gradR, 0);
			_tGrad.graphics.curveTo(width, 0, width, gradR);
			_tGrad.graphics.lineTo(width, gradH);
			_tGrad.graphics.lineTo(0, gradH);
			_tGrad.graphics.lineTo(0, gradR);
			_tGrad.graphics.endFill();
			
			_bGrad.graphics.clear();
			_bGrad.graphics.beginGradientFill('linear', [fgSelected, fgSelected], [.8, .5], [127, 255], _gradMatrix);
			_bGrad.graphics.lineTo(width, 0);
			_bGrad.graphics.lineTo(width, gradH - gradR);
			_bGrad.graphics.curveTo(width, gradH, width - gradR, gradH);
			_bGrad.graphics.lineTo(gradR, gradH);
			_bGrad.graphics.curveTo(0, gradH, 0, gradH - gradR);
			_bGrad.graphics.lineTo(0, 0);
			_bGrad.graphics.endFill();
		}
		
		//Set size
		public override function set width(value:Number):void {
			data.width		= value;
			resetSize();
		}
		public override function get width():Number {
			return data.width;
		}
		public override function set height(value:Number):void {
			data.height		= value;
			resetSize();
		}
		public override function get height():Number {
			return data.height;
		}
		
		//Toggle selected
		public function set selected(value:Boolean):void {
			var e:ElementEvent	= new ElementEvent(ElementEvent.SELECT);
			data.selected		= value;
			
			if(value) {
				setSelectedColor();
				
				_label.color	= textSelectedColor;
				
				//Remove rollover listeners
				unbind(ElementEvent.MOUSEOVER, onHoverOver);
				unbind(ElementEvent.MOUSEOUT, onHoverOut);
			} else {
				setDefaultColor();
				
				_label.color	= textColor;
				
				//Add rollover listeners
				bind('element_mouseover', onHoverOver);
				bind('element_mouseout', onHoverOut);
				
				//Send out action call
				e	= new ElementEvent(ElementEvent.UNSELECT);
			}
			
			e.params	= data;
			dispatchEvent(e);
		}
		public function get selected():Boolean {
			return data.selected;
		}
		
		//Toggle select option
		public function set toggleBtn(value:Boolean):void {
			data.toggle = value;
		}
		public function get toggleBtn():Boolean {
			return data.toggle;
		}
		
		public function set backgroundColor(value:uint):void {
			data.backgroundColor = value;
			create();
		}
		public function get backgroundColor():uint {
			return data.backgroundColor;
		}
		
		public function set foregroundColor(value:uint):void {
			data.foregroundColor = value;
			create();
		}
		public function get foregroundColor():uint {
			return data.foregroundColor;
		}
		
		public function set fgHover(value:uint):void {
			data.fgHover = value;
			create();
		}
		public function get fgHover():uint {
			return data.fgHover;
		}
		
		public function set bgHover(value:uint):void {
			data.bgHover = value;
			create();
		}
		public function get bgHover():uint {
			return data.bgHover;
		}
		
		public function set bgSelected(value:uint):void {
			data.bgSelected = value;
			create();
		}
		public function get bgSelected():uint {
			return data.bgSelected;
		}
		
		public function set fgSelected(value:uint):void {
			data.fgSelected = value;
			create();
		}
		public function get fgSelected():uint {
			return data.fgSelected;
		}
		
		public function set radius(value:uint):void {
			data.radius = value;
			create();
		}
		public function get radius():uint {
			return data.radius;
		}
		
		public function set size(value:uint):void {
			data.size = value;
			create();
		}
		public function get size():uint {
			return data.size;
		}
		
		public function set arrowSize(value:Number):void {
			data.arrowSize = value;
			create();
		}
		public function get arrowSize():Number {
			return data.arrowSize;
		}
		
		public function set align(value:String):void {
			data.align = value;
			create();
		}
		public function get align():String {
			return data.align;
		}
		
		public function set useArrow(value:Boolean):void {
			data.useArrow = value;
			create();
		}
		public function get useArrow():Boolean {
			return data.useArrow;
		}
		
		//Set text color
		public function set textColor(value:uint):void {
			data.textColor = value;
			create();
		}
		public function get textColor():uint {
			return data.textColor;
		}
		
		//Set text rollover color
		public function set textOverColor(value:uint):void {
			data.textOverColor = value;
			create();
		}
		public function get textOverColor():uint {
			return data.textOverColor;
		}
		
		//Set text selected color
		public function set textSelectedColor(value:uint):void {
			data.textSelectedColor = value;
			create();
		}
		public function get textSelectedColor():uint {
			return data.textSelectedColor;
		}
	}
}