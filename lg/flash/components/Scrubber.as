/**
* Scrubber Class by Giraldo Rosales.
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
 
package lg.flash.components {
	//Flash
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	//LG
	import lg.flash.elements.VisualElement;
	import lg.flash.elements.Shape;
	import lg.flash.events.ElementEvent;
	
	public class Scrubber extends VisualElement {
		public var scrubber:VisualElement;
		public var value:Number;
		public var isDown:Boolean	= false;
		
		private var _barMask:Shape;
		
		public function Scrubber(obj:Object) {
			super();
			button();
			
			if(!obj.scrubber) {
				return;
			}
			
			//Set Attributes
			graphics.clear();
			graphics.beginFill(0x000000, 0);
			graphics.drawRect(0, 0, obj.scrubber.width, obj.scrubber.height);
			graphics.endFill();
			
			for(var s:String in obj) {
				if(s in this) {
					this[s] = obj[s];
				}
				data[s] = obj[s];
			}
			
			scrubber.setPos(data.offsetX, data.offsetY);
			addChild(scrubber);
			
			//Add click control to bar
			mousedown(onDownBtn);
			mouseup(onUpBtn);
			bind('element_add', onAddScrub);
			
			//Update initial progress
			update({x:0, y:0});
		}
		
		private function onAddScrub(e:ElementEvent):void {
			stage.addEventListener('mouseLeave', onUpStage);
			stage.addEventListener('mouseUp', onUpStage);
		}
		
		private function onDownBtn(e:ElementEvent):void {
			isDown	= true;
		}
		
		private function onUpBtn(e:ElementEvent):void {
			isDown	= false;
		}
		
		private function onUpStage(e:Event):void {
			isDown	= false;
		}
		
		public override function update(obj:Object=null):void {
			if(!obj || !scrubber) {
				return;
			}
			
			setPos(obj.x, obj.y); 
		}
	}
}