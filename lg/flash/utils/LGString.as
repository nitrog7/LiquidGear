/**
* LGString by Giraldo Rosales.
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

package lg.flash.utils {
	public class LGString {
		public static function reduce(string:String, stringLength:int, indicator:String):String {
			var s:String='', strLen:int=string.length;
			
			if (strLen <= stringLength) {
				return string;
			}
			
			var trimArray:Array=[], trimLen:int=0, numWords:int, wordArray:Array, ol:int=0, word:String, w:int, wordLen:int;
			
			wordArray	= string.split(' ');
			numWords	= wordArray.length;

			for(w=0; w<numWords; ++w) {
				word	= wordArray[w];
				wordLen	= word.length;
				//check each words length before adding it the output string
				if ((ol+wordLen) <= stringLength) {
					trimLen	= trimArray.length;
					trimArray[trimLen] = word;
					ol	+= wordLen+1;
				} else {
					break;
				}
			}
			
			s = trimArray.join(' ') + indicator;
			
			return s;
		}
		
		public static function isEqual(string1:String, string2:String, caseSensitive:Boolean):Boolean {
			if(caseSensitive) {
				return (string1 == string2);
			} else {
				return (string1.toLowerCase() == string2.toLowerCase());
			}
		}
		
		public static function trim(string:String):String {
			string	= rtrim(string);
			string	= ltrim(string);
			return string;
		}
		
		public static function ltrim(string:String):String {
			var s:String	= string;
			var size:Number	= string.length;
			
			for(var g:int=0; g<size; g++) {
				if(string.charCodeAt(g) > 32) {
					s = string.substring(g);
					break;
				}
			}
			
			return s;
		}
		
		public static function rtrim(string:String):String {
			var s:String	= string;
			var size:Number	= s.length;
			
			for(var g:int=size; g>0; g--) {
				if(string.charCodeAt(g - 1) > 32) {
					s	= string.substring(0, g);
					break;
				}
			}

			return s;
		}
		
		public static function beginsWith(string:String, prefix:String):Boolean {	
			var preLen:int	= prefix.length;
			return (prefix == string.substring(0, preLen));
		}
		
		public static function endsWith(string:String, suffix:String):Boolean {
			var sufLen:int = suffix.length, strLen:int = string.length;
			return (suffix == string.substring(int(strLen - sufLen)));
		}
		
		public static function remove(string:String, remove:String):String {
			var s:String = string.replace(remove, '');
			return s;
		}
		
		public static function replace(string:String, replace:String, replaceWith:String):String {
			//change to StringBuilder
			var s:String		= '';
			var found:Boolean	= false;

			var sLen:int	= string.length;
			var rLen:int	= replace.length;

			for(var g:int=0; g<sLen; g++) {
				if(string.charAt(g) == replace.charAt(0)) {
					found = true;
					
					for(var j:int=0; j<rLen; j++) {
						if(!(string.charAt(g + j) == replace.charAt(j))) {
							found = false;
							break;
						}
					}

					if(found) {
						s += replaceWith;
						g = g + (rLen - 1);
						continue;
					}
				}
				s += string.charAt(g);
			}
			
			return s;
		}
	}
}