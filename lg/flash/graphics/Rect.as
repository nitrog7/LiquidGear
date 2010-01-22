/**
* Container Class by Nick Farina and Philippe Elass.
* Visit www.liquidgear.net for documentation and updates.
*
*
* Copyright (c) 2008 Nick Farina and Philippe Elass. All rights reserved.
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
 
package lg.flash.graphics {
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	
	/**
	 * The simplest Renderer.
	 */
	public class Rect extends Renderer {
		private var _radius:Number;
		private var _color:uint;
		private var _alpha:Number;
		private var _lineColor:uint;
		private var _lineThickness:Number;
		private var _lineAlpha:Number;
		private var _linePixelHinting:Boolean;
		
		function Rect(color:uint=0, alpha:Number=1) {
			_color				= color;
			_alpha				= alpha;
			_lineColor			= 0;
			_lineAlpha			= 1;
			_linePixelHinting	= true;
		}
		
		public function get radius():Number {
			return _radius;
		}
		
		public function set radius(value:Number):void {
			_radius = value;
			changed();
		}
		
		public function get color():uint {
			return _color;
		}
		
		public function set color(value:uint):void {
			_color = value;
			changed();
		}
		
		public function get alpha():Number {
			return _alpha;
		}
		
		public function set alpha(value:Number):void {
			_alpha = value;
			changed();
		}
		
		public function get lineColor():uint {
			return _lineColor;
		}
		
		public function set lineColor(value:uint):void {
			_lineColor = value;
			changed();
		}
		
		public function get lineThickness():Number {
			return _lineThickness;
		}
		public function set lineThickness(value:Number):void {
			_lineThickness = value;
			changed();
		}
		
		public function get lineAlpha():Number {
			return _lineAlpha;
		}
		public function set lineAlpha(value:Number):void {
			_lineAlpha = value;
			changed();
		}
		
		public function get linePixelHinting():Boolean {
			return _linePixelHinting;
		}
		public function set linePixelHinting(value:Boolean):void {
			_linePixelHinting = value;
			changed();
		}
		
		override public function render(target:DisplayObject, g:Graphics, w:Number, h:Number):void {
			g.beginFill(_color, _alpha);
			
			if(_lineThickness) {
				g.lineStyle(_lineThickness, _lineColor, _lineAlpha, _linePixelHinting);
			}
			if(_radius) {
				g.drawRoundRect(0, 0, w, h, _radius * 2, _radius * 2);
			} else {
				g.drawRect(0, 0, w, h);
			}
			
			g.endFill();
		}
	}
}

