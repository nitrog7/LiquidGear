/**
* ModelEvent Class by Giraldo Rosales.
* Visit www.liquidgear.net for documentation and updates.
*
*
* Copyright (c) 2009 Nitrogen Design, Inc. All rights reserved.
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

package lg.flash.events {
	import flash.events.*;
	
	public class ModelEvent extends Event {
		public static var LOADED:String		= 'data_loaded';
		public static var AUTH:String		= 'data_auth';
		public static var ERROR:String		= 'data_error';
		public static var IOERROR:String	= 'data_io_error';
		
		/** The model details. **/
		public var params:Object	= {};
		/** Allows you to associate arbitrary data with the event. **/
		public var data:Object		= {};
		/** The event details. **/
		public var event:Object		= {};
		
		public function ModelEvent(type:String, param:Object=null) {
			super(type);
			
			if(param != null) {
				params = param;
			}
		}
		
		public override function clone():Event {
			return new ModelEvent(type, params);
		}
		
		public override function toString():String {
			return formatToString("ModelEvent","type","bubbles","cancelable","eventPhase","params");
		}
	}
}