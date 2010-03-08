/**
 * ElementDispatcher Class by Giraldo Rosales.
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

package lg.flash.events {
	//Flash
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	
	public class ElementDispatcher extends EventDispatcher {
		/** Allows you to associate arbitrary data with the element. **/
		public var data:Object					= {};
		/** Indicates whether element will bubble events. **/
		public var bubble:Boolean				= false;
		public var doubleClickEnabled:Boolean	= false;
		
		/** @private **/
		private var _listeners:Vector.<Object>	= new Vector.<Object>();
		
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
		
		public function ElementDispatcher() {
		}
		
		/** Shortcut for a weak reference addEventListener call. Binds the type 
		 *	of event with the function. Also adds the listener to the event 
		 *	manager. If the double click event is used, it will automatically
		 *	set the doubleClickEnabled property to true.
		 *
		 *	@param type The type of event to bind. 
		 *	@param fn The function to call once the event is triggered. **/
		public function bind(type:String, fn:Function):EventDispatcher {
			addEventListener(type, fn);
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
		public function trigger(type:String, args:Object=null, event:Object=null):ElementDispatcher {
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
		public function unbind(type:String, fn:Function=null):EventDispatcher {
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
		
		public override function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			//Add listener
			super.addEventListener(type, listener, false, 0, true);
			
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
			trigger('element_error', null, e);
			trace('IO Error: '+e.text);
		}
		/** @private **/
		protected function onProgress(e:ProgressEvent):void {
			trigger('element_progress', null, e);
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
	}
}