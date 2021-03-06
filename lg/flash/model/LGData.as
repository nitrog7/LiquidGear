/**
* LGData Class by Giraldo Rosales.
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

 package lg.flash.model {
	//Flash Classes
	import flash.events.EventDispatcher;
	import flash.system.System;
	import flash.utils.Dictionary;
	
	import lg.flash.events.ModelEvent;
	
	public class LGData extends EventDispatcher {
		/** Allows you to associate arbitrary data with the model. **/
		public var data:Object			= {};
		/** Indicates whether element will bubble events. **/
		public var bubble:Boolean		= false;
		/** @private **/
		protected var _data:Dictionary	= new Dictionary(true);
		/** @private **/
		protected var _listeners:Vector.<Object>	= new Vector.<Object>();
		
		/** Load data from an XML file. **/
		public function LGData() {
			data.cleanURL	= '';
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
		public function bind(type:String, fn:Function, capture:Boolean=false):LGData {
			addEventListener(type, fn, capture);
			return this;
		}
		
		/** Shortcut for the removeEventListener method. The advantage of unbind
		*	is the use of the event manager. You can remove all listeners of one
		*	type with a single call by not specifying a listener.
		*	
		*	@param type Type of event to remove.
		*	@param fn The function in the listener event to remove.**/
		public function unbind(type:String, fn:Function=null):LGData {
			//var listenArray:Array	= _listeners[type];
			var lisLen:int	= _listeners.length;
			
			if(!lisLen) {
				return this;
			}
			
			if(fn != null) {
				//remove a specific listener
				removeEventListener(type, fn);
			} else {
				//else remove all listeners for that type
				var lisObj:Object;
				
				for(var g:int=0; g<lisLen; g++) {
					lisObj	= _listeners[g];
					removeEventListener(lisObj.type, lisObj.fn);
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
			e.params	= data;
			e.data		= args;
			e.event		= event;
			
			if(bubble || e.eventPhase == 2) {
				dispatchEvent(e);
			}
			
			//Clean
			e	= null;
			
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
		
		
		public override function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			//Add listener
			super.addEventListener(type, listener, false, 0, true);
			
			if(useCapture) {
				return;
			}
			
			//Add listener to event manager
			var lisLen:int		= _listeners.length;
			_listeners[lisLen]	= {type:type, fn:listener};
		}
		
		public override function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			//Remove listener
			super.removeEventListener(type, listener, useCapture);
			
			//Remove listener from manager
			var lisLen:int	= _listeners.length;
			
			if(!lisLen) {
				return;
			}
			
			var lisIdx:int	= -1;
			var lisObj:Object;
			
			for(var g:int=0; g<lisLen; g++) {
				lisObj	= _listeners[g];
				
				if(lisObj.type == type) {
					if(lisObj.fn == listener) {
						lisIdx	= g;
					}
				}
			}
			
			
			if(lisIdx >=0) {
				_listeners.splice(lisIdx, 1);
			}
		}
		
		public function getParams(url:String):Object {
			var fullurl:String	= url;
			var query:Array		= [];
			var params:Object	= {};
			
			if(fullurl && fullurl != ''){
				query	= fullurl.split('?');
				
				if(query.length > 1) {		
					var varStr:String	= query[1];
					var varsArray:Array	= varStr.split('&');
					var qryLen:int		= varsArray.length;
					data.cleanURL		= query[0];
					
					for (var g:int=0; g<qryLen; g++){
						var index:int		= 0;
						var kvPair:String	= varsArray[g];
						
						if((index = kvPair.indexOf('=')) > 0){
							var key:String		= kvPair.substring(0,index);
							var value:String	= kvPair.substring(index + 1);
							params[key] = value;
						}
					}
				} else {
					data.cleanURL		= fullurl;
				}
			}
			
			return params;
		}
		
		public function get cleanURL():String {
			return data.cleanURL;
		}
		
		/** Clear all events from an element **/
		public function clearEvents():void {
			var lisLen:int	= _listeners.length;
			var lisObj:Object;
			
			for(var g:int; g<lisLen; g++) {
				lisObj	= _listeners[g];
				
				if(hasEventListener(lisObj.type)) {
					removeEventListener(lisObj.type, lisObj.fn);
				}
			}
			
			_listeners	= new Vector.<Object>();
		}
		
		/** Kill the object and clean from memory. **/
		public function kill():void {
			_data = null;
		}
	}
}
