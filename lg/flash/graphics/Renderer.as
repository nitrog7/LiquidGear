/**
* Renderer Class by Nick Farina and Philippe Elass.
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
	//Flash
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * Provides an easy inheritance-based mechanism for implementing "Renderers" 
	 * which draw into a Graphics context at a given width and height.
	 */
	public class Renderer extends EventDispatcher {
		/**
		 * Override this to render into the given Graphics in a custom way.
		 * Default behavior is to dispatch Event.RENDER.
		 */
		public function render(target:DisplayObject, g:Graphics, w:Number, h:Number):void {
			dispatchEvent(new Event(Event.RENDER));
		}
		
		/**
		 * Dispatches the CHANGE event which should cause a re-render to occur.
		 */
		protected function changed():void {
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public static function parse(s:String):Renderer {
			var color:uint = uint(s);
			var alpha:Number = 1;
			
			// did the user give us a high byte as well (for alpha)?
			if (s.length == 10) {
				alpha = (color >>> 24) / 0xff; // "unsigned bitshift" operator! WTF!
				color = color &= 0x00ffffff;
			}

			return new Rect(color, alpha);
		}
	}
}
