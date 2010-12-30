/**
* Preloader Class by Giraldo Rosales.
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
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	//LG
	import lg.flash.elements.VisualElement;
	
	public class Preloader extends VisualElement {
		public var throbber:VisualElement	= new VisualElement();
		
		private var _trailCount:Number		= 5;
		private var _startLeaf:Number		= 9;
		private var _padding:Number			= 10;
		private var _leafNodeItr:Number		= 1;
		private var _updateTimer:Timer;
		
		public function Preloader(obj:Object=null) {
			super();
			ghost();
			
			data.color		= 0x808080;
			data.speed		= 1000;
			data.leafSize	= 4;
			data.leafCount	= 12;
			data.leafRadius	= 10;
			
			//Set Attributes
			setAttributes(obj);
			
			setup()
		}
		
		protected function setup():void {
			addChild(throbber);
			
			for (var i:int=0; i<data.leafCount; i++) {
				var leaf:VisualElement	= new VisualElement({id:'leaf' + i, alpha:.25});
				var leafX:Number		= Math.cos((i * (360 / data.leafCount)) * (Math.PI / 180)) * data.leafRadius;
				var leafY:Number		= Math.sin((i * (360 / data.leafCount)) * (Math.PI / 180)) * data.leafRadius;
				leaf.graphics.lineStyle(data.leafSize, data.color, 100);
				leaf.graphics.moveTo(leafX, leafY);
				leaf.graphics.lineTo(leafX*1.5, leafY*1.5);
				
				throbber.addChild(leaf);
			}
			
			var throbRad:int	= throbber.width * .5;
			throbber.setPos(throbRad, throbRad);
			
			//Update Timer
			_updateTimer = new Timer(Math.round(data.speed / data.leafCount), 0);
			_updateTimer.addEventListener('timer', onCycleThrob, false, 0, true);
			
			isSetup	= true;
		}
		
		private function onCycleThrob(e:TimerEvent):void {
			if (_leafNodeItr >= data.leafCount) {
				_leafNodeItr	= 0;
			}
			
			var preLo:Number	= (_trailCount > _leafNodeItr) ? 0 : (_leafNodeItr - _trailCount);
			var preHi:Number	= _leafNodeItr;
			var apreLo:Number	= (_trailCount > _leafNodeItr) ? (data.leafCount - (_trailCount - _leafNodeItr)) : data.leafCount;
			var apreHi:Number	= data.leafCount;
			
			for (var i:int=0; i<data.leafCount; i++) {
				if (i == _leafNodeItr) {
					throbber.elements['leaf' + i].alpha = 1;
				} else if ( i > preLo && i <= preHi ) {
					throbber.elements['leaf' + i].alpha = (25 + (Math.round(75 / _trailCount) * (i - preLo - (apreLo - data.leafCount)))) / 100;
				} else if ( i > apreLo && i <= apreHi ) {
					throbber.elements['leaf' + i].alpha = (25 + (Math.round(75 / _trailCount) * (i - (data.leafCount - (preLo - (apreLo - data.leafCount)))))) / 100;
				} else {
					throbber.elements['leaf' + i].alpha = .25;
				}
			}
			
			_leafNodeItr++;
		}
		
		public function start():void {
			visible	= true;
			_updateTimer.start();
		}
		
		public function stop():void {
			_updateTimer.stop();
			visible	= false;
		}
		
		public function setPercent(value:Number):void {
		}
		
		public function setDetails(value:String):void {
		}
		
		public override function kill():void {
			_updateTimer.stop();
			_updateTimer.removeEventListener('timer', onCycleThrob);
			_updateTimer	= null;
			
			var g:int		= throbber.numChildren - 1;
			var leaf:VisualElement;
			
			while(g--) {
				leaf	= throbber.getChildAt(g) as VisualElement;
				throbber.removeChildAt(g);
				leaf.kill();
			}
			
			throbber.kill();
			throbber	= null;
			
			super.kill();
		}
	}
}