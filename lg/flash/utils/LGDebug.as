/**
 * LGDebug Class by Giraldo Rosales.
* Visit www.liquidgear.net for documentation and updates.
*
*
* Copyright (c) 2010 Nitrogen Design, Inc. All rights reserved.
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

package lg.flash.utils {
	//Flash
	import flash.display.DisplayObject;
	
	//LG
	import lg.flash.utils.MonsterDebugger;
	
	public class LGDebug {
		private var _enabled:Boolean;
		private var _element:DisplayObject;
		
		/**
		 * Constructor 
		 */
		public function LGDebug(element:DisplayObject) {
			_element	= element;
		}
		
		public function on():void {
			//element		= this.parent;
			new MonsterDebugger(_element);
			_enabled	= true;
		}
		public function off():void {
			_enabled	= false;
		}
		
		/**
		 * log
		 * Sends arguments to MonsterDebugger for display
		 */
		//public static function trace(...args):void {
		public function log(obj:*):void {
			if(_enabled) {
				MonsterDebugger.trace(_element, obj, MonsterDebugger.COLOR_NORMAL);
			}
			
			trace(obj);
		}
		
		/**
		 * error
		 * Sends arguments to MonsterDebugger for display
		 */
		//public static function trace(...args):void {
		public function error(obj:*):void {
			if(_enabled) {
				MonsterDebugger.trace(_element, obj, MonsterDebugger.COLOR_ERROR);
			}
			
			trace(obj);
		}
		
		/**
		 * info
		 * Sends arguments to MonsterDebugger for display
		 */
		//public static function trace(...args):void {
		public function info(obj:*):void {
			if(_enabled) {
				MonsterDebugger.trace(_element, obj, 0x0066ff);
			}
			
			trace(obj);
		}
		
		/**
		 * warn
		 * Sends arguments to MonsterDebugger for display
		 */
		//public static function trace(...args):void {
		public function warn(obj:*):void {
			if(_enabled) {
				MonsterDebugger.trace(_element, obj, MonsterDebugger.COLOR_WARNING);
			}
			
			trace(obj);
		}
	}
}