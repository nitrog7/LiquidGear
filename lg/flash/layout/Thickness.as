/**
* Thickness Class by Nick Farina and Philippe Elass.
* Visit www.liquidgear.net for documentation and updates.
*
*
* Copyright (c) 2008 Nick Farina and Philippe Elass. All rights reserved.
* 
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the 'Software'), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
* 
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
**/
 
package lg.flash.layout {
	public final class Thickness {
		public var top:Number;
		public var right:Number;
		public var bottom:Number;
		public var left:Number;
		
		public function Thickness(top:Number = 0, right:Number = 0, bottom:Number = 0, left:Number = 0) {
			this.top = top;
			this.right = right;
			this.bottom = bottom;
			this.left = left;
		}
		
		public function get totalWidth():Number {
			return left + right;
		}
		public function get totalHeight():Number {
			return top + bottom;
		}
		
		public static function parse(s:String):Thickness {
			var split:Array = s.split(',');
			
			switch (split.length) {
				case 1: // '10'
					var n:Number = Number(split[0]);
					return new Thickness(n, n, n, n);
				case 2: // '10,20' (top+bottom, left+right)
					var tb:Number = Number(split[0]);
					var lr:Number = Number(split[1]);
					return new Thickness(tb, lr, tb, lr);
				case 3:
					var top:Number = Number(split[0]);
					var right:Number = Number(split[1]);
					var bottom:Number = Number(split[2]);
					return new Thickness(top, right, bottom, right);
				case 4:
					var t:Number = Number(split[0]);
					var r:Number = Number(split[1]);
					var b:Number = Number(split[2]);
					var l:Number = Number(split[3]);
					return new Thickness(t, r, b, l);
				default:
					throw new ArgumentError('Could not convert the string \'' + s + '\' into a Thickness object.');
			}
		}
		
		public function toString():String {
			return '[' + top + ',' + right + ',' + bottom + ',' + left + ']';
		}
	}
}
