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
 
package lg.flash.layout {
	//Flash
	import flash.geom.Rectangle;
	
	public class Size {
		public var width:Number;
		public var height:Number;
		
		public function Size(width:Number = 0, height:Number = 0) {
			this.width = width;
			this.height = height;
		}
		
		public function growToFit(size:Size):void {
			if (size.width > this.width) {
				this.width = size.width;
			}
			
			if (size.height > this.height) {
				this.height = size.height;
			}
		}
		
		public function growWidthToFit(size:Size):void {
			if (size.width > this.width) {
				this.width = size.width;
			}
		}
		
		public function growHeightToFit(size:Size):void {
			if (size.height > this.height) {
				this.height = size.height;
			}
		}
		
		public function clone():Size {
			return new Size(width, height);
		}
		
		public function reset():void {
			width = 0;
			height = 0;
		}
		
		public function toString():String {
			return "[" + width + "," + height + "]";
		}
	}
}
