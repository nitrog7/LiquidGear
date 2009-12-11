/**
* CASA Lib for ActionScript 3.0
* Copyright (c) 2009, Aaron Clinger & Contributors of CASA Lib
* All rights reserved.
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
	import flash.utils.ByteArray;
	
	/**
		Utilities for working with Objects.
		
		@author Aaron Clinger
		@author David Nelson
		@version 10/27/08
	*/
	public class LGObject {
		/**
			Searches the first level properties of an object for a another object.
			
			@param obj: Object to search in.
			@param member: Object to search for.
			@return Returns <code>true</code> if object was found; otherwise <code>false</code>.
		*/
		public static function contains(obj:Object, member:Object):Boolean {
			for (var prop:String in obj)
				if (obj[prop] == member)
					return true;
			
			return false;
		}
		
		/**
			Makes a clone of the original Object.
			
			@param obj: Object to make the clone of.
			@return Returns a duplicate Object.
			@example
				<code>
					this._author      = new Person();
					this._author.name = "Aaron";
					
					registerClassAlias("Person", Person);
					
					var humanClone:Person = Person(LGObject.clone(this._author));
					
					trace(humanClone.name);
				</code>
		*/
		public static function clone(obj:Object):Object {
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeObject(obj);
			byteArray.position = 0;
			
			return byteArray.readObject();
		}
		
		/**
			Creates an Array comprised of all the keys in an Object.
			
			@param obj: Object in which to find keys.
			@return Array containing all the string key names.
		*/
		public static function getKeys(obj:Object):Array {
			var keys:Array = new Array();
			
			for (var i:String in obj)
				keys.push(i);
			
			return keys;
		}
		
		/**
			Uses the strict equality operator to determine if object is <code>undefined</code>.
			
			@param obj: Object to determine if <code>undefined</code>.
			@return Returns <code>true</code> if object is <code>undefined</code>; otherwise <code>false</code>.
		*/
		public static function isUndefined(obj:Object):Boolean {
			return obj is undefined;
		}
		
		/**
			Uses the strict equality operator to determine if object is <code>null</code>.
			
			@param obj: Object to determine if <code>null</code>.
			@return Returns <code>true</code> if object is <code>null</code>; otherwise <code>false</code>.
		*/
		public static function isNull(obj:Object):Boolean {
			return obj === null;
		}
		
		/**
			Determines if object contains no value(s).
			
			@param obj: Object to derimine if empty.
			@return Returns <code>true</code> if object is empty; otherwise <code>false</code>.
			@example
				<code>
					var testNumber:Number;
					var testArray:Array   = new Array();
					var testString:String = "";
					var testObject:Object = new Object();
					
					trace(LGObject.isEmpty(testNumber)); // traces "true"
					trace(LGObject.isEmpty(testArray));  // traces "true"
					trace(LGObject.isEmpty(testString)); // traces "true"
					trace(LGObject.isEmpty(testObject)); // traces "true"
				</code>
		*/
		public static function isEmpty(obj:*):Boolean {
			if (obj == undefined)
				return true;
			
			if (obj is Number)
				return isNaN(obj);
			
			if (obj is Array || obj is String)
				return obj.length == 0;
			
			if (obj is Object) {
				for (var prop:String in obj)
					return false;
				
				return true;
			}
			
			return false;
		}
	}
}