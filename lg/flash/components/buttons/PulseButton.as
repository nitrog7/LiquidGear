/**
* PulseButton Class by Giraldo Rosales.
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
	//Flash Classes
	import flash.geom.Rectangle;
	
	//LG Classes
	import lg.flash.events.ElementEvent;
	import lg.flash.elements.VisualElement;
	import lg.flash.elements.Shape;
	import lg.flash.elements.Text;
	import lg.flash.motion.TweenMax;
	import lg.flash.motion.easing.Quad;
	import lg.flash.motion.easing.Back;
	import lg.flash.motion.easing.Elastic;
	
	public class PulseButton extends VisualElement {
		private var _label:Text;
		
		private var _circle1:Shape;
		private var _circle2:Shape;
		private var _circle3:Shape;
		private var _circle4:Shape;
		
		private var _plus:VisualElement;
		private var _labelBg:Shape;
		private var _labelMask:VisualElement;
		private var _selected:Boolean		= false;
		private var _toggle:Boolean			= false;
		
		public function PulseButton(obj:Object) {
			super();
			button();
			
			//Set Defaults
			data.title				= 'Pulse Button';
			data.font				= '_sans';
			data.embedFonts			= false;
			data.size				= 14;
			data.textX				= 24;
			data.textY				= 0;
			data.backgroundColor	= 0x000000;
			data.buttonColor		= 0x0099FF;
			data.innerColor			= 0x000000;
			data.outerColor			= 0x000000;
			data.textColor			= 0xFFFFFF;
			data.textOverColor		= 0xFFFFFF;
			data.selectedColor		= 0xFFFFFF;
			data.iconColor			= 0xFFFFFF;
			data.invert				= false;
			data.buttonRadius		= 16;
			data.innerRadius		= 24;
			data.outerRadius		= 75;
			data.isOpen				= true;
			
			//Set Attributes
			for(var s:String in obj) {
				if(s in this) {
					this[s] = obj[s];
				}
				data[s] = obj[s];
			}
			
			//Scale9
			var labelScale:Rectangle = new Rectangle(15, 5, 50, 20);
			
			_labelBg	= new Shape({width:80, height:30, shape:'roundrect', color:data.backgroundColor, fillAlpha:.5, radius:30});
			_labelBg.scale9Grid	= labelScale;
			_labelBg.ghost();
			addChild(_labelBg);
			_labelBg.setPos(-15, -15);
			_labelBg.width		= 30;
			
			//Label
			_label	= new Text({id:'label', x:data.textX, color:data.textColor, size:data.size, font:data.font, embedFonts:data.embedFonts, text:data.title});
			addChild(_label);
			
			//Listeners
			mousedown(onHoverDown);
			click(onHoverClick);
			
			if(data.invert) {
				hover(onHoverOut, onHoverOver);
			} else {
				hover(onHoverOver, onHoverOut);
			}
			
			isSetup	= true;
			updateButton();
		}
		
		private function updateButton():void {
			if(!isSetup) {
				return;
			}
			
			if(_circle1 && contains(_circle1)) {
				removeChild(_circle1);
				_circle1 = null;
			}
			if(_circle2 && contains(_circle2)) {
				removeChild(_circle2);
				_circle2 = null;
			}
			if(_circle3 && contains(_circle3)) {
				removeChild(_circle3);
				_circle3 = null;
			}
			if(_circle4 && contains(_circle4)) {
				removeChild(_circle4);
				_circle4 = null;
			}
			if(_plus && contains(_plus)) {
				removeChild(_plus);
				_plus = null;
			}
			
			_circle1	= new Shape({id:'circle1', x:-(data.outerRadius*.5), y:-(data.outerRadius*.5), width:data.outerRadius, shape:'circle', color:data.outerColor, fillAlpha:.1, alpha:0});
			_circle1.ghost();
			addChild(_circle1);
			
			_circle2	= new Shape({id:'circle2', x:-(data.innerRadius*.5), y:-(data.innerRadius*.5), width:data.innerRadius, shape:'circle', color:data.innerColor, fillAlpha:.3, alpha:0});
			_circle2.ghost();
			addChild(_circle2);
			
			_circle3	= new Shape({id:'circle3', x:-(data.buttonRadius*.5), y:-(data.buttonRadius*.5), width:data.buttonRadius, shape:'circle', fillAlpha:0});
			addChild(_circle3);
			hitArea	= _circle3;
			
			_circle4	= new Shape({id:'circle4', x:-(data.buttonRadius*.5), y:-(data.buttonRadius*.5), width:data.buttonRadius, shape:'circle', color:data.buttonColor, fillAlpha:1});
			_circle4.ghost();
			addChild(_circle4);
			
			if(!data.icon) {
				_plus	= new VisualElement();
				_plus.graphics.clear();
				_plus.graphics.lineStyle(2, data.iconColor, 1);
				_plus.graphics.moveTo(-4, 0);
				_plus.graphics.lineTo(4, 0);
				_plus.graphics.moveTo(0, -4);
				_plus.graphics.lineTo(0, 4);
				_plus.graphics.endFill();
			} else {
				_plus	= data.icon;
			}
			
			_plus.ghost();
			addChild(_plus);
				
			//Label
			if(data.textY || data.textY == 0) {
				_label.y	= -(_label.height *.6);
			}
			
			//Mask
			_labelMask	= new VisualElement();
			_label.addChild(_labelMask);
			_label.mask	= _labelMask;
			_labelMask.graphics.clear();
			_labelMask.graphics.beginFill(0x000000, 1);
			_labelMask.graphics.drawRect(0, 0, _label.width, _label.height);
			_labelMask.graphics.endFill();
			//_labelMask.width	= 0;
			
			if(data.invert) {
				close();
			} else {
				open();
			}
		}
		
		/** Show the open state **/
		public function open():void {
			data.isOpen	= true;
			
			var initRadius:int	= data.buttonRadius * 1.2;
			_circle1.animate({duration:.2, alpha:0, x:-(data.buttonRadius*.5), y:-(data.buttonRadius*.5), width:data.buttonRadius, height:data.buttonRadius, ease:Quad.easeOut});
			_circle2.animate({duration:.4, alpha:0, x:-(data.buttonRadius*.5), y:-(data.buttonRadius*.5), width:data.buttonRadius, height:data.buttonRadius, ease:Quad.easeOut});
			
			_labelBg.animate({duration:.65, width:_label.width+65, ease:Back.easeOut});
			_labelMask.animate({duration:.65, x:0, alpha:1, ease:Quad.easeOut});
		}
		
		/** Show the close state **/
		public function close():void {
			data.isOpen	= false;
			
			_circle1.animate({duration:1.3, alpha:1, x:-(data.outerRadius), y:-(data.outerRadius), width:data.outerRadius*2, height:data.outerRadius*2, ease:Elastic.easeOut});
			_circle2.animate({duration:1.1, alpha:1, x:-(data.innerRadius), y:-(data.innerRadius), width:data.innerRadius*2, height:data.innerRadius*2, ease:Elastic.easeOut});
			
			_labelBg.animate({duration:.2, width:30, delay:.2, ease:Quad.easeOut});
			_labelMask.animate({duration:.2, x:-_label.width, alpha:0, ease:Quad.easeOut});
		}
		
		public override function set title(value:String):void {
			if(!_label) {
				return;
			}
			
			data.title		= value;
			_label.htmlText	= value;
			
			if(data.isOpen && _labelBg && _labelMask) {
				_labelBg.animate({duration:0, width:_label.width+65, ease:Back.easeOut});
				_labelMask.animate({duration:0, x:0, width:_label.width+15, alpha:1, ease:Back.easeOut});
			}
			
			updateButton();
		}
		
		//Toggle selected
		public function set selected(value:Boolean):void {
			_selected	= value;
			
			if(_selected) {
				_label.color	= data.selectedColor;
				
				//Remove rollover listeners
				unbind('element_mouseover', onHoverOut);
				unbind('element_mouseover', onHoverOver);
				unbind('element_mouseout', onHoverOut);
				unbind('element_mouseout', onHoverOver);
				
				//Send out action call
				trigger('element_select');
			} else {
				_label.color	= data.textColor;
				
				//Add rollover listeners
				if(data.invert) {
					hover(onHoverOut, onHoverOver);
				} else {
					hover(onHoverOver, onHoverOut);
				}
				
				//Send out action call
				trigger('element_unselect');
			}
		}
		public function get selected():Boolean {
			return _selected;
		}
		
		/** Enable button to be toggled. **/
		public function set toggleEnabled(value:Boolean):void {
			_toggle = value;
		}
		public function get toggleEnabled():Boolean {
			return _toggle;
		}
		
		/** Background color **/
		public function set backgroundColor(value:uint):void {
			data.backgroundColor 	= value;
			
			if(_labelBg) {
				_labelBg.color			= value;
			}
		}
		public function get backgroundColor():uint {
			return data.backgroundColor;
		}
		
		/** Button color **/
		public function set buttonColor(value:uint):void {
			data.buttonColor	= value;
			
			if(_circle4) {
				_circle4.color		= value;
			}
		}
		public function get buttonColor():uint {
			return data.buttonColor;
		}
		
		/** Inner circle color **/
		public function set innerColor(value:uint):void {
			data.innerColor	= value;
			
			if(_circle2) {
				_circle2.color	= value;
			}
		}
		public function get innerColor():uint {
			return data.innerColor;
		}
		
		/** Outer circle color **/
		public function set outerColor(value:uint):void {
			data.outerColor	= value;
			
			if(_circle1) {
				_circle1.color	= value;
			}
		}
		public function get outerColor():uint {
			return data.outerColor;
		}
		
		/** Plus icon color **/
		public function set iconColor(value:uint):void {
			data.iconColor = value;
			updateButton();
		}
		public function get iconColor():uint {
			return data.iconColor;
		}
		
		/** Use a custom icon. **/
		public function set icon(element:VisualElement):void {
			data.icon	= element;
			updateButton();
		}
		public function get icon():VisualElement {
			return data.icon;
		}
		
		/** Change the label font. **/
		public function set font(value:String):void {
			data.font = value;
			updateButton();
		}
		public function get font():String {
			return data.font;
		}
		
		/** Use of embedded fonts. **/
		public function set embedFonts(value:Boolean):void {
			data.embedFonts = value;
			updateButton();
		}
		public function get embedFonts():Boolean {
			return data.embedFonts;
		}
		
		/** Font size. **/
		public function set size(value:int):void {
			data.size = value;
			updateButton();
		}
		public function get size():int {
			return data.size;
		}
		
		/** Label X value. **/
		public function set textX(value:int):void {
			data.textX = value;
			updateButton();
		}
		public function get textX():int {
			return data.textX;
		}
		
		/** Label Y value. **/
		public function set textY(value:int):void {
			data.textY = value;
			updateButton();
		}
		public function get textY():int {
			return data.textY;
		}
		
		/** Text color **/
		public function set textColor(value:uint):void {
			data.textColor	= value;
			
			if(_label) {
				_label.color		= value;
			}
		}
		public function get textColor():uint {
			return data.textColor;
		}
		
		/** Text rollover color **/
		public function set textOverColor(value:uint):void {
			data.textOverColor = value;
		}
		public function get textOverColor():uint {
			return data.textOverColor;
		}
		
		/** Selected text color **/
		public function set selectedColor(value:uint):void {
			data.selectedColor = value;
		}
		public function get selectedColor():uint {
			return data.selectedColor;
		}
		
		/** Invert the rollover/rollout animation. **/
		public function set invert(value:Boolean):void {
			//Remove rollover listeners
			unbind('element_mouseover', onHoverOut);
			unbind('element_mouseover', onHoverOver);
			unbind('element_mouseout', onHoverOut);
			unbind('element_mouseout', onHoverOver);
			
			data.invert = value;
			updateButton();
		}
		public function get invert():Boolean {
			return data.invert;
		}
		
		/** @private **/
		private function onHoverOver(e:ElementEvent):void {
			close();
			
			if(!selected || !_toggle) {
				_label.color	= data.textOverColor;
			}
		}
		
		/** @private **/
		private function onHoverOut(e:ElementEvent):void {
			open();
			
			if(!selected || !_toggle) {
				_label.color	= data.textColor;
			}
		}
		
		/** @private **/
		private function onHoverClick(e:ElementEvent):void {
			if(_toggle) {
				if(_selected) {
					selected	= false;
				} else {
					selected	= true;
				}
			}
		}
		
		/** @private **/
		private function onHoverDown(e:ElementEvent):void {
			_label.color	= data.selectedColor;
		}
	}
}