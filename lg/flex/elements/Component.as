/**
 * Component Class by Giraldo Rosales.
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

package lg.flex.elements {
	//Flash Classes
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.utils.Timer;
	
	import lg.flash.events.ElementEvent;
	import lg.flash.motion.TweenMax;
	import lg.flash.motion.easing.Quint;
	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.filters.BaseFilter;
	
	import spark.components.Group;
	import spark.core.SpriteVisualElement;
	import spark.filters.DropShadowFilter;
	import spark.filters.GlowFilter;
	
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
	public class Component extends UIComponent {
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
		/** Indicates whether element will be automatically added to a page. **/
		public var addToPage:Boolean	= true;
		/** Debugger. Use console.on() to turn on the debugger, console.off() to turn it off.
		 * Once on, you can use trace commands to the <a href="http://demonsterdebugger.com/">De Monster Debugger</a> client with
		 * the commands, console.log(), console.warn(), and console.error(). **/
		
		public static var debug:Boolean	= false;
		
		/** @private **/
		private var toggleFunctions:Vector.<Function>	= new Vector.<Function>(2, true);
		/** @private **/
		private var _listeners:Vector.<Object>			= new Vector.<Object>();
		/** @private **/
		private var _lmLoaded:Vector.<String>			= new Vector.<String>();
		/** @private **/
		private var _lmTotal:Vector.<String>			= new Vector.<String>();
		
		/** Constructs a new Element object	**/
		public function Component() {
			mouseEnabled	= false;
			mouseChildren	= false;
			
			data.id			= name;
			data._isLoaded	= false;
			data.stretch	= true;
			
			data.shadow				= null;
			data.glow				= null;
			data.blur				= null;
			data.stroke				= null;
			data.hoverGlow			= null;
			data.hoverGlowColor		= 0xffffff;
			data.hoverGlowSize		= 10;
			
			switch(Capabilities.playerType) {
				case 'External':
				case 'StandAlone':
					data._development	= true;
					break;
				default :
					data._development	= false;
					break;
			}
		}
		
		/** @private **/
		protected function setAttributes(obj:Object, ignore:Array=null):void {
			if(!obj) {
				return;
			}
			
			if(obj.id) {
				id	= obj.id;
			}
			
			for(var s:String in obj) {
				data[s] 	= obj[s];
				
				if(ignore) {
					if(ignore.indexOf(s) >= 0) {
						continue;
					}
				}
				
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
			return data._isLoaded;
		}
		
		/** Is running in the debug mode. True if run in the Flash Player, false if run in the browser. **/
		public function get isDevelopment():Boolean {
			return data._development;
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
			if(!element) {
				return null;
			}
			
			var elName:String	= element.name;
			elements[elName]	= element;
			
			var childLen:int	= children.length;
			children[childLen]	= element;
			
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
					data._isLoaded		= true;
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
				var childLen:int	= children.length;
				
				for(var g:int=0; g<childLen; g++) {
					if(children[g] == elements[elName]) {
						children.splice(g, 1);
						break;
					}
				}
				
				elements[elName]	= null;
				
				//if(element is Element) {
				//	var lgElement:Element = element as Element;
				//	lgElement.kill();
				//}
				
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
		public function bind(type:String, fn:Function, capture:Boolean=false):Component {
			addEventListener(type, fn, capture);
			return this;
		}
		
		/** Shortcut to dispatch an event. If any variables are to be sent with 
		 *	the event, you can pass them within an Object in the second parameter.
		 *	This way you can pull the data from the listener function. You can also 
		 *	use the params attribute on the event to grab any of the element 
		 *	variables stored in the data attribute.
		 *
		 *	@param type Type of event to dispatch. 
		 *	@param args Additional data to send with the event.
		 *	@param event Event data. **/
		public function trigger(type:String, args:Object=null, event:Object=null):Component {
			var e:ElementEvent	= new ElementEvent(type);
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
		public function unbind(type:String, fn:Function=null):Component {
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
		
		//public function live(type:String, fn:Function):Component {
		//	return this;
		//}
		//public function die(type:String, fn:Function):Component {
		//	return this;
		//}
		
		/** Adds two listeners to the element. The first is a mouseover event and
		 *	the second is a mouseout event.
		 *	
		 *	@param over The function to call when the mouse is over the element.
		 *	@param out The function call when the mouse has moved out of the 
		 *	element.**/
		public function hover(over:Function, out:Function):Component {
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
		public function toggle(fn:Function=null, fn2:Function=null):Component {
			toggleFunctions		= new Vector.<Function>(2, true);
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
		public function unfocus(fn:Function=null):Component {
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
		public function change(fn:Function=null):Component {
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
		public function click(fn:Function=null):Component {
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
		public function dblclick(fn:Function=null):Component {
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
		public function error(fn:Function=null):Component {
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
		public function focus(fn:Function=null):Component {
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
		public function keydown(fn:Function=null):Component {
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
		public function keypress(fn:Function=null):Component {
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
		public function keyup(fn:Function=null):Component {
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
		public function loaded(fn:Function):Component {
			bind('element_loaded', fn);
			return this;
		}
		
		/** Binds a function to the progress event. 
		 *	
		 *	@param fn Function to call when triggered.**/
		public function progress(fn:Function):Component {
			bind('element_progress', fn);
			return this;
		}
		
		/** Binds a function to the init event. 
		 *	
		 *	@param fn Function to call when triggered.**/
		public function init(fn:Function):Component {
			bind('element_init', fn);
			return this;
		}
		
		/** Binds a function to the complete event. 
		 *	
		 *	@param fn Function to call when triggered.**/
		public function complete(fn:Function):Component {
			bind('element_complete', fn);
			return this;
		}
		
		/** Binds a function to the finish event. 
		 *	
		 *	@param fn Function to call when triggered.**/
		public function finish(fn:Function):Component {
			bind('element_finish', fn);
			return this;
		}
		
		/** Binds a function to the mousedown event. 
		 *	
		 *	@param fn Function to call when triggered.**/
		public function mousedown(fn:Function):Component {
			bind('element_mousedown', fn);
			return this;
		}
		
		/** Binds a function to the mousemove event. 
		 *	
		 *	@param fn Function to call when triggered.**/
		public function mousemove(fn:Function):Component {
			bind('element_mousemove', fn);
			return this;
		}
		
		/** Binds a function to the mouseout event. 
		 *	
		 *	@param fn Function to call when triggered.**/
		public function mouseout(fn:Function):Component {
			bind('element_mouseout', fn);
			return this;
		}
		
		/** Binds a function to the mouseover event. 
		 *	
		 *	@param fn Function to call when triggered.**/
		public function mouseover(fn:Function):Component {
			bind('element_mouseover', fn);
			return this;
		}
		
		/** Binds a function to the mouseup event. 
		 *	
		 *	@param fn Function to call when triggered.**/
		public function mouseup(fn:Function):Component {
			bind('element_mouseup', fn);
			return this;
		}
		
		/** Binds a function to the resize event. 
		 *	
		 *	@param fn Function to call when triggered.**/
		public function resize(fn:Function):Component {
			bind('element_resize', fn);
			return this;
		}
		
		/** Binds a function to the scroll event. 
		 *	
		 *	@param fn Function to call when triggered.**/
		public function scroll(fn:Function):Component {
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
		public function select(fn:Function=null):Component {
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
		public function submit(fn:Function=null):Component {
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
		public function unload(fn:Function):Component {
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
			trigger('element_focus', null, e);
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
			trace('IO Error: For element, ' + id, e.text);
			trigger('element_error', null, e);
		}
		/** @private **/
		protected function onProgress(e:ProgressEvent):void {
			trigger('element_progress', null, e);
		}
		
		public function set stretch(value:Boolean):void {
			data.stretch	= value;
		}
		public function get stretch():Boolean {
			return data.stretch;
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
		
		public override function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			//Add listener
			super.addEventListener(type, listener, false, 0, true);
			
			if(useCapture) {
				return;
			}
			
			//Add listener to event manager
			var lisLen:int		= _listeners.length;
			_listeners[lisLen]	= {type:type, fn:listener};
			
			//Add alias if exists
			switch(type) {
				case 'element_init':
					super.addEventListener('init', onInit, false, 0, true);
					break;
				case 'element_complete':
					super.addEventListener('complete', onComplete, false, 0, true);
					break;
				case 'element_enter':
					super.addEventListener('enterFrame', onEnter, false, 0, true);
					break;
				case 'element_focus':
					super.addEventListener('focusIn', onFocus, false, 0, true);
					break;
				case 'element_unfocus':
					super.addEventListener('focusOut', onBlur, false, 0, true);
					break;
				case 'element_change':
					super.addEventListener('change', onChange, false, 0, true);
					break;
				case 'element_keydown':
					super.addEventListener('keyDown', onKeyDown, false, 0, true);
					break;
				case 'element_keyup':
					super.addEventListener('keyUp', onKeyUp, false, 0, true);
					break;
				case 'element_add':
					super.addEventListener('addedToStage', onAdd, false, 0, true);
					break;
				case 'element_unload':
					super.addEventListener('removeFromStage', onUnload, false, 0, true);
					break;
				case 'element_click':
					super.addEventListener('click', onClick, false, 0, true);
					break;
				case 'element_mouseover':
					super.addEventListener('mouseOver', onMouseOver, false, 0, true);
					break;
				case 'element_mousedown':
					super.addEventListener('mouseDown', onMouseDown, false, 0, true);
					break;
				case 'element_mousemove':
					super.addEventListener('mouseMove', onMouseMove, false, 0, true);
					break;
				case 'element_mouseout':
					super.addEventListener('mouseOut', onMouseOut, false, 0, true);
					break;
				case 'element_mouseup':
					super.addEventListener('mouseUp', onMouseUp, false, 0, true);
					break;
				case 'element_dblclick':
					super.addEventListener('doubleClick', onDoubleClick, false, 0, true);
					doubleClickEnabled	= true;
					break;
			}
		}
		public override function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			//Remove listener
			super.removeEventListener(type, listener, useCapture);
			
			//Remove listener from manager
			var lisLen:int	= _listeners.length;
			
			if(!lisLen) {
				return;
			}
			
			var lisCnt:int	= 0;
			var lisIdx:int	= -1;
			var lisObj:Object;
			
			for(var g:int=0; g<lisLen; g++) {
				lisObj	= _listeners[g];
				
				if(lisObj.type == type) {
					lisCnt++;
					
					if(lisObj.fn == listener) {
						lisIdx	= g;
					}
				}
			}
			
			
			if(lisIdx >=0) {
				_listeners.splice(lisIdx, 1);
			}
			
			//Only remove alias if all references to the event are removed
			if(lisCnt > 1) {
				return;
			}
			
			//Remove alias
			switch(type) {
				case 'element_init':
					super.removeEventListener('init', onInit);
					break;
				case 'element_complete':
					super.removeEventListener('complete', onComplete);
					break;
				case 'element_enter':
					super.removeEventListener('enterFrame', onEnter);
					break;
				case 'element_focus':
					super.removeEventListener('focusIn', onFocus);
					break;
				case 'element_unfocus':
					removeEventListener('focusOut', onBlur);
					break;
				case 'element_change':
					super.removeEventListener('change', onChange);
					break;
				case 'element_keydown':
					super.removeEventListener('keyDown', onKeyDown);
					break;
				case 'element_keyup':
					super.removeEventListener('keyUp', onKeyUp);
					break;
				case 'element_add':
					super.removeEventListener('addedToStage', onAdd);
					break;
				case 'element_unload':
					super.removeEventListener('removeFromStage', onUnload);
					break;
				case 'element_click':
					super.removeEventListener('click', onClick);
					break;
				case 'element_mouseover':
					super.removeEventListener('mouseOver', onMouseOver);
					break;
				case 'element_mousedown':
					super.removeEventListener('mouseDown', onMouseDown);
					break;
				case 'element_mousemove':
					super.removeEventListener('mouseMove', onMouseMove);
					break;
				case 'element_mouseout':
					super.removeEventListener('mouseOut', onMouseOut);
					break;
				case 'element_mouseup':
					removeEventListener('mouseUp', onMouseUp);
					break;
				case 'element_dblclick':
					super.removeEventListener('doubleClick', onDoubleClick);
					doubleClickEnabled	= false;
					break;
			}
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
		
		/** Sets the element up to be a container to other visible items. The 
		 *	element becomes a ghost, yet all child elements are still interactive with the mouse. **/
		public function holder():void {
			buttonMode		= false;
			mouseEnabled	= false;
			mouseChildren	= true;
			useHandCursor	= false;
			stretch			= false;
		}
		
		/** Makes the element visible to the eye but invisible to the mouse. **/
		public function ghost():void {
			buttonMode		= false;
			useHandCursor	= false;
			mouseEnabled	= false;
			mouseChildren	= false;
		}
		
		/** Gives the element button attributes. **/
		public function button():void {
			buttonMode		= true;
			useHandCursor	= true;
			mouseEnabled	= true;
			mouseChildren	= false;
		}
		
		/*=========================
		* EFFECTS
		*=========================*/
		
		/** Fade in element 
		 *	@param duration (optional) The duration of the animation. if set to 0, the element visibility is promptly set to true and alpha to 1.
		 *	@param delay (optional) Amount of time to wait before starting the aniamtion.
		 *	@param callback (optional) Function to call on completion.
		 *	@param params (optional) Parameters to send with function on complete.
		 */
		public function show(duration:Number=0, delay:Number=0, callback:Function=null, params:Array=null):Component {
			toFront();
			
			if(duration) {
				TweenMax.to(this, duration, {delay:delay, autoAlpha:1, ease:Quint.easeInOut, onComplete:callback, onCompleteParams:params});
			} else {
				hidden	= false;
			}
			
			return this;
		}
		
		/** Fade out element 
		 *	@param duration (optional) The duration of the animation. if set to 0, the element visibility is promptly set to false and alpha to 0.
		 *	@param delay (optional) Amount of time to wait before starting the aniamtion.
		 *	@param callback (optional) Function to call on completion.
		 *	@param params (optional) Parameters to send with function on complete.
		 */
		public function hide(duration:Number=0, delay:Number=0, callback:Function=null, params:Array=null):Component {
			if(duration) {
				TweenMax.to(this, duration, {delay:delay, autoAlpha:0, ease:Quint.easeInOut, onComplete:callback, onCompleteParams:params});
			} else {
				hidden	= true;
			}
			
			return this;
		}
		
		/** Pulls the element in the front of the existing children. **/
		public function toFront():void {
			if(parent) {
				if(parent is Group) {
					var group:Group	= parent as Group;
					group.setElementIndex(this, parent.numChildren-1);
				} else {
					parent.setChildIndex(this, parent.numChildren-1);
				}
			}
		}
		/** Pushes the element to the back, behind all the elements within the parent **/
		public function toBack():void {
			if(parent) {
				if(parent is Group) {
					var group:Group	= parent as Group;
					group.setElementIndex(this, parent.numChildren-1);
				} else {
					parent.setChildIndex(this, 1);
				}
			}
		}
		
		/** Toggles the alpha and visibility of an element. 
		 *	@default false */
		public function get hidden():Boolean {
			var isHidden:Boolean	= (alpha == 0 && !visible) ? true : false;
			return isHidden;
		}
		public function set hidden(value:Boolean):void {
			data.hidden	= value;
			
			if(value) {
				alpha	= 0;
				visible	= false;
			} else {
				alpha	= 1;
				visible	= true;
			}
		}
		
		/**
		 *	Set the size of the element
		 *	@param Set width.
		 *	@param Set height.
		 **/
		public function setSize(width:Number, height:Number):void {
			this.width	= width;
			this.height	= height;
		}
		
		/**
		 *	Set the position of the element
		 *	@param Set x position.
		 *	@param Set y position.
		 **/
		public function setPos(x:Number, y:Number, z:Number=0):void {
			this.x	= x;
			this.y	= y;
		}
		
		/** Animate element **/
		public function animate(obj:Object):void {
			//obj.target	= this;
			//new Tween(obj);
			var duration:Number	= obj.duration;
			delete(obj.duration);
			
			TweenMax.to(this, duration, obj); 
		}
		
		/**
		 *	Add a drop shadow to the element.
		 *	@param prop Properties of the dropShadowFilter.
		 *	<ul>
		 *		<li><strong>alpha</strong>:<em>Number</em> - Alpha transparency value for the color. (default: 1)</li>
		 *		<li><strong>distance</strong>:<em>Number</em> - Offset distance for the shadow, in pixels. (default: 0)</li>
		 *		<li><strong>angle</strong>:<em>Number</em> - Angle of the shadow. (default: 45)</li>
		 *		<li><strong>blurX</strong>:<em>Number</em> - Amount of horizontal blur. (default: 15)</li>
		 *		<li><strong>blurY</strong>:<em>Number</em> - Amount of vertical blur. (default: 15)</li>
		 *		<li><strong>color</strong>:<em>uint</em> - Color of the shadow. (default: 0x000000)</li>
		 *		<li><strong>strength</strong>:<em>Number</em> - The strength of the imprint or spread. (default: 1)</li>
		 *		<li><strong>inner</strong>:<em>Boolean</em> - Specifies whether the shadow is an inner shadow. (default: false)</li>
		 *		<li><strong>knockout</strong>:<em>Boolean</em> - Specifies whether the object has a knockout effect. (default: false)</li>
		 *		<li><strong>quality</strong>:<em>Number</em> - The number of times to apply the filter. 1 - Low, 2 - Medium, 3 - High. (default: 3)</li>
		 *		<li><strong>knockout</strong>:<em>Boolean</em> - Make element invisible but keep filter. (default: false)</li>
		 *	</ul>
		 **/
		public function shadow(prop:Object=null):Component {
			var obj:Object	= {};
			
			//Set defaults
			obj.distance	= 0;
			obj.angle		= 45;
			obj.alpha		= 1;
			obj.blurX		= 15;
			obj.blurY		= 15;
			obj.color		= 0x000000;
			obj.strength	= 1;
			obj.quality		= 3;
			obj.inner		= false;
			obj.knockout	= false;
			
			if(!prop) {
				prop	= {};
			}
			
			//Set custom properties
			for(var s:String in prop) {
				obj[s]	= prop[s];
			}
			
			//If shadow already exists, remove it
			if(data.shadow) {
				removeFilter(data.shadow, false);
				data.shadow	= null;
			}
			
			//Add shadow is blur is more than 0
			if(obj.blurX != 0 || obj.blurY != 0) {
				data.shadow	= new DropShadowFilter(obj.distance, obj.angle, obj.color, obj.alpha, obj.blurX, obj.blurY, obj.strength, obj.quality, obj.inner, obj.knockout, obj.hideObject);
				addFilter(data.shadow);
			}
			
			return this;
		}
		
		/**
		 *	Creates a stroke around an element.
		 *	@param size (optional) Size of the stroke. (default: 1).
		 *	@param color (optional) Color of the stroke. (default: 0x000000).
		 **/
		public function stroke(size:Number=2, color:uint=0x000000):Component {
			//If stroke already exists, remove it
			if(data.stroke) {
				removeFilter(data.stroke, false);
				data.stroke	= null;
			}
			
			//Add stroke size is more than 0
			if(size != 0) {
				data.stroke	= new GlowFilter(color, 1, size, size, 1000, 1, false, false);
				addFilter(data.stroke);
			}
			
			return this;
		}
		
		/**
		 *	Creates a glow around the element when the mouse is over and removes it when mouse moves out.
		 *	@param size (optional) Size of the glow. (default: 10).
		 *	@param color (optional) Color of the glow. (default: 0xffffff).
		 **/
		public function hoverGlow(size:Number=10, color:uint=0xffffff):void {
			data.hoverGlowColor	= color;
			data.hoverGlowSize	= size;
			/*
			if(size > 0) {
				data.hoverGlowSize	= size;
				data.hoverGlow		= new GlowFilter(color, 0, size, size);
				addFilter(data.hoverGlow);
				hover(onGlowOn, onGlowOff);
			} else {
				unbind(ElementEvent.MOUSEOVER, onGlowOn);
				unbind(ElementEvent.MOUSEOUT, onGlowOff);
				removeFilter(data.hoverGlow);
			}
			*/
		}
		
		/** @private **/
		private function onGlowOn(e:ElementEvent):void {
			//var glow:GlowFilter	= data.hoverGlow as GlowFilter;
			//new Tween({target:glow, duration:.25, alpha:1, blurX:data.hoverGlowSize, blurY:data.hoverGlowSize});
			TweenMax.to(this, .25, {glowFilter:{color:data.hoverGlowColor, alpha:1, blurX:data.hoverGlowSize, blurY:data.hoverGlowSize}});
		}
		
		/** @private **/
		private function onGlowOff(e:ElementEvent):void {
			//var glow:GlowFilter	= data.hoverGlow as GlowFilter;
			//new Tween({target:glow, duration:.25, alpha:0, blurX:0, blurY:0});
			TweenMax.to(this, .25, {glowFilter:{color:data.hoverGlowColor, alpha:0, blurX:0, blurY:0}});
		}
		
		
		public function removeFilter(filter:BaseFilter, update:Boolean=true):Array {
			var filterList:Array	= filters;
			var filterIdx:int		= filterList.indexOf(filter);
			
			if(filterIdx >= 0) {
				filterList.splice(filterIdx, 1);
			}
			
			if(update) {
				filters	= filterList;
			}
			
			return filterList;
		}
		
		public function addFilter(filter:BaseFilter, update:Boolean=true):Array {
			if(!filter) {
				return filters;
			}
			
			var filterList:Array	= filters;
			filterList.push(filter);
			
			if(update) {
				filters	= filterList;
			}
			
			return filterList;
		}
		
		/** Get the bounds of the element **/
		public function elementBounds():Rectangle {
			var bounds:Rectangle	= new Rectangle(0, 0, width, height);
			return bounds;
		}
		
		/** Fade element to specific alpha value.
		 *	@param opacity (optional) Opacity of element. (default: 1)
		 *	@param duration (optional) The duration of the animation. if set to 0, the element visibility is promptly set to true and alpha to 1. (default: 0)
		 *	@param callback (optional) Function to call on completion.
		 *	@param params (optional) Parameters to send with function on complete.
		 */
		public function fadeTo(opacity:Number=1, duration:Number=0, callback:Function=null, params:Array=null):Component {
			animate({duration:duration, alpha:opacity, ease:Quint.easeOut, onComplete:callback, onCompleteParams:params});
			return this;
		}
		
		/** Flip the element horizontally **/
		public function flipX():void {
			scaleX = -1;
		}
		
		/** Flip the element vertically **/
		public function flipY():void {
			scaleY = -1;
		}
		
		/** Kill the object and clean from memory. **/
		public function kill():void {
			//Remove Listeners
			clearEvents();
			
			//Remove Children
			var childLen:int	= children.length;
			
			for(var h:int=childLen; h>0; h--) {
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
			_listeners	= null;
			//contentEditable	= null;
		}
	}
}
