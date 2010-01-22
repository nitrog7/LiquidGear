package lg.flash.events {
	//Flash
	import flash.events.Event;
	
	//LG
	import flash.events.EventDispatcher;
	
	public class ElementDispatcher extends EventDispatcher {
		/** Allows you to associate arbitrary data with the element. **/
		public var data:Object					= {};
		/** Indicates whether element will bubble events. **/
		public var bubble:Boolean				= false;
		public var doubleClickEnabled:Boolean	= false;
		
		/** @private **/
		private var _listners:Object	= {};
		
		public function ElementDispatcher() {
		}
		
		/** Shortcut for a weak reference addEventListener call. Binds the type 
		 *	of event with the function. Also adds the listener to the event 
		 *	manager. If the double click event is used, it will automatically
		 *	set the doubleClickEnabled property to true.
		 *
		 *	@param type The type of event to bind. 
		 *	@param fn The function to call once the event is triggered. **/
		public function bind(type:String, fn:Function):ElementDispatcher {
			var listenArray:Array = _listners[type];
			if(listenArray == null) {
				listenArray	= [];
			}
			
			if(type == 'element_dblclick') {
				doubleClickEnabled	= true;
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
		
		//public function one(type:String, fn:Function):Element {
		//	var event:ElementEvent	= new ElementEvent(type);
		//	event.params	= data;
		//	event.one		= true;
		//	
		//	return this;
		//}
		
		/** Shortcut to dispatch an event. If any variables are to be sent with 
		 *	the event, you can pass them within an Object in the second parameter.
		 *	This way you can pull the data from the listener function. You can also 
		 *	use the params attribute on the event to grab any of the element 
		 *	variables stored in the data attribute.
		 *
		 *	@param type Type of event to dispatch. 
		 *	@param args Additional data to send with the event.
		 *	@param event Event data. **/
		public function trigger(type:String, args:Object=null, event:Object=null):ElementDispatcher {
			var e:ElementEvent	= new ElementEvent(type);
			e.params	= data;
			e.data		= args;
			e.event		= event;
			
			if(bubble || e.eventPhase == 2) {
				dispatchEvent(e);
			}
			
			return this;
		}
		
		/**@private **/
		override public function dispatchEvent(e:Event):Boolean {
			if (bubble || (hasEventListener(e.type) || e.bubbles)) {
				return super.dispatchEvent(e);
			}
			return true;
		}
		
		/** Shortcut for the removeEventListener method. The advantage of unbind
		 *	is the use of the event manager. You can remove all listeners of one
		 *	type with a single call by not specifying a listener.
		 *	
		 *	@param type Type of event to remove.
		 *	@param fn The function in the listener event to remove.**/
		public function unbind(type:String, fn:Function=null):ElementDispatcher {
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
			
			if(doubleClickEnabled && type == 'element_dblclick') {
				var dbl:Boolean	= false;
				for(var s:String in _listners) {
					if(s == 'element_dblclick') {
						dbl	= true;
					}
				}
				if(!dbl) {
					doubleClickEnabled	= false;
				}
			}
			
			return this;
		}
	}
}