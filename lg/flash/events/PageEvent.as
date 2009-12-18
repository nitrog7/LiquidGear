/**
 * PageEvent class
 *
 * @author: Giraldo Rosales
 * Copyright (c) 2009 Nitrogen Design. All rights reserved.
 *
 */

package lg.flash.events {
	import flash.events.*;
	
	public class PageEvent extends Event {
		public static var LOADED:String		= 'page_loaded';
		public static var XMLLOADED:String	= 'page_xml_loaded';
		public static var RESIZE:String		= 'page_resize';
		
		//Loading Events
		public static var COMPLETE:String	= 'page_complete';
		public static var IN:String			= 'page_transitionIn';
		public static var OUT:String		= 'page_transitionOut';
		public static var LOADING:String	= 'page_loading';
		public static var SETUP:String		= 'page_setup';
		public static var OPEN:String		= 'page_open';
		public static var CLOSE:String		= 'page_close';
		public static var START:String		= 'page_start';
		public static var PRELOADED:String	= 'page_preloaded';
		public static var PROGRESS:String	= 'page_progress';
		
		//3D Events
		public static var MOUSEOVER:String	= 'page_mouseover';
		public static var MOUSEOUT:String	= 'page_mouseout';
		public static var MOUSEDOWN:String	= 'page_mousedown';
		public static var MOUSEUP:String	= 'page_mouseup';
		public static var MOUSEMOVE:String	= 'page_mousemove';
		public static var CLICK:String		= 'page_click';
		
		/** The element details. **/
		public var params:Object	= {};
		/** Allows you to associate arbitrary data with the event. **/
		public var data:Object		= {};
		/** The event details. **/
		public var event:Object		= {};
		
		public function PageEvent(type:String, param:Object=null) {
			super(type);
			
			if(param != null) {
				this.params = param;
			}
		}
		
		public override function toString():String {
			return formatToString("PageEvent","type","bubbles","cancelable","eventPhase","params");
		}
	}
}