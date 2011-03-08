/**
 * FilerManager Class by Giraldo Rosales.
 * Visit www.liquidgear.net for documentation and updates.
 *
 * @author Thomas John (thomas.john@open-design.be) www.open-design.be
 *
 * Copyright (c) 2011 Nitrogen Labs, Inc. All rights reserved.
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
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	import flash.utils.Dictionary;
	
	public class FilterManager { 
		// our unique instance of this class 
		private static var instance:FilterManager = new FilterManager();
		
		private var dFilters:Dictionary = new Dictionary();
		
		/**
		 * Constructor : check if an instance already exists and if it does throw an error
		 */ 
		public function FilterManager() { 
			if ( instance ) throw new Error( "FilterManager can only be accessed through FilterManager.getInstance()" );
		} 
		
		/**
		 * Get unique instance of this singleton class
		 * @return                    <FilterManager> Instance of this class
		 */ 
		public static function getInstance():FilterManager{ 
			return instance;
		} 
		
		public function add(target:DisplayObject, filter:BitmapFilter):void { 
			var tmp:Array = dFilters[target] as Array;
			if ( tmp == null ) tmp = dFilters[target] = target.filters;
			
			tmp.push(filter);
			target.filters = tmp;
		} 
		
		public function remove(target:DisplayObject, filter:BitmapFilter):void { 
			var tmp:Array = dFilters[target] as Array;
			
			if ( tmp == null ) tmp = dFilters[target] = target.filters;
			
			var index:int = indexOf(tmp, filter);
			if ( index < 0 ) return;
			tmp.splice(index, 1);
			target.filters = tmp;
		} 
		
		public function indexOf(filters:Array, filter:BitmapFilter):int { 
			var index:int = filters.length;
			var f:BitmapFilter;
			
			while(index--) { 
				f = filters[index];
				if (f == filter) return index;
			} 
			return -1;
		} 
	} 
} 