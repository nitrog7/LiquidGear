package lg.flash.view{
	//Flash Classes
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	//LG Classes
	import lg.flash.events.*;
	import lg.flash.components.*;
	import lg.flash.events.*;
	import lg.flash.motion.*;
	
	public class ParallelPage extends Page {
		public var layers:Array = [];
		
		private var _layerX:int	= 0;
		private var _leftHit1:ShapeClip;
		private var _rightHit1:ShapeClip;
		private var _leftHit2:ShapeClip;
		private var _rightHit2:ShapeClip;
		private var _moveSpeed:int = 18;
		
		public function ParallelPage() {
			super();
		}
		
		protected function setLayers(offset:int=0):void {
			var hitLeft1:int, hitRight1:int, hitWidth1:int=stage.stageWidth/4, hitLeft2:int, hitRight2:int, hitWidth2:int=hitWidth1*.5;
			
			//Scroller that stops on mouse items
			_leftHit1	= new ShapeClip(hitWidth1, stage.stageHeight, 0xFFFFFF, 0);
			_leftHit1.mouseChildren	= true;
			_leftHit1.setPos(offset, 0);
			_leftHit1.addEventListener(MouseEvent.MOUSE_OVER, onOverLeft);
			_leftHit1.addEventListener(MouseEvent.MOUSE_OUT, onHitOut);
			addItem(_leftHit1);
			_leftHit1.toBack();
			
			_rightHit1	= new ShapeClip(hitWidth1, stage.stageHeight, 0xFFFFFF, 0);
			_rightHit1.mouseChildren	= true;
			_rightHit1.setPos(offset+(hitWidth1*3), 0);
			_rightHit1.addEventListener(MouseEvent.MOUSE_OVER, onOverRight);
			_rightHit1.addEventListener(MouseEvent.MOUSE_OUT, onHitOut);
			addItem(_rightHit1);
			_rightHit1.toBack();
			
			//Scroller that ignores mouse items
			_leftHit2	= new ShapeClip(hitWidth2, stage.stageHeight, 0x99FFFF, 0);
			_leftHit2.mouseChildren	= true;
			_leftHit2.setPos(offset, 0);
			_leftHit2.addEventListener(MouseEvent.MOUSE_OVER, onOverLeft);
			_leftHit2.addEventListener(MouseEvent.MOUSE_OUT, onHitOut);
			addItem(_leftHit2);
			_leftHit2.toFront();
			
			_rightHit2	= new ShapeClip(hitWidth2, stage.stageHeight, 0x99FFFF, 0);
			_rightHit2.mouseChildren	= true;
			_rightHit2.setPos(_rightHit1.x+(_rightHit1.width*.5), 0);
			_rightHit2.addEventListener(MouseEvent.MOUSE_OVER, onOverRight);
			_rightHit2.addEventListener(MouseEvent.MOUSE_OUT, onHitOut);
			addItem(_rightHit2);
			_rightHit2.toFront();
		}
		
		private function onOverLeft(e:MouseEvent):void {
			sceneLeft(e.target.mouseX+1);
		}
		private function onOverRight(e:MouseEvent):void {
			sceneRight((e.target.width - e.target.mouseX) + 1);
		}
		private function onHitOut(e:MouseEvent):void {
			Tween.killAll();
		}
		
		private function sceneLeft(speed:int):void {
			var scrollSpeed:int = 1+((1+speed)/(stage.stageWidth/3));
			
			for(var g:int=0; g<layers.length; g++) {
//				Tween.to(layers[g], _moveSpeed+(g*scrollSpeed), {x:0, overwrite:true, onUpdate:onScrollLeft});
//				Tween.to(layers[g], _moveSpeed+(1/(1+g)), {x:0, overwrite:true, onUpdate:onScrollLeft});
				if(layers[0].x != 0)
					Tween.to(layers[g], _moveSpeed+(g*.75), {x:0, overwrite:2, onUpdate:onScrollLeft});
			}
		}
		private function sceneRight(speed:int):void {
//			var scrollSpeed:int = 1+(speed/(stage.stageWidth/3));
			var scrollSpeed:int = _moveSpeed * (speed/(stage.stageWidth)), g:int=0;
			
			trace('scrollSpeed: '+scrollSpeed);
			trace('speed: '+speed);
			trace('stage.width: '+stage.width);
			
			for(g=0; g<layers.length; g++) {
//				Tween.to(layers[g], _moveSpeed+(g*scrollSpeed), {x:stage.stageWidth-layers[g].width, overwrite:true, onUpdate:onScrollRight});
//				Tween.to(layers[g], _moveSpeed+(1/(1+g)), {x:stage.stageWidth-layers[g].width, overwrite:true, onUpdate:onScrollRight});
				if(layers[0].x != stage.stageWidth-layers[g].width)
					Tween.to(layers[g], _moveSpeed+(g*.75), {x:stage.stageWidth-layers[g].width, overwrite:2, onUpdate:onScrollRight});
			}
		}
		
		private function onScrollLeft():void {
			var event:ElementEvent = new ElementEvent('SCROLL_LEFT');
			dispatchEvent(event);
		}
		private function onScrollRight():void {
			var event:ElementEvent = new ElementEvent('SCROLL_RIGHT');
			dispatchEvent(event);
		}
		
		public function addLayer(mc:Page):void {
		//	layers[layers.length]	= mc;
		//	mc.x = -(stage.width/4);
		}
	}
}