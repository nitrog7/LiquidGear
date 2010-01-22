/**
 * TextInput Class by Giraldo Rosales.
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

package lg.flash.components.ui {
	//Flash
	import flash.geom.Matrix;
	
	//LG
	import lg.flash.components.ui.UIElement;
	import lg.flash.elements.Text;
	import lg.flash.events.ElementEvent;
	import flash.display.Graphics;
	
	/**
	 * A textfield designed to hold text.
	 */
	public class TextInput extends UIElement {
		private var _label:Text;
		private var _input:Text;
		
		public function TextInput(obj:Object) {
			super();
			holder();
			
			data.isDefault		= false;
			data.label			= '';
			data.labelWidth		= 150;
			data.labelHeight	= 0;
			data.labelColor		= 0x000000;
			data.defaultText	= '';
			
			data.foreColor		= 0x999999;
			data.hoverColor		= 0x00d2ff;
			data.bgColor		= 0xffffff;
			data.align			= 'left';
			data.bold			= false;
			
			setAttributes(obj);
			
			if(data.isRequired) {
				data.bold	= true;
			}
			
			var fieldX:int	= 0;
			
			if(data.label != '') {
				_label	= new Text({id:'label', htmlText:data.label, width:data.labelWidth, font:data.font, embedFonts:data.embedFonts, align:data.align, color:data.labelColor, size:data.size, bold:data.bold});
				addChild(_label);
				
				data.labelWidth		= _label.width;
				data.labelHeight	= _label.height;
				fieldX				= data.labelWidth + data.pad;
			} else {
				data.labelWidth		= 0;
				data.labelHeight	= 0;
			}
			
			_input	= new Text({id:'input', x:fieldX + 5, y:data.pad * .5, htmlText:'', font:data.font, embedFonts:data.embedFonts, align:data.align, color:data.color, size:data.size, bold:data.isRequired, input:true});
			addChild(_input);
			
			if(isNaN(data.width)) {
				data.width			= data.labelWidth + _input.width + (data.pad * 3);
			} else {
				_input.textWidth	= data.width - data.labelWidth - (data.pad * 3);
			}
			
			if(isNaN(data.height)) {
				if(data.labelHeight > 0) {
					data.height			= data.labelHeight + data.pad;
				} else {
					data.height			= _input.height + data.pad;
				}
			} else {
				_label.textHeight	= data.height;
			}
			
			_label.y	= (data.height - _label.height) * .5;
			
			createField(data.bgColor);
			
			_input.mouseover(onOverField);
			_input.mouseout(onOutField);
			_input.click(onClickField);
			
			isSetup	= true;
		}
		
		private function createField(background:uint, outline:uint=0):void {
			var fieldX:int	= data.labelWidth + data.pad;
			var fieldW:int	= data.width - fieldX;
			var fieldH:int	= _input.height + data.pad;
			
			graphics.clear();
			graphics.beginFill(background, 1);
			
			if(outline) {
				this.graphics.lineStyle(2, outline, .8, true, 'normal', 'square', 'miter');
			}
			
			if(data.radius) {
				this.graphics.drawRoundRect(fieldX, 0, fieldW, fieldH, data.radius);
			}else {
				graphics.drawRect(fieldX, 0, fieldW, fieldH);
			}
			
			graphics.endFill();
		}
		
		public function onOverField(e:ElementEvent):void {
			createField(data.bgColor, data.hoverColor);
		}
		public function onOutField(e:ElementEvent):void {
			createField(data.bgColor);
		}
		public function onClickField(e:ElementEvent):void {
			createField(data.bgColor, data.hoverColor);
		}
		
		public function set pressed(value:Boolean):void {
			data.isPressed = value;
		}
		
		public function get isDefault():Boolean {
			return data.isDefault;
		}
		public function set isDefault(value:Boolean):void {
			if(!isSetup) {
				return;
			}
			
			data.isDefault = value;
			
			if(_label) {
				if(value) {
					_label.bold	= true;
				} else {
					_label.bold	= false;
				}
			}
		}
		
		public override function set width(value:Number):void {
			data.width			= value;
			
			if(_input) {
			//	_input.textWidth	= value;
			}
		}
	}
}
