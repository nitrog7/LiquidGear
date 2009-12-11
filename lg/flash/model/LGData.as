/**
* LGData Class by Giraldo Rosales.
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

 package lg.flash.model {
	//Flash Classes
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.system.System;
	
	//LG Classes
	import lg.flash.events.ModelEvent;
	
	public class LGData extends EventDispatcher {
		/** Allows you to associate arbitrary data with the model. **/
		public var data:Object			= {};
		/** @private **/
		protected var _data:Dictionary	= new Dictionary(true);
		/** @private **/
		protected var _listners:Object	= {};
		
		/** Load data from an XML file. **/
		public function LGData() {
		}
		
		/** Get data. 
		*	@param name Returns all data associated with an id.
		**/
		public function getData(name:String):Object {
			return _data[name];
		}
		
		/** Load data. 
		*	@param obj Object containing all the properties to load data from an XML.
		**/
		public function load(obj:Object):void {
		}
		
		/** Shortcut for a weak reference addEventListener call. Binds the type 
		*	of event with the function. Also adds the listener to the event 
		*	manager. If the double click event is used, it will automatically
		*	set the doubleClickEnabled property to true.
		*
		*	@param type The type of event to bind. 
		*	@param fn The function to call once the event is triggered. **/
		public function bind(type:String, fn:Function):LGData {
			var listenArray:Array = _listners[type];
			if(listenArray == null) {
				listenArray	= [];
			}
			
			var lisLen:int		= listenArray.length;
			listenArray[lisLen]	= fn;
			_listners[type]	= listenArray;
			addEventListener(type, fn, false, 0, true);
			
			//Cleanup
			listenArray	= null;
			type		= null;
			fn			= null;
			return this;
		}
		
		/** Shortcut for the removeEventListener method. The advantage of unbind
		*	is the use of the event manager. You can remove all listeners of one
		*	type with a single call by not specifying a listener.
		*	
		*	@param type Type of event to remove.
		*	@param fn The function in the listener event to remove.**/
		public function unbind(type:String, fn:Function=null):LGData {
			if(fn != null) {
				//remove a specific listener
				removeEventListener(type, fn);
			} else {
				//else remove all listeners for that type
				var listenArray:Array	= _listners[type];
				var lisLen:int			= listenArray.length;
				for(var g:int=0; g<lisLen; g++) {
					removeEventListener(type, listenArray[g]);
				}
			}
			
			return this;
		}
		
		/** Shortcut to dispatch an event. If any variables are to be sent with 
		*	the event, you can pass them within an Object in the second parameter.
		*	This way you can pull the data from the listener function. You can also 
		*	use the params attribute on the event to grab any of the data 
		*	variables stored in the vars attribute.
		*
		*	@param type Type of event to dispatch. 
		*	@param args Additional data to send with the event.
		*	@param event Event data. **/
		public function trigger(type:String, args:Object=null, event:Object=null):LGData {
			var e:ModelEvent	= new ModelEvent(type);
			e.params			= data;
			e.data				= args;
			e.event				= event;
			
			if(e.eventPhase == 2) {
				dispatchEvent(e);
			}
			
			return this;
		}
		
		/** Triggers the error event. If a function is specified, the error
		*	listener is, instead, added.
		*	
		*	@param fn Function to call when triggered.**/
		public function error(fn:Function=null):LGData {
			if(fn != null) {
				bind('data_error', fn);
			} else {
				trigger('data_error');
			}
			
			return this;
		}
		
		/** Binds a function to the loaded event. 
		*	
		*	@param fn Function to call when triggered.**/
		public function loaded(fn:Function):void {
			bind('data_loaded', fn);
		}
		
		/** Kill the object and clean from memory. **/
		public function kill():void {
			_data = null;
		}
	}
}
