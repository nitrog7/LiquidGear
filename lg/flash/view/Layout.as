/**
* Layout Class by Giraldo Rosales.
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

package lg.flash.view {
	//Flash
	import flash.display.DisplayObject;
	
	//LG
	import lg.flash.elements.VisualElement;
	
	/** Distributes VisualElements to a vertical or horzontal grid of columns and rows.	**/
	public class Layout extends VisualElement {
		/** 
		*	Constructs a new Layout object
		*	@param obj Object containing all properties to construct the Layout class	
		**/
		public function Layout(obj:Object) {
			super();
			
			//Set Defaults
			data.top			= null;
			data.bottom			= null;
			data.left			= null;
			data.right			= null;
			data.width			= 0;
			data.height			= 0;
			data.margin			= NaN;
			data.marginTop		= 0;
			data.marginBottom	= 0;
			data.marginLeft		= 0;
			data.marginRight	= 0;
			data.childPadding	= NaN;
			data.vertical		= false;
			data.snap			= true;
			
			//Set Attributes
			setAttributes(obj);
			
			isSetup = true;
		}
		
		/** Sets the top, bottom, left, and right margin of the layout box.
		*	@default 0 **/
		public function set margin(value:Number):void {
			data.margin			= value;
			
			data.marginTop		= value;
			data.marginBottom	= value;
			data.marginLeft		= value;
			data.marginRight	= value;
			
			updateChildren();
		}
		public function get margin():Number {
			return data.margin;
		}
		
		/** Set each individual margins surrounding the outside of the box.
			
			@param top: Sets the top margin.
			@param right: Sets the right margin.
			@param bottom: Sets the bottom margin.
			@param left: Sets the left margin.
		*/
		public function setMargin(top:Number=0, right:Number=0, bottom:Number=0, left:Number=0):void {
			data.marginTop		= top;
			data.marginBottom	= bottom;
			data.marginLeft		= left;
			data.marginRight	= right;
			
			updateChildren();
		}
		
		/** Top spacing of the children.
		*	@default 0 **/
		public function set marginTop(value:Number):void {
			if((data.marginBottom + value) > data.height) {
				trace(id + ': Margin is larger than width. Please decrease margins');
				return;
			}
			
			data.marginTop = value;
			updateChildren();
		}
		public function get marginTop():Number {
			return data.marginTop;
		}
		
		/** Bottom spacing of the children.
		*	@default 0 **/
		public function set marginBottom(value:Number):void {
			if((data.marginTop + value) > data.height) {
				trace(id + ': Margin is larger than height. Please decrease margins');
				return;
			}
			
			data.marginBottom = value;
			updateChildren();
		}
		public function get marginBottom():Number {
			return data.marginBottom;
		}
		
		/** Left spacing of the children.
		*	@default 0 **/
		public function set marginLeft(value:Number):void {
			if((data.marginRight + value) > data.width) {
				trace(id + ': Margin is larger than width. Please decrease margins');
				return;
			}
			
			data.marginLeft = value;
			updateChildren();
		}
		public function get marginLeft():Number {
			return data.marginLeft;
		}
		
		/** Right spacing of the children.
		*	@default 0 **/
		public function set marginRight(value:Number):void {
			if((data.marginLeft + value) > data.width) {
				trace(id + ': Margin is larger than height. Please decrease margins');
				return;
			}
			
			data.marginRight = value;
			updateChildren();
		}
		
		public function get marginRight():Number {
			return data.marginRight;
		}
		
		/** Position children left-to-right top-to-bottom <code>false</code>, or to position children top-to-bottom left-to-right <code>true</code>.
		*	@default false **/
		public function set vertical(isVertical:Boolean):void {
			data.vertical	= isVertical;
			updateChildren();
		}
		public function get vertical():Boolean {
			return data.vertical;
		}
		
		/** Snap items to the nearest pixel.
		*	@default true **/
		public function set snap(value:Boolean):void {
			data.snap	= value;
			updateChildren();
		}
		public function get snap():Boolean {
			return data.snap;
		}
		
		/** Set the child margins of all children. Will overwrite the child's margin, is set.
		*	@default NaN **/
		public function set childPadding(value:Number):void {
			data.childPadding	= value;
			updateChildren();
		}
		public function get childPadding():Number {
			return data.childPadding;
		}
		
		/** Top position of the layout container.
		*	@default null **/
		public override function set top(value:*):void {
			super.top	= value;
			
			if(data.bottom != null) {
				updateChildren();
			}
		}
		
		/** Bottom position of the layout container.
		*	@default null **/
		public override function set bottom(value:*):void {
			super.bottom	= value;
			
			if(data.top != null) {
				updateChildren();
			}
		}
		
		/** Left position of the layout container.
		*	@default null **/
		public override function set left(value:*):void {
			super.left	= value;
			updateChildren();
		}
		
		/** Right position of the layout container.
		*	@default null **/
		public override function set right(value:*):void {
			super.right	= value;
			updateChildren();
		}
		
		/** Add a child element to the Layout **/
		public override function addChild(child:DisplayObject):DisplayObject {
			super.addChild(child);
			updateChildren();
			
			return child;
		}
		
		/** Indicates the width of the display object, in pixels. **/
		public override function get width():Number {
			var padVal:Number	= data.paddingLeft + data.paddingRight;
			var w:Number		= data.width + padVal;
			
			return w;
		}
		
		/** Indicates the height of the display object, in pixels. **/
		public override function get height():Number {
			var padVal:Number	= data.paddingTop + data.paddingBottom;
			var h:Number		= data.height + padVal;
			
			return h;
		}
		
		/** Arranges the children of the Layout. **/
		public function updateChildren():void {
			if(!isSetup) {
				return;
			}
			
			var item:VisualElement;
			
			var largest:Number		= 0;
			var xPos:Number			= marginLeft;
			var yPos:Number			= marginTop;
			var curWidth:Number		= 0;
			var curHeight:Number	= 0;
			var itemWidth:Number	= 0;
			var itemHeight:Number	= 0;
			var itemTop:Number		= 0;
			var itemLeft:Number		= 0;
			
			//Position items
			for(var g:int=0; g<numChildren; g++) {
				item		= getChildAt(g) as VisualElement;
				if(!isNaN(data.childPadding)) {
					itemTop		= data.childPadding;
					itemLeft	= data.childPadding;
					itemWidth	= item.width + (itemLeft * 2);
					itemHeight	= item.height + (itemTop * 2);
				} else {
					itemTop		= item.paddingTop;
					itemLeft	= item.paddingLeft;
					itemWidth	= item.paddingLeft + item.width + item.paddingRight;
					itemHeight	= item.paddingTop + item.height + item.paddingBottom;
				}
				
				if(vertical) {
					//Make sure item does not exceed the total height
					if((curHeight+itemHeight) > data.height) {
						xPos		+= largest;
						yPos		= marginTop;
						largest		= 0;
						curHeight	= 0;
					}
					
					//Get the longest item
					if(itemWidth > largest) {
						largest	= itemWidth;
					}
					
					curHeight	+= itemHeight;
					
					item.x	= data.snap ? Math.round(xPos) : xPos;
					item.y	= data.snap ? Math.round(yPos) : yPos;
					
					//Set X coordinate
					yPos	+= itemHeight;
				} else {
					//Make sure item does not exceed the total width
					if((curWidth+itemWidth) > data.width) {
						xPos		= marginLeft;
						yPos		+= largest;
						largest		= 0;
						curWidth	= 0;
					}
					
					//Get the longest item
					if(itemHeight > largest) {
						largest	= itemHeight;
					}
					
					curWidth	+= itemWidth;
					
					item.x	= data.snap ? Math.round(xPos + itemLeft) : xPos + itemLeft;
					item.y	= data.snap ? Math.round(yPos + itemTop) : yPos + itemTop;
					
					//Set X coordinate
					xPos	+= itemWidth;
				}
			}
			
			graphics.clear();
			graphics.beginFill(0x000000, .15);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
		
		/** Update the elements properties. Also called when the stage has been resized. **/
		public override function update(obj:Object=null):void {
			super.update();
			updateChildren();
		}
	}
}