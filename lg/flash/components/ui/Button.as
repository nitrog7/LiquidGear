/**
 * Button Class by Giraldo Rosales.
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

package lg.flash.components.ui {
	//Flash
	import flash.geom.Matrix;
	
	//LG
	import lg.flash.components.ui.UIElement;
	import lg.flash.elements.Text;
	import lg.flash.events.ElementEvent;
	
	/**
	 * A button designed to hold text.
	 */
	public class Button extends UIElement {
		private var _label:Text;
		
		public function Button(obj:Object) {
			super();
			button();
			
			data.isDefault	= false;
			data.isPressed	= false;
			data.label		= 'Button';
			
			data.foreColor	= 0xcccccc;
			data.bgColor	= 0x000000;
			data.align		= 'center';
			data.bold		= false;
			
			setAttributes(obj);
			
			if(data.isDefault) {
				data.bold	= true;
			}
			
			_label	= new Text({id:'label', x:data.pad, htmlText:data.label, width:65, font:data.font, embedFonts:data.embedFonts, align:data.align, verticalAlign:'top', color:data.color, size:data.size, bold:data.bold});
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
			
			_label.y	= (data.height - _label.height) * .5;
			
			createButton(data.foreColor, data.bgColor);
			
			mouseover(onOverButton);
			mouseout(onOutButton);
			click(onClickButton);
			
			isSetup	= true;
		}
		
		private function createButton(foreground:uint, background:uint):void {
			graphics.clear();
			
			//Create a Matrix instance and assign the Gradient Box
			var matr:Matrix	= new Matrix();
			
			//Draw a gradient going from dark to light
			matr.createGradientBox(data.width, data.height, Math.PI * .5, 0, 0);
			graphics.beginGradientFill('linear', [foreground, background], [1, 1], [0, 255], matr, 'pad');
			
			if(data.radius) {
				graphics.drawRoundRect(0, 0, data.width, data.height, data.radius);
			}else {
				graphics.drawRoundRect(0, 0, data.width, data.height, data.height);
			}
			
			//Add a white gradient on the top for "bubble" effect
			var bubbleX:Number	= data.width * .1;
			var bubbleY:Number	= data.height * .1;
			
			matr.createGradientBox(data.width * 0.88, data.height * 0.4, Math.PI * .5, 0, 0);
			graphics.beginGradientFill('linear', [foreground, foreground], [1, 0.02], [0, 255], matr, 'pad');
			graphics.drawRoundRect(bubbleX, bubbleY, data.width - (bubbleX * 2), data.height * .4, data.height * .4);
			
			graphics.endFill();
		}
		
		public function onOverButton(e:ElementEvent):void {
			createButton(data.foreColor, data.foreColor);
		}
		public function onOutButton(e:ElementEvent):void {
			createButton(data.foreColor, data.bgColor);
		}
		public function onClickButton(e:ElementEvent):void {
			createButton(data.foreColor, data.foreColor);
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
			
			if(value) {
				_label.bold	= true;
			} else {
				_label.bold	= false;
			}
		}
	}
}
