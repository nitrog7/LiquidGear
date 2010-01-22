/**
* Scheduler Class by Nick Farina and Philippe Elass.
* Visit www.liquidgear.net for documentation and updates.
*
*
* Copyright (c) 2008 Nick Farina and Philippe Elass. All rights reserved.
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

package lg.flash.layout {
	//Flash
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import lg.flash.elements.Container;
	import lg.flash.events.ElementDispatcher;
	
	/**
	 * Support class for Container, manages layout and rendering of one or more trees of Container.
	 * Could probably be optimized later.
	 */
	public class Scheduler extends ElementDispatcher {
		private var layoutQueue:Array	= [];
		private var renderQueue:Array	= [];
		private var _timer:Timer		= new Timer(1, 1);
		
		public function Scheduler(stage:Stage) {
			_timer.addEventListener(TimerEvent.TIMER, onRender);
		}
		
		private function onRender(e:TimerEvent=null):void {
			var container:Container;
			
			do {
				while (container = layoutQueue.shift()) {
					var parentContainer:Container	= container.parent as Container;
					if (parentContainer && parentContainer.childAffectsLayout(container) && parentContainer.layoutInvalidated) {
						continue;
					}
					
					while (container.layoutInvalidated) {
						container.performLayout();
					}
				}
				
				while (container = renderQueue.shift()) {
					container.performRender();
				}
			}
			
			while (layoutQueue.length > 0); // render pass might have added to layout queue
		}
		
		public function addedToStage(container:Container):void {
			if (container.data.renderInvalidated) {
				requestRender(container);
			}
			
			// we only care if this is the top container in its layout tree
			if (container.layoutInvalidated) {
				var parentContainer:Container	= container.parent as Container;
				
				if (parentContainer && parentContainer.childAffectsLayout(container)) {
					return;
				}
				
				while (container.layoutInvalidated) {
					container.performLayout();
				}
				
				while (container = renderQueue.pop()) {
					container.performRender();
				}
			}
		}
		
		public function requestLayout(container:Container):void {
			var parentContainer:Container	= container.parent as Container;
			
			// if we have a parent, notify them instead.
			if (parentContainer && parentContainer.childAffectsLayout(container)) {
				parentContainer.invalidateLayout();
			} else {
				layoutQueue.push(container);
				
				if(!_timer.running) {
					_timer.start();
				}
			}
		}
		
		public function requestRender(container:Container):void {
			renderQueue.push(container);
			
			if (!_timer.running) {
				_timer.start();
			}
		}
		
		public function layoutNow():void {
			// just lay out everything waiting to be layed out
			onRender();
		}
	}
}
