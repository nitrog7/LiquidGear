/**
* AutoSize Class by Nick Farina and Philippe Elass.
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
	public final class AutoSize {
		public var width:Boolean;
		public var height:Boolean;

		public function AutoSize(width:Boolean=true, height:Boolean=true) {
			this.width = width;
			this.height = height;
		}
		
		public function clone():AutoSize {
			return new AutoSize(width, height);
		}
		
		public function cloneWithWidth(autoWidth:Boolean):AutoSize {
			return new AutoSize(autoWidth, height);
		}
		
		public function cloneWithHeight(autoHeight:Boolean):AutoSize {
			return new AutoSize(width, autoHeight);
		}
		
		public function and(auto:AutoSize):AutoSize {
			return new AutoSize(width && auto.width, height && auto.height);
		}
		
		public function get isNone():Boolean {
			return !width && !height;
		}
		
		public function get isBoth():Boolean {
			return width && height;
		}
		
		public function get isEither():Boolean {
			return width || height;
		}

		public function toString():String {
			return '[' + (width ? 'auto' : 'fixed') + ',' + (height ? 'auto' : 'fixed') + ']';
		}
		
		public static function parse(s:String):AutoSize {
			switch (s) {
				case 'none':
					return new AutoSize(false, false);
				case 'width':
					return new AutoSize(true, false);
				case 'height':
					return new AutoSize(false, true);
				case 'both':
					return new AutoSize(true, true);
				default:
					throw new ArgumentError('Cannot parse the string \'' + s + '\' into an AutoSize object.');
			}
		}
	}
}
