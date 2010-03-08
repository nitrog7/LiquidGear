/**
* ContainerAttributes Class by Nick Farina and Philippe Elass.
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

package lg.flash.layout {
	//Flash
	import flash.display.DisplayObject;
	
	//LG
	import lg.flash.layout.Attributes;
	import lg.flash.layout.Thickness;
	
	public class ContainerAttributes extends Attributes {
		private var _layoutX:Number;
		private var _layoutY:Number;
		private var _offsetX:Number;
		private var _offsetY:Number;
		private var _margin:Thickness;
		private var _collapsed:Boolean;
		private var _maskParent:Boolean;

		public function ContainerAttributes() {
			_layoutX	= _layoutY = _offsetX = _offsetY = 0;
			_margin		= new Thickness();
			_collapsed	= false;
		}
		
		public function get layoutX():Number {
			return _layoutX;
		}
		
		public function set layoutX(value:Number):void {
			_layoutX				= value;
			DisplayObject(target).x	= _layoutX + _offsetX;
		}

		public function get layoutY():Number {
			return _layoutY;
		}
		
		public function set layoutY(value:Number):void {
			_layoutY				= value;
			DisplayObject(target).y	= _layoutY + _offsetY;
		}

		public function get offsetX():Number {
			return _offsetX;
		}
		
		public function set offsetX(value:Number):void {
			_offsetX				= value;
			DisplayObject(target).x	= _layoutX + _offsetX;
		}

		public function get offsetY():Number {
			return _offsetY;
		}
		
		public function set offsetY(value:Number):void {
			_offsetY				= value;
			DisplayObject(target).y	= _layoutY + _offsetY;
		}

		public function get margin():Thickness {
			return _margin;
		}
		
		public function set margin(value:Thickness):void {
			_margin	= value;
			invalidateContainer();
		}
		
		public function get collapsed():Boolean {
			return _collapsed;
		}
		
		public function set collapsed(value:Boolean):void {
			_collapsed						= value;
			DisplayObject(target).visible	= !_collapsed;
			invalidateContainer();
		}
		
		public function get maskParent():Boolean {
			return _maskParent;
		}
		public function set maskParent(value:Boolean):void  {
			_maskParent			= value;
			var t:DisplayObject	= target;
			
			if (_maskParent && t.parent) {
				t.parent.mask	= t;
			}
		}
	}
}
