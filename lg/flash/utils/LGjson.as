/**
 * LGjson Class by Giraldo Rosales.
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
	import lg.flash.utils.json.JSONDecoder;
	import lg.flash.utils.json.JSONEncoder;
	
	/**
	 * This class provides encoding and decoding of the JSON format.
	 *
	 * Example usage:
	 * <code>
	 *   // Create a JSON string from an AS3 object
	 *   LGjson.encode( myObject );
	 *
	 *   // Read a JSON string into an AS3 object
	 *   var myObject:Object = LGjson.decode( jsonString );
	 * </code>
	 */
	public class LGjson {
		/**
		 * Encodes an AS3 object into a JSON string.
		 *
		 * @param obj AS3 object.
		 * @return the JSON string.
		 */
		public static function encode(obj:Object):String {
			return new JSONEncoder(obj).getString();
		}
	   
		/**
		 * Decodes a JSON string into an AS3 object.
		 *
		 * @param json The JSON string.
		 * @param strict Flag indicating if the decoder should strictly adhere
		 *              to the JSON standard or not.  The default of <code>true</code>
		 *              throws errors if the format does not match the JSON syntax exactly.
		 *              Pass <code>false</code> to allow for non-properly-formatted JSON
		 *              strings to be decoded with more leniancy.
		 * @return An AS3 object
		 * @throw JSONParseError
		 */
		public static function decode(json:String, strict:Boolean = true):Object {
			return new JSONDecoder(json, strict).getValue();
		}
	}
}

