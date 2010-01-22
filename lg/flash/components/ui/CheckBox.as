/**
 * CheckBox Class by Giraldo Rosales.
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
	import flash.display.Graphics;
	
	//LG
	import lg.flash.components.ui.UIElement;
	import lg.flash.elements.Text;
	import lg.flash.events.ElementEvent;
	
	public class CheckBox extends UIElement {
		private var _label:Text;
		
		public function CheckBox(obj:Object) {
			super();
			button();
			
			data.boxSize	= 15;
			data.color		= 0x000000;
			data.foreColor	= 0x000000;
			data.isChecked	= false;
			data.label		= '';
			data.align		= 'left';
			data.bold		= false;
			data.pad		= 5;
			
			setAttributes(obj);
			
			_label	= new Text({id:'label', x:data.boxSize + data.pad, width:data.width, htmlText:data.label, font:data.font, embedFonts:data.embedFonts, align:data.align, verticalAlign:'top', color:data.color, size:data.size, bold:data.bold});
			addChild(_label);
			
			if(isNaN(data.width)) {
				data.width			= _label.width + (data.pad * 2);
			} else {
				_label.textWidth	= data.width;
			}
			
			if(isNaN(data.height)) {
				data.height			= _label.height + data.pad;
			} else {
				_label.textHeight	= data.height;
			}
			
			_label.y	= data.pad * .6;
			trace('_label.y', _label.y);
			createCheckbox();
			click(onClickBox);
			
			isSetup	= true;
		}
		
		public function createCheckbox():void {
			graphics.clear();
			
			graphics.lineStyle(1, data.color, 1, false, 'normal', 'square', 'miter');
			graphics.beginFill(0x000000, 0);
			graphics.drawRect(0, 0, data.boxSize, data.boxSize);
			graphics.endFill();
			
			if(data.isChecked) {
				graphics.lineStyle(3, data.foreColor, 1, true, 'normal', 'square', 'miter');
				graphics.moveTo(data.boxSize * (5/16), data.boxSize * (3/8));
				graphics.lineTo(data.boxSize * .5, data.boxSize * (5/8));
				graphics.lineTo(data.boxSize, 0);
				graphics.endFill();
			}
		}
		
		public override function set width(value:Number):void {
			data.width			= value;
			
			if(_label) {
				_label.textWidth	= value;
			}
		}
		
		private function onClickBox(e:ElementEvent):void {
			if(data.isChecked) {
				data.isChecked	= false;
			} else {
				data.isChecked	= true;
			}
			
			createCheckbox();
		}
	}
}