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

package lg.flex.components {
	//Flash
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import lg.flex.elements.Component;
	import lg.flex.elements.VisualElement;
	
	public class Preloader extends Component {
		public var isPlaying:Boolean;
		public var color:uint				= 0x808080;
		public var speed:Number				= 1000;
		public var leafSize:Number			= 4;
		public var leafCount:Number			= 12;
		public var leafRadius:Number		= 10;
		
		protected var _throbber:VisualElement	= new VisualElement();
		
		private var _trailCount:Number		= 5;
		private var _startLeaf:Number		= 9;
		private var _padding:Number			= 10;
		private var _leafNodeItr:Number		= 1;
		private var _updateTimer:Timer;
		
		public function Preloader() {
			super();
			ghost();
		}
		
		protected override function createChildren():void {
			addChild(_throbber);
			
			for (var i:int=0; i<leafCount; i++) {
				var leaf:VisualElement	= new VisualElement({name:'leaf' + i, alpha:.25});
				var leafX:Number		= Math.cos((i * (360 / leafCount)) * (Math.PI / 180)) * leafRadius;
				var leafY:Number		= Math.sin((i * (360 / leafCount)) * (Math.PI / 180)) * leafRadius;
				leaf.graphics.lineStyle(leafSize, color, 100);
				leaf.graphics.moveTo(leafX, leafY);
				leaf.graphics.lineTo(leafX*1.5, leafY*1.5);
				
				_throbber.addChild(leaf);
			}
			
			var throbRad:int	= _throbber.width * .5;
			_throbber.setPos(throbRad, throbRad);
			
			//Update Timer
			_updateTimer = new Timer(Math.round(speed / leafCount), 0);
			_updateTimer.addEventListener('timer', onCycleThrob, false, 0, true);
			
			isSetup	= true;
		}
		
		private function onCycleThrob(e:TimerEvent):void {
			if (_leafNodeItr >= leafCount) {
				_leafNodeItr	= 0;
			}
			
			var preLo:Number	= (_trailCount > _leafNodeItr) ? 0 : (_leafNodeItr - _trailCount);
			var preHi:Number	= _leafNodeItr;
			var apreLo:Number	= (_trailCount > _leafNodeItr) ? (leafCount - (_trailCount - _leafNodeItr)) : leafCount;
			var apreHi:Number	= leafCount;
			
			for (var i:int=0; i<leafCount; i++) {
				if (i == _leafNodeItr) {
					_throbber.elements['leaf' + i].alpha = 1;
				} else if ( i > preLo && i <= preHi ) {
					_throbber.elements['leaf' + i].alpha = (25 + (Math.round(75 / _trailCount) * (i - preLo - (apreLo - leafCount)))) / 100;
				} else if ( i > apreLo && i <= apreHi ) {
					_throbber.elements['leaf' + i].alpha = (25 + (Math.round(75 / _trailCount) * (i - (leafCount - (preLo - (apreLo - leafCount)))))) / 100;
				} else {
					_throbber.elements['leaf' + i].alpha = .25;
				}
			}
			
			_leafNodeItr++;
		}
		
		public function start():void {
			if(isPlaying) {
				return;
			}
			
			isPlaying	= true;
			_updateTimer.start();
			fadeTo(1, .3);
		}
		
		public function stop():void {
			if(!isPlaying) {
				return;
			}
			
			isPlaying	= false;
			_updateTimer.stop();
			fadeTo(0, .3);
		}
		
		public function setPercent(value:Number):void {
		}
		
		public function setDetails(value:String):void {
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			_throbber.x	= unscaledWidth * .5;
			_throbber.y	= unscaledHeight * .5;
		}
		
		public override function kill():void {
			_updateTimer.stop();
			_updateTimer.removeEventListener('timer', onCycleThrob);
			_updateTimer	= null;
			
			var g:int		= _throbber.numChildren - 1;
			var leaf:VisualElement;
			
			while(g--) {
				leaf	= _throbber.getChildAt(g) as VisualElement;
				_throbber.removeChildAt(g);
				leaf.kill();
			}
			
			_throbber.kill();
			_throbber	= null;
			
			super.kill();
		}
	}
}