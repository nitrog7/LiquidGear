/**
* Element Class by Giraldo Rosales.
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

package lg.flash.elements {
	//Flash Classes
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	//LG Classes
	import lg.flash.events.ElementEvent;
	import lg.flash.utils.LGDebug;
	
	/**
	* Dispatched when the element has been initialized.
	* @eventType mx.events.ElementEvent.INIT
	*/
	[Event(name="element_init", type="lg.flash.events.ElementEvent")]
	
	/**
	* Dispatched when the element has gained focus.
	* @eventType mx.events.ElementEvent.FOCUS
	*/
	[Event(name="element_focus", type="lg.flash.events.ElementEvent")]
	
	/**
	* Dispatched when the element has lost focus.
	* @eventType mx.events.ElementEvent.UNFOCUS
	*/
	[Event(name="element_unfocus", type="lg.flash.events.ElementEvent")]
	
	/**
	* Dispatched when the element has changed.
	* @eventType mx.events.ElementEvent.CHANGE
	*/
	[Event(name="element_change", type="lg.flash.events.ElementEvent")]
	
	/**
	* Dispatched when the element has been clicked.
	* @eventType mx.events.ElementEvent.CLICK
	*/
	[Event(name="element_click", type="lg.flash.events.ElementEvent")]
	
	/**
	* Dispatched when the element has been double clicked.
	* @eventType mx.events.ElementEvent.DBLCLICK
	*/
	[Event(name="element_dblclick", type="lg.flash.events.ElementEvent")]
	
	/**
	* Dispatched when a key has been pressed down.
	* @eventType mx.events.ElementEvent.KEYDOWN
	*/
	[Event(name="element_keydown", type="lg.flash.events.ElementEvent")]
	
	/**
	* Dispatched when the a key has been released.
	* @eventType mx.events.ElementEvent.KEYUP
	*/
	[Event(name="element_keyup", type="lg.flash.events.ElementEvent")]
	
	/**
	* Dispatched when the element has been added to the parent.
	* @eventType mx.events.ElementEvent.ADD
	*/
	[Event(name="element_add", type="lg.flash.events.ElementEvent")]
	
	/**
	* Dispatched when the element has been fully loaded.
	* @eventType mx.events.ElementEvent.LOADED
	*/
	[Event(name="element_loaded", type="lg.flash.events.ElementEvent")]
	
	/**
	* Dispatched when the mouse has been pressed down.
	* @eventType mx.events.ElementEvent.MOUSEDOWN
	*/
	[Event(name="element_mousedown", type="lg.flash.events.ElementEvent")]
	
	/**
	* Dispatched while the mouse is moving over the element.
	* @eventType mx.events.ElementEvent.MOUSEMOVE
	*/
	[Event(name="element_mousemove", type="lg.flash.events.ElementEvent")]
	
	/**
	* Dispatched when the mouse moves out of the element.
	* @eventType mx.events.ElementEvent.MOUSEOUT
	*/
	[Event(name="element_mouseout", type="lg.flash.events.ElementEvent")]
	
	/**
	* Dispatched when the mouse moves over the element.
	* @eventType mx.events.ElementEvent.MOUSEOVER
	*/
	[Event(name="element_mouseover", type="lg.flash.events.ElementEvent")]
	
	/**
	* Dispatched when the mouse is released over the element.
	* @eventType mx.events.ElementEvent.MOUSEUP
	*/
	[Event(name="element_mouseup", type="lg.flash.events.ElementEvent")]
	
	/**
	* Dispatched when the element is resized.
	* @eventType mx.events.ElementEvent.RESIZE
	*/
	[Event(name="element_resize", type="lg.flash.events.ElementEvent")]
	
	/**
	* Dispatched when the element has been uploaded.
	* @eventType mx.events.ElementEvent.UNLOAD
	*/
	[Event(name="element_unload", type="lg.flash.events.ElementEvent")]
	
	/**
	* Dispatched when an error occurs.
	* @eventType mx.events.ElementEvent.ERROR
	*/
	[Event(name="element_error", type="lg.flash.events.ElementEvent")]
	
	/**
	* Dispatched when a security or permissions error occurs.
	* @eventType mx.events.ElementEvent.SECURITYERROR
	*/
	[Event(name="element_security_error", type="lg.flash.events.ElementEvent")]
	
	/**
	* Dispatched when a security or permissions error occurs.
	* @eventType mx.events.ElementEvent.IOERROR
	*/
	[Event(name="element_io_error", type="lg.flash.events.ElementEvent")]
	
	/**
	* Dispatched while an element is loading.
	* @eventType mx.events.ElementEvent.PROGRESS
	*/
	[Event(name="element_progress", type="lg.flash.events.ElementEvent")]
	
	
	/**
	*	<p>The Element class is the foundation of LiquidGear. It contains the 
	*	basic events and attributes used. Most attributes are similar to that of
	*	an HTML element.</p>
	*	<p>If the object you are using is visible (such as an images, text, shapes,
	*	or SWF objects), you should use the VisualElement class which is an
	*	extension of the Element class. Element is best used for sounds
	*	and other simple items without visual effects.</p>
	*	
	**/
	public class Element extends Sprite {
		/** Unique identifier for the object. **/
		public var id:String			= '';
		/** Title. **/
		public var title:String			= '';
		//public var lang:String			= '';
		//public var dir:String			= '';
		//public var className:String		= '';
		//public var draggable:Boolean	= false;
		//public var contentEditable:String	= '';
		
		/** Base path for use with any external content. Will be used as a prefix
		* for any external files loaded into an element. **/
		public var basePath:String		= '';
		/** Allows you to associate arbitrary data with the element. **/
		public var data:Object			= {};
		/** Contains the child elements in an array. **/
		public var children:Vector.<DisplayObject>			= new Vector.<DisplayObject>();
		/** Contains the child elements in an object with the id as the key. **/
		public var elements:Object		= {};
		/** Indicates whether element has been toggled. **/
		public var toggled:Boolean		= false;
		/** Indicates whether element will bubble events. **/
		public var bubble:Boolean		= false;
		/** Debugger. Use console.on() to turn on the debugger, console.off() to turn it off.
		* Once on, you can use trace commands to the <a href="http://demonsterdebugger.com/">De Monster Debugger</a> client with
		* the commands, console.log(), console.warn(), and console.error(). **/
		public var console:LGDebug;
		
		public static var debug:Boolean	= false;
		
		/** @private **/
		private var toggleFunctions:Vector.<Function>	= new Vector.<Function>(2, true);
		/** @private **/
		private var _listners:Object	= {};
		/** @private **/
		private var _mouseTimer:Timer;
		/** @private **/
		private var _lmLoaded:Vector.<String>			= new Vector.<String>();
		/** @private **/
		private var _lmTotal:Vector.<String>			= new Vector.<String>();
		
		/** Constructs a new Element object	**/
		public function Element() {
			//Change event listeners
			addEventListener('init', onInit, false, 0, true);
			addEventListener('complete', onComplete, false, 0, true);
			addEventListener('focusOut', onBlur, false, 0, true);
			addEventListener('change', onChange, false, 0, true);
			addEventListener('click', onClick, false, 0, true);
			addEventListener('doubleClick', onDoubleClick, false, 0, true);
			addEventListener('focusIn', onFocus, false, 0, true);
			addEventListener('keyDown', onKeyDown, false, 0, true);
			addEventListener('keyUp', onKeyUp, false, 0, true);
			addEventListener('addedToStage', onAdd, false, 0, true);
			addEventListener('mouseDown', onMouseDown, false, 0, true);
			addEventListener('mouseMove', onMouseMove, false, 0, true);
			addEventListener('mouseOut', onMouseOut, false, 0, true);
			addEventListener('mouseOver', onMouseOver, false, 0, true);
			addEventListener('mouseUp', onMouseUp, false, 0, true);
			addEventListener('removeFromStage', onUnload, false, 0, true);
			addEventListener('enterFrame', onEnter, false, 0, true);
			
			data.isLoaded	= false;
			
			//Debugger
			console	= new LGDebug(this);
		}
		
		/** @private **/
		protected function setAttributes(obj:Object):void {
			if(!obj) {
				return;
			}
			
			if(obj.id) {
				obj.name	= obj.id;
			}
			
			for(var s:String in obj) {
				data[s] 	= obj[s];
				
				if(s in this) {
					if(obj[s] == 'true') {
						obj[s]	= true;
					}
					
					if(obj[s] == 'false') {
						obj[s]	= false;
					}
					
					this[s] = obj[s];
				}
			}
		}
		
		/** Is set to true when an element is loaded **/
		public function get isLoaded():Boolean {
			return data.isLoaded;
		}
		
		/** Sets the attributes on the element if either an object with key/value
		*	sets are included or a key as the first parameter and a value as the
		*	second parameter. Will return the value of an attribute if only a string
		*	is sent for the first parameter.
		*
		*	@param params Can be a string or an object with key/value sets.
		*	@return If a string is used without a second parameter, the method will 
		*	return the value specified in the element. Otherwise a string with a second 
		*	parameter value or an object with key/value pairs will set the specified 
		*	attributes and return the element.
		*	@param value The value to set the attribute specified in the first 
		*	parameter. **/
		public function css(params:*=null, value:String=null):* {
			if(params is String) {
				if(value) {
					this[params] = value;
					return this;
				} else {
					return data[params];
				}
			}
			else if(params is Object) {
				for(var s:String in params) {
					this[s] = params[s];
				}
				return this;
			} else {
				return null;
			}
		}
		
		/** Adds a child object to the element as well as to the elements property.
		*
		*	@param element A DisplayObject to add as a child element. **/
		public override function addChild(element:DisplayObject):DisplayObject {
			var elName:String	= element.name;
			elements[elName]	= element;
			
			var childLen:int	= children.length;
			children[childLen]	= element;
			
			super.addChild(element);
			return element;
		}
		
		/** Similar to addChild excepts keeps track of elements loaded. When all child elements added with
		* addExternal are loaded, the element dispatches an ElementEvent.LOADED event.
		*
		*	@param element An external Element to add. Will fire an Element.LOADED call when all elements are loaded. **/
		public function addExternal(element:Element):Element {
			if(!element) {
				return null;
			}
			
			var elName:String	= element.name;
			elements[elName]	= element;
			element.loaded(onLoadElement);
			
			var childLen:int	= children.length;
			children[childLen]	= element;
			
			var loadedLen:int	= _lmTotal.length;
			_lmTotal[loadedLen]	= element.id;
			
			super.addChild(element);
			return element;
		}
		
		/** References the Parent. Can add the parent if element has not yet been added. **/
		public function set parent(container:DisplayObjectContainer):void {
			data.parent	= container;
		}
		public override function get parent():DisplayObjectContainer {
			var container:DisplayObjectContainer;
			
			if(super.parent) {
				return super.parent;
			} else {
				return data.parent;
			}
		}
		
		/** @private **/
		private function onLoadElement(e:ElementEvent):void {
			if(bubble || e.eventPhase == 2) {
				var element:Element		= e.target as Element;
				element.unbind('element_loaded', onLoadElement);
				
				var loadedLen:int		= _lmLoaded.length;
				_lmLoaded[loadedLen]	= element.id;
				
				var percent:int			= (_lmLoaded.length > 0) ? (_lmLoaded.length / _lmTotal.length) * 100 : 0;
				
				if(percent >= 100) {
					data.isLoaded	= true;
					trigger('element_loaded');
				}
			}
		}
		
		/** Removes a child object from the element.
		*
		*	@param element A DisplayObject to add as a child element. **/
		public override function removeChild(element:DisplayObject):DisplayObject {
			if(element) {
				var elName:String	= element.name;
				
				for(var g:int=0; g<children.length; g++) {
					if(children[g] == elements[elName]) {
						children.splice(g, 1);
						break;
					}
				}
				
				elements[elName]	= null;
				
				if(element is Element) {
					var lgElement:Element = element as Element;
					lgElement.kill();
				}
				
				super.removeChild(element);
			}
			return element;
		}
		
		/** Shortcut for a weak reference addEventListener call. Binds the type 
		*	of event with the function. Also adds the listener to the event 
		*	manager. If the double click event is used, it will automatically
		*	set the doubleClickEnabled property to true.
		*
		*	@param type The type of event to bind. 
		*	@param fn The function to call once the event is triggered. **/
		public function bind(type:String, fn:Function):Element {
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
		public function trigger(type:String, args:Object=null, event:Object=null):Element {
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
		public function unbind(type:String, fn:Function=null):Element {
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
		
		//public function live(type:String, fn:Function):Element {
		//	return this;
		//}
		//public function die(type:String, fn:Function):Element {
		//	return this;
		//}
		
		/** Adds two listeners to the element. The first is a mouseover event and
		*	the second is a mouseout event.
		*	
		*	@param over The function to call when the mouse is over the element.
		*	@param out The function call when the mouse has moved out of the 
		*	element.**/
		public function hover(over:Function, out:Function):Element {
			mouseover(over);
			mouseout(out);
			return this;
		}
		
		/** Adds two alternating events to the element. Toggle between the events
		*	with every other click. Use <code>unbind('click')</code> to remove the
		*	toggle event.
		*	
		*	@param fn Click function.
		*	@param fn2 Click function.**/
		public function toggle(fn:Function=null, fn2:Function=null):Element {
			toggleFunctions		= [];
			toggleFunctions[0]	= fn;
			toggleFunctions[1]	= fn2;
			
			click(onToggleOn);
			
			return this;
		}
		
		/** @private **/
		private function onToggleOn(e:ElementEvent):void {
			unbind('element_click', onToggleOn);
			unbind('element_click', onToggleOff);
			click(onToggleOff);
			var fn:Function	= toggleFunctions[0];
			toggled	= true;
			fn(e);
		}
		/** @private **/
		private function onToggleOff(e:ElementEvent):void {
			unbind('element_click', onToggleOn);
			unbind('element_click', onToggleOff);
			click(onToggleOn);
			var fn:Function	= toggleFunctions[1];
			toggled	= false;
			fn(e);
		}
		
		/** Triggers the textField blur event. If a function is specified, the blur
		*	listener is, instead, added.
		*	
		*	@param fn Function to call when triggered.**/
		public function unfocus(fn:Function=null):Element {
			if(fn != null) {
				bind('element_unfocus', fn);
			} else {
				trigger('element_unfocus');
			}
			
			return this;
		}
		
		/** Triggers the change event. If a function is specified, the change
		*	listener is, instead, added.
		*	
		*	@param fn Function to call when triggered.**/
		public function change(fn:Function=null):Element {
			if(fn != null) {
				bind('element_change', fn);
			} else {
				trigger('element_change');
			}
			
			return this;
		}
		
		/** Triggers the click event. If a function is specified, the click
		*	listener is, instead, added.
		*	
		*	@param fn Function to call when triggered.**/
		public function click(fn:Function=null):Element {
			if(fn != null) {
				bind('element_click', fn);
			} else {
				trigger('element_click');
			}
			
			return this;
		}
		
		/** Triggers the double click event. If a function is specified, the double 
		*	click listener is, instead, added.
		*	
		*	@param fn Function to call when triggered.**/
		public function dblclick(fn:Function=null):Element {
			if(fn != null) {
				bind('element_dblclick', fn);
			} else {
				trigger('element_dblclick');
			}
			
			return this;
		}
		
		/** Triggers the error event. If a function is specified, the error
		*	listener is, instead, added.
		*	
		*	@param fn Function to call when triggered.**/
		public function error(fn:Function=null):Element {
			if(fn != null) {
				bind('element_error', fn);
			} else {
				trigger('element_error');
			}
			
			return this;
		}
		
		/** Triggers the textField focus event. If a function is specified, the focus
		*	listener is, instead, added.
		*	
		*	@param fn Function to call when triggered.**/
		public function focus(fn:Function=null):Element {
			if(fn != null) {
				bind('element_focus', fn);
			} else {
				trigger('element_focus');
			}
			
			return this;
		}
		
		/** Triggers the keydown event. If a function is specified, the keydown
		*	listener is, instead, added.
		*	
		*	@param fn Function to call when triggered.**/
		public function keydown(fn:Function=null):Element {
			if(fn != null) {
				bind('element_keydown', fn);
			} else {
				trigger('element_keydown');
			}
			
			return this;
		}
		
		/** Triggers the keypress event. If a function is specified, the keypress
		*	listener is, instead, added.
		*	
		*	@param fn Function to call when triggered.**/
		public function keypress(fn:Function=null):Element {
			if(fn != null) {
				bind('element_keypress', fn);
			} else {
				trigger('element_keypress');
			}
			
			return this;
		}
		
		/** Triggers the keyup event. If a function is specified, the keyup
		*	listener is, instead, added.
		*	
		*	@param fn Function to call when triggered.**/
		public function keyup(fn:Function=null):Element {
			if(fn != null) {
				bind('element_keyup', fn);
			} else {
				trigger('element_keyup');
			}
			
			return this;
		}
		
		/** Binds a function to the loaded event. 
		*	
		*	@param fn Function to call when triggered.**/
		public function loaded(fn:Function):Element {
			bind('element_loaded', fn);
			return this;
		}
		
		/** Binds a function to the progress event. 
		*	
		*	@param fn Function to call when triggered.**/
		public function progress(fn:Function):Element {
			bind('element_progress', fn);
			return this;
		}
		
		/** Binds a function to the init event. 
		*	
		*	@param fn Function to call when triggered.**/
		public function init(fn:Function):Element {
			bind('element_init', fn);
			return this;
		}
		
		/** Binds a function to the complete event. 
		*	
		*	@param fn Function to call when triggered.**/
		public function complete(fn:Function):Element {
			bind('element_complete', fn);
			return this;
		}
		
		/** Binds a function to the finish event. 
		*	
		*	@param fn Function to call when triggered.**/
		public function finish(fn:Function):Element {
			bind('element_finish', fn);
			return this;
		}
		
		/** Binds a function to the mousedown event. 
		*	
		*	@param fn Function to call when triggered.**/
		public function mousedown(fn:Function):Element {
			bind('element_mousedown', fn);
			return this;
		}
		
		/** Binds a function to the mousemove event. 
		*	
		*	@param fn Function to call when triggered.**/
		public function mousemove(fn:Function):Element {
			bind('element_mousemove', fn);
			return this;
		}
		
		/** Binds a function to the mouseout event. 
		*	
		*	@param fn Function to call when triggered.**/
		public function mouseout(fn:Function):Element {
			bind('element_mouseout', fn);
			return this;
		}
		
		/** Binds a function to the mouseover event. 
		*	
		*	@param fn Function to call when triggered.**/
		public function mouseover(fn:Function):Element {
			bind('element_mouseover', fn);
			return this;
		}
		
		/** Binds a function to the mouseup event. 
		*	
		*	@param fn Function to call when triggered.**/
		public function mouseup(fn:Function):Element {
			bind('element_mouseup', fn);
			return this;
		}
		
		/** Binds a function to the resize event. 
		*	
		*	@param fn Function to call when triggered.**/
		public function resize(fn:Function):Element {
			bind('element_resize', fn);
			return this;
		}
		
		/** Binds a function to the scroll event. 
		*	
		*	@param fn Function to call when triggered.**/
		public function scroll(fn:Function):Element {
			if(fn != null) {
				bind('element_scroll', fn);
			} else {
				trigger('element_scroll');
			}
			
			return this;
		}
		
		/** Binds a function to the select event. 
		*	
		*	@param fn Function to call when triggered.**/
		public function select(fn:Function=null):Element {
			if(fn != null) {
				bind('element_select', fn);
			} else {
				trigger('element_select');
			}
			
			return this;
		}
		
		/** Binds a function to the submit event. 
		*	
		*	@param fn Function to call when triggered.**/
		public function submit(fn:Function=null):Element {
			if(fn != null) {
				bind('element_submit', fn);
			} else {
				trigger('element_submit');
			}
			
			return this;
		}
		
		/** Binds a function to the unload event. 
		*	
		*	@param fn Function to call when triggered.**/
		public function unload(fn:Function):Element {
			bind('element_unload', fn);
			return this;
		}
		
		/* Convert AS3 Events */
		/** @private **/
		private function onInit(e:Event):void {
			trigger('element_init', null, e);
		}
		/** @private **/
		private function onComplete(e:Event):void {
			trigger('element_complete', null, e);
		}
		/** @private **/
		private function onBlur(e:FocusEvent):void {
			trigger('element_unfocus', null, e);
		}
		/** @private **/
		private function onChange(e:Event):void {
			trigger('element_change', null, e);
		}
		/** @private **/
		protected function onClick(e:MouseEvent):void {
			trigger('element_click', null, e);
		}
		/** @private **/
		protected function onDoubleClick(e:MouseEvent):void {
			trigger('element_dblclick', null, e);
		}
		/** @private **/
		private function onFocus(e:FocusEvent):void {
			trigger('element_', null, e);
		}
		/** @private **/
		private function onEnter(e:Event):void {
			trigger('element_enter', null, e);
		}
		/** @private **/
		private function onKeyDown(e:KeyboardEvent):void {
			trigger('element_keydown', null, e);
		}
		/** @private **/
		private function onKeyUp(e:KeyboardEvent):void {
			trigger('element_keyup', null, e);
		}
		/** @private **/
		private function onAdd(e:Event):void {
			update();
			trigger('element_add', null, e);
		}
		/** @private **/
		private function onMouseDown(e:MouseEvent):void {
			trigger('element_mousedown', null, e);
		}
		/** @private **/
		private function onMouseMove(e:MouseEvent):void {
			trigger('element_mousemove', null, e);
		}
		/** @private **/
		protected function onMouseOut(e:MouseEvent):void {
			trigger('element_mouseout', null, e);
		}
		/** @private **/
		protected function onMouseOver(e:MouseEvent):void {
			trigger('element_mouseover', null, e);
		}
		/** @private **/
		private function onMouseUp(e:MouseEvent):void {
			trigger('element_mouseup', null, e);
		}
		/** @private **/
		private function onUnload(e:Event):void {
			trigger('element_unload', null, e);
		}
		/** @private **/
		private function onError(e:IOErrorEvent):void {
			trigger('element_error', null, e);
			trace('IO Error: '+e.text);
		}
		/** @private **/
		protected function onProgress(e:ProgressEvent):void {
			trigger('element_progress', null, e);
		}
		
		/** Sets the element up to be a container to other visible items. The 
		*	element becomes a ghost, yet all child elements are still interactive with the mouse. **/
		public function holder():void {
			buttonMode		= false;
			mouseEnabled	= false;
			mouseChildren	= true;
			useHandCursor	= false;
		}
		
		//Positioning
		/** Pulls the element in the front of the existing children. **/
		public function toFront():void {
			parent.setChildIndex(this, parent.numChildren-1);
		}
		/** Pushes the element to the back, behind all the elements within the parent **/
		public function toBack():void {
			parent.setChildIndex(this, 1);
		}
		
		
		/** The Flash Player has a bad habit of losing the mouse when the mouse
		*	goes off screen. When this method is called, it monitors whether or 
		*	not the mouse is still over the element. This can reduce performance
		*	slightly so use it sparingly. **/
		public function startMonitorMouse():void {
			_mouseTimer = new Timer(750, 0);
			_mouseTimer.start();
			_mouseTimer.addEventListener(TimerEvent.TIMER, checkMouseOut, false, 0, true);
		}
		/** Stops the mouse monitor. **/
		public function stopMonitorMouse():void {
			_mouseTimer.stop();
			_mouseTimer.removeEventListener(TimerEvent.TIMER, checkMouseOut);
		}
		
		/** @private **/
		private function checkMouseOut(e:TimerEvent):void {
			var localMouse:Point	= new Point(mouseX, mouseY);
			var globalMouse:Point	= localToGlobal(localMouse);
			
			if(!hitTestPoint(globalMouse.x, globalMouse.y, true)) {
				trigger('element_mouseout');
			}
		}
		
		/** Indicates whether the element has been setup. **/
		public function set isSetup(value:Boolean):void {
			data.isSetup = value;
			
			if(value) {
				update();
			}
		}
		public function get isSetup():Boolean {
			if(data != null) {
				return data.isSetup;
			} else {
				return false;
			}
		}
		
		/** Update the elements properties. **/
		public function update(obj:Object=null):void {
		}
		
		/** Kill the object and clean from memory. **/
		public function kill():void {
			//Remove listeners
			removeEventListener('init', onInit);
			removeEventListener('complete', onComplete);
			removeEventListener('focusOut', onBlur);
			removeEventListener('change', onChange);
			removeEventListener('click', onClick);
			removeEventListener('doubleClick', onDoubleClick);
			removeEventListener('focusIn', onFocus);
			removeEventListener('keyDown', onKeyDown);
			removeEventListener('keyUp', onKeyUp);
			removeEventListener('addedToStage', onAdd);
			removeEventListener('mouseDown', onMouseDown);
			removeEventListener('mouseMove', onMouseMove);
			removeEventListener('mouseOut', onMouseOut);
			removeEventListener('mouseOver', onMouseOver);
			removeEventListener('mouseUp', onMouseUp);
			removeEventListener('removeFromStage', onUnload);
			removeEventListener('enterFrame', onEnter);
			
			if(_mouseTimer) {
				_mouseTimer.removeEventListener(TimerEvent.TIMER, checkMouseOut);
			}
			
			//Remove Listeners
			for(var s:String in _listners) {
				var listenArray:Array	= _listners[s];
				var lisLen:int			= listenArray.length;
				
				for(var g:int=0; g<lisLen; g++) {
					removeEventListener(s, listenArray[g]);
				}
			}
			
			//Remove Children
			for(var h:int=children.length; h>0; h--) {
				removeChild(elements[h-1]);
			}
			
			//Nullify values
			id			= null;
			title		= null;
			//lang		= null;
			//dir			= null;
			//className	= null;
			basePath	= null;
			data		= null;
			_listners	= null;
			_mouseTimer	= null;
			//contentEditable	= null;
		}
	}
}
