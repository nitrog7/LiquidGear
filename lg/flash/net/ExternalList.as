/**
* ExternalList Class by Giraldo Rosales.
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

package lg.flash.net {
	import lg.flash.elements.Element;
	
	public class ExternalList extends Element {
		public static var instance:Element;
		public static var files:Vector.<String>	= new Vector.<String>();
		public static var details:Object		= {};
		
		public function ExternalList() {
			super();
			instance	= this;
		}
		
		public static function add(elName:String, filePath:String):void {
			files.push(filePath);
		}
		
		public static function addName(elName:String, filePath:String, fileName:String):void {
			details[filePath]	= fileName;
			instance.trigger('ext_'+elName);
		}
		
		public static function getName(filePath:String):String {
			return details[filePath];
		}
		/*
		public static function getIndex(filePath:String):int {
			var fIndex:int	= -1;
			
			for(var g:int=0; g<files.length; g++) {
				if(files[g].indexOf(filePath) >= 0) {
					fIndex	= g;
					break;
				}
			}
			
			return fIndex;
		}
		*/
		public static function isLoaded(filePath:String):Boolean {
			if(files.indexOf(filePath) >= 0) {
				return true;
			} else {
				return false;
			}
		}
	}
}