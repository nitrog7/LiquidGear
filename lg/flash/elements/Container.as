/**
* Container Class by Nick Farina and Philippe Elass.
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
 
package lg.flash.elements {
	//Flash
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	//LG
	import lg.flash.events.ElementEvent;
	import lg.flash.layout.AutoSize;
	import lg.flash.layout.AutoSize;
	import lg.flash.layout.Size;
	import lg.flash.layout.Thickness;
	import lg.flash.layout.Scheduler;
	import lg.flash.layout.ContainerAttributes;
	import lg.flash.layout.Attributes;
	import lg.flash.graphics.Renderer;
	
	public class Container extends VisualElement {
		/** @private **/
		//private static const scheduler:Scheduler = new Scheduler();
		private var scheduler:Scheduler;
		
		/** Constructs a new VisualElement object **/
		public function Container(obj:Object=null) {
			super();
			
			bind('element_add', onAddToStage);
		
			//Layout
			data.manualSize			= false;
			data.autoSize			= new AutoSize();
			data.layoutInvalidated	= false;
			data.renderInvalidated	= true;
			data.lastAuto			= new AutoSize(false, false);
			data.padding			= new Thickness();
			data.addChildIndex		= NaN;
			data.addChildProxy		= null;
			data.background			= null;
			data.resources			= null;
			
			if(obj) {
				setAttributes(obj);
				isSetup	= true;
			}
		}
		
		/** @private **/
		protected function onAddToStage(e:ElementEvent):void {
			scheduler	= new Scheduler(stage);
			scheduler.addedToStage(this);
		}
		
		public static function attributes(child:DisplayObject):ContainerAttributes {
			return Attributes.findOrCreate(child, ContainerAttributes);
		}
		
		/** Indicates the width of the display object, in pixels. **/
		public override function get width():Number {
			if(data.width != undefined && data.width > 0) {
				return data.width;
			} else {
				return super.width;
			}
		}
		
		public override function set width(value:Number):void {
			autoSize.width	= false;
			
			if(value != data.width) {
				data.width		= value;
				data.manualSize	= true;
				invalidateLayout();
			}
		}
		
		/** Indicates the height of the display object, in pixels. **/
		public override function get height():Number {
			if(data.height != undefined && data.height > 0) {
				return data.height;
			} else {
				return super.height;
			}
		}
		
		public override function set height(value:Number):void {
			autoSize.height	= false;
			
			if(value != data.height) {
				data.height		= value;
				data.manualSize	= true;
				invalidateLayout();
			}
		}
		
		/**
		 * The AutoSize behavior of this Container. Setting one or both dimensions to true will
		 * allow this Container to size itself to fit its content in that direction.
		 */
		public function get autoSize():AutoSize {
			return data.autoSize;
		}
		public function set autoSize(value:AutoSize):void {
			data.autoSize = value;
			invalidateLayout();
		}
		
		/**
		 * The padding of this Container. Our children will sit inside the border specified
		 * by the given Thickness.
		 */
		public function get padding():Thickness {
			return data.padding;
		}
		public function set padding(value:Thickness):void {
			data.padding	= value;
			invalidateLayout();
		}
		
		/** Returns true if layout() needs to be called on this Container. */
		public function get layoutInvalidated():Boolean {
			return data.layoutInvalidated;
		}
		
		/** Returns true if render() needs to be called on this Container. */
		public function get renderInvalidated():Boolean {
			return data.renderInvalidated;
		}
		
		/**
		 * If this is not NaN, it will cause addChild() to internally perform an addChildAt
		 * with this index.
		 */
		public function get addChildIndex():Number {
			return data.addChildIndex;
		}
		public function set addChildIndex(value:Number):void  {
			data.addChildIndex = value;
		}
		
		
		/**
		 * If this is not null, it will cause addChild() to call addChild on this proxy container
		 * instead.
		 */
		public function get addChildProxy():DisplayObjectContainer {
			return data.addChildProxy;
		}
		public function set addChildProxy(value:DisplayObjectContainer):void {
			data.addChildProxy = value;
		}
		
		/** Just a plain object you can throw arbitrary resources into. */
		public function get resources():Object {
			return data.resources;
		}
		public function set resources(value:Object):void {
			data.resources = value;
		}
		
		/** Specifies a Renderer object that will be notified whenever our size changes. */
		public function get background():Renderer {
			return data.background;
		}
		public function set background(value:Renderer):void {
			var renderer:Renderer	= data.background as Renderer;
			
			if(renderer) {
				renderer.removeEventListener(Event.CHANGE, backgroundChanged);
			}
			
			renderer	= value;
			
			if(value) {
				renderer.addEventListener(Event.CHANGE, backgroundChanged);
			}
			
			invalidateRender();
		}
		
		/** Requests that layout() be called as soon as possible. */
		public function invalidateLayout():void {
			//We already know.
			if(data.layoutInvalidated) {
				return;
			}
			
			data.layoutInvalidated	= true;
			
			if(stage) {
				scheduler.requestLayout(this);
			}
		}

		/** Requests that render() be called as soon as possible. */
		public function invalidateRender():void {
			if(data.renderInvalidated) {
				return;
			}
			
			data.renderInvalidated	= true;
			
			if(stage) {
				scheduler.requestRender(this);
			}
		}
		
		//Called by Scheduler
		public function performLayout():void {
			if(debug) {
				var start:int	= getTimer();
				applyLayout(data.width, data.height, data.autoSize);
				trace(this + ' layout finished in ' + (getTimer() - start) + 'ms');
			} else {
				applyLayout(data.width, data.height, data.autoSize);
			}
		}
		
		//Called by Scheduler
		public function performRender():void {
			if(debug) {
				trace(toStringWithNesting() + ' render ' + data.width + ',' + data.height);
			}
			
			render();
			data.renderInvalidated	= false;
		}
		
		/**
		 * Forces a layout immediately, even if this Container is not on a stage.
		 */
		public function layoutNow():void {
			// if we're not on stage, then any existing invalidations haven't been sent to the
			// scheduler - so we'll need to queue ourself so that scheduler.layoutNow() actually works.
			if(!stage) {
				scheduler.requestLayout(this);
			}
			
			scheduler.layoutNow();
		}
		
		/**
		 * Forces a render immediately.
		 */
		public function renderNow():void {
			if (data.renderInvalidated) {
				performRender();
			}
		}
		
		/**
		 * Main layout routine: applies padding, override width/height/auto requests if desired.
		 * This is not intended to be called by the user, please consider layoutNow() instead.
		 */
		public function applyLayout(width:Number, height:Number, auto:AutoSize):void {
			//No layout necessary
			if(!data.layoutInvalidated && !layoutNecessary(width, height, auto, data.lastAuto)) {
				return;
			}
			
			//Debug tracing
			if(debug) {
				trace(toStringWithNesting() + ' layout ' + (auto.width ? 'auto' : width) + ',' + (auto.height ? 'auto' : height));
			}
			
			//Account for padding
			var rect:Rectangle		= new Rectangle(data.paddingLeft, data.paddingTop, width - data.paddingTotalWidth, height - data.paddingTotalHeight);
			
			//Remember old width/height
			var oldWidth:Number		= data.width
			var oldHeight:Number	= data.height;
			
			//Apply overridable layout algorithm
			var size:Size			= new Size(auto.width ? 0 : rect.width, auto.height ? 0 : rect.height);
			size					= layoutChildren(rect, auto, size);
			
			// calculate our new width and height, taking padding into account
			if(data.autoSize.width) {
				data.width	= size.width + data.padding.totalWidth;
			}
			
			if(data.autoSize.height) {
				data.height	= size.height + data.padding.totalHeight;
			}

			data.lastAuto			= auto.clone();
			data.layoutInvalidated	= false;
			
			// see if our width or height changed
			if (data.manualSize || data.width != oldWidth || data.height != oldHeight) {
				layoutSizeChanged();
			}
		}
		
		/**
		 * Decides whether relayout is necessary. The default implementation makes assumptions
		 * (rational to this framework) about what parameters will actually cause a component's size 
		 * to change, so you may want to override this if your container behaves unexpectedly.
		 */
		protected function layoutNecessary(width:Number, height:Number, auto:AutoSize, lastAuto:AutoSize):Boolean {
			var value:Boolean	= (!auto.width && width != this.width) || (auto.width && !lastAuto.width) || (!auto.height && height != this.height) || (auto.height && !lastAuto.height)
			return value;
		}
		
		/**
		 * Override this to decide on your own whether the given child affects our layout.
		 */
		public function childAffectsLayout(child:DisplayObject):Boolean {
			return true;
		}
		
		/**
		 * Override this method to lay out your children in an interesting way, while staying
		 * within the given rectangle and autosize bounds. Default behavior for Container is to
		 * layout all our children on top of each other and return the actual size taken up.
		 */
		protected function layoutChildren(rect:Rectangle, auto:AutoSize, size:Size):Size {
			//Default behavior of Container: pass on our width/height/auto sizes, size ourself to content
			for(var g:int=0; g<numChildren; g++) {
				var child:DisplayObject	= getChildAt(g);
				
				if(!child) {
					continue;
				}
				
				var childSize:Size		= layoutChild(child, rect, auto);
				size.growToFit(childSize);
			}
			
			return size;
		}
		
		/**
		 * Use this to layout a single child in the given rectangle/autosize bounds, while honoring
		 * the child's Attributes, and return the actual size taken up.
		 */
		protected function layoutChild(child:DisplayObject, rect:Rectangle, auto:AutoSize):Size {
			var atts:ContainerAttributes	= Container.attributes(child);
			
			if(atts.collapsed) {
				return new Size(0, 0);
			}
			
			var m:Thickness	= atts.margin;
			
			//If it's an ILayout, allow it to lay itself out
			var childWithLayout:Container	= child as Container;
			
			if (childWithLayout) {
				// allow the child's "manually set" width/height to override our desires
				var childAuto:AutoSize	= childWithLayout.autoSize;
				var childWidth:Number	= childAuto.width ? rect.width - m.totalWidth : child.width;
				var childHeight:Number	= childAuto.height ? rect.height - m.totalHeight : child.height;
				
				childWithLayout.applyLayout(childWidth, childHeight, auto.and(childAuto));
			} else {
				if (!auto.width) child.width = rect.width - m.totalWidth;
				if (!auto.height) child.height = rect.height - m.totalHeight;
			}
			
			// use ContainerAttributes to set the actual layout position, which will take offsets
			// into account.
			atts.layoutX	= Math.round(rect.x + m.left);
			atts.layoutY	= Math.round(rect.y + m.top);
			
			return new Size(Math.round(child.width + m.totalWidth), Math.round(child.height + m.totalHeight));
		}
		
		/**
		 * Called when a layout pass caused our width or height to change. Default behavior
		 * is to call invalidateRender() if we have a non-null background.
		 */
		protected function layoutSizeChanged():void {
			update();
			if (data.background && !data.renderInvalidated) {
				invalidateRender();
			}
		}
		
		//Called when our background Renderer's properties have changed and we need to re-render.
		private function backgroundChanged(e:Event):void  {
			invalidateRender();
		}
		

		/**
		 * Called during the render pass if invalidateRender() was called.
		 */
		protected function render():void {
			var renderer:Renderer	= data.background as Renderer;
			
			if (renderer) {
				graphics.clear();
				renderer.render(this, graphics, data.width, data.height);
			}
		}
		
		public override function addChild(child:DisplayObject):DisplayObject {
			if(data.addChildProxy && data.addChildProxy != this) {
				return data.addChildProxy.addChild(child);
			} else {
				invalidateLayout(); // invalidate us first so child doesn't lay itself out
				if (attributes(child).maskParent) {
					this.mask	= child;
				}
				
				return isNaN(data.addChildIndex) || data.addChildIndex > numChildren ? super.addChild(child) : super.addChildAt(child, data.addChildIndex++);
			}
		}
		
		public override function addChildAt(child:DisplayObject, index:int):DisplayObject {
			invalidateLayout(); // invalidate us first so child doesn't lay itself out
			return super.addChildAt(child, index);
		}
		
		public override function swapChildren(child1:DisplayObject, child2:DisplayObject):void  {
			//Invalidate us first so child doesn't lay itself out
			invalidateLayout();
			super.swapChildren(child1, child2);
		}
		
		public override function swapChildrenAt(index1:int, index2:int):void {
			//Invalidate us first so child doesn't lay itself out
			invalidateLayout();
			super.swapChildrenAt(index1, index2);
		}
		
		public function removeAll():void {
			while(numChildren) {
				removeChildAt(0);
			}
		}
		
		public override function removeChild(child:DisplayObject):DisplayObject  {
			invalidateLayout(); // invalidate us first so child doesn't lay itself out
			return super.removeChild(child);
		}
		
		public override function removeChildAt(index:int):DisplayObject {
			invalidateLayout(); // invalidate us first so child doesn't lay itself out
			return super.removeChildAt(index);
		}
		
		// For helpful tracing
		public override function toString():String {
			var value:String	= this['constructor'].toString().replace('[class ', '').replace(']', '') + (name.indexOf('instance') != 0 ? ' "' + name + '"' : '');
			return value;
		}
		
		private function toStringWithNesting():String {
			var p:DisplayObject	= parent;
			var t:String		= '';
			
			//Indicate nested level
			if(p) {
				while(p = p.parent) {
					t += " ";
				}
			}
			
			return t + this.toString();
		}
	}
}