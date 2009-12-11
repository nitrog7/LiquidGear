/**
* ElementEvent Class by Giraldo Rosales.
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
	import flash.events.Event;
	
	public class ElementEvent extends Event {
		public static var INIT:String			= 'element_init';
		public static var BLUR:String			= 'element_blur';
		public static var CHANGE:String			= 'element_change';
		public static var CLICK:String			= 'element_click';
		public static var DBLCLICK:String		= 'element_dblclick';
		public static var FOCUS:String			= 'element_focus';
		public static var UNFOCUS:String		= 'element_unfocus';
		public static var KEYDOWN:String		= 'element_keydown';
		public static var KEYPRESS:String		= 'element_keypress';
		public static var KEYUP:String			= 'element_keyup';
		public static var ADD:String			= 'element_add';
		public static var LOADED:String			= 'element_loaded';
		public static var MOUSEDOWN:String		= 'element_mousedown';
		public static var MOUSEMOVE:String		= 'element_mousemove';
		public static var MOUSEOUT:String		= 'element_mouseout';
		public static var MOUSEOVER:String		= 'element_mouseover';
		public static var MOUSEUP:String		= 'element_mouseup';
		public static var RESIZE:String			= 'element_resize';
		public static var SCROLL:String			= 'element_scroll';
		public static var SUBMIT:String			= 'element_submit';
		public static var UNLOAD:String			= 'element_unload';
		public static var OPEN:String			= 'element_open';
		public static var ENTER:String			= 'element_enter';
		public static var SELECT:String			= 'element_select';
		public static var UNSELECT:String		= 'element_unselect';
		
		//Errors
		public static var ERROR:String			= 'element_error';
		public static var SECURITYERROR:String	= 'element_security_error';
		public static var IOERROR:String		= 'element_io_error';
		
		//Tween
		public static var TWEENSTART:String		= 'element_tween_start';
		public static var TWEENUPDATE:String	= 'element_tween_update';
		public static var TWEENEND:String		= 'element_tween_end';
		
		//Media
		public static var PLAY:String			= 'element_play';
		public static var STOP:String			= 'element_stop';
		public static var PAUSE:String			= 'element_pause';
		public static var PROGRESS:String		= 'element_progress';
		public static var FINISH:String			= 'element_finish';
		public static var UPDATE:String			= 'element_update';
		
		/** The element details. **/
		public var params:Object	= {};
		/** Allows you to associate arbitrary data with the event. **/
		public var data:Object		= {};
		/** The event details. **/
		public var event:Object		= {};
		
		public var one:Boolean		= false;
		
		public function ElementEvent(type:String, param:Object=null) {
			super(type);
			
			if(param != null) {
				this.params = param;
			}
		}
		
		public override function toString():String {
			return formatToString('ElementEvent', 'type', 'bubbles', 'cancelable', 'eventPhase', 'params');
		}
	}
}