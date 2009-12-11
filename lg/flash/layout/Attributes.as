/**
* Attributes Class by Nick Farina and Philippe Elass.
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
	import flash.text.StyleSheet;
	import flash.utils.Dictionary;
	
	//LG
	import lg.flash.elements.Container;
	import lg.flash.layout.BxmlParser;
	
	public class Attributes {
		// Dictionary with weak keys allows us to extends objects with instances of Attributes
		// while still allowing the objects to become garbage collected.
		private static var _targets:Dictionary = new Dictionary(true);
		
		// We can't hold a reference to our target, or else it would never get garbage
		// collected (circular reference). Since there's no direct WeakReference class
		// in AS3, we use the Dictionary class and exploit its weak-keys feature.
		private var _targetRef:Dictionary = new Dictionary(true);
		
		protected function get target():* {
			for (var t:* in _targetRef) {
				return t;
			}
		}
		
		protected function invalidateContainer():void {
			// do this directly to avoid another function call
			for (var t:* in _targetRef) {
				if (t.parent is Container) {
					var p:Container	= t.parent as Container;
					p.invalidateLayout();
				}
			}
		}

		/**
		 * Searches for the given attributes type assigned to the given target.
		 * If not found, it is created, so you will never get null back.
		 */
		public static function findOrCreate(target:*, attributesType:Class):* {
			var attributeDict:Dictionary = _targets[target] as Dictionary;
			
			if(!attributeDict) {
				_targets[target] = attributeDict = new Dictionary(true);
			}
			
			var attributes:*	= attributeDict[attributesType];
			
			if(attributes) {
				return attributes;
			} else {
				var attributesObj:Attributes		= new attributesType();
				attributesObj._targetRef[target]	= null;
				attributeDict[attributesType]		= attributesObj;
				return attributesObj;
			}
		}		
	}
}
