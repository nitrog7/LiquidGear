package lg.flash.components {

	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;

	//LG Classes
	import lg.flash.elements.Image;
	
	public class Thumb extends Image {
		private var _shadow:DropShadowFilter = new DropShadowFilter(5.0,45, 0x000000,.75,4.0, 4.0, 1.0, 1,  false, false,  false);
		private var _glow:GlowFilter = new GlowFilter(0xffffff, 1, 8, 8, 10, 1, true, false);
		private var _startPos:Object;
		
		public function Thumb(name:String, url:String, w:int=150, h:int=50, sx:int=0, sy:int=0) {
			_startPos = {x:sx, y:sy};
			this.name = name;// - set name
			this.alpha = 0;
			loadImage(name, url);
			this.scaleX = .25;
			this.scaleY = .25;
			this.x = sx;
			this.y = sy;

			image.filters = [_glow];
			filters = [_shadow];
		}
		
		function activateME($e:TweenEvent) {
			this.addEventListener(MouseEvent.MOUSE_OUT, OutHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER, OverHandler);
			this.addEventListener(MouseEvent.MOUSE_UP,  UpHandler);
		}
		function loaded(event:Event):void {
			var targetLoader:Loader = Loader(event.target.loader);
			targetLoader.x = -(targetLoader.width*.5);
			targetLoader.y = -(targetLoader.height*.5);
			super.addChild(targetLoader);
			event.target.content.smoothing = true;
			var tween:Tween	= TweenMax.to(this, .5,{alpha:1, ease:Linear.easeOut, overwrite:2});
			tween.addEventListener(TweenEvent.COMPLETE, activateME);
		}
		// -MOUSE EVENT HANDELERS
		public function UpHandler(event:MouseEvent):void {
			if (!this.parent.ZOOM) {
				this.parent.ZOOMED_MC = event.target.name;

				this.parent.ZOOM = true;

				this.parent.cover_mc.visible = true;

				this.parent.attachImageCloser(475, 40);

				_glow.blurX = 20;
				_glow.blurY = 20;
				image.filters = [_glow];

				this._shadow.distance = 5;
				super.filters = [_shadow];

				TweenMax.to(this, .25,{x:475, y:260, scaleX:1, scaleY:1, rotation:-2, ease:Back.easeOut});
			}
		}

		private function OutHandler(event:MouseEvent):void {
			if (!this.parent.ZOOM) {
				this._shadow.distance = 5;
				super.filters = [_shadow];
				TweenMax.to(this, .5,{scaleX:.25, scaleY:.25, rotation:0, ease:Back.easeOut});
			}
		}

		private function OverHandler(event:MouseEvent):void {
			if (!this.parent.ZOOM) {
				this._shadow.distance = 10;
				super.filters = [_shadow];
				this.parent.setChildIndex(this,this.parent.numChildren - 1);
				TweenMax.to(this, .25,{scaleX:.3, scaleY:.3, rotation:5, ease:Back.easeOut});
			}
		}
		public function closeTN() {
			_glow.blurX =8;
			_glow.blurY = 8;
			image.filters = [_glow];
			this.parent.cover_mc.visible = false;
			this.parent.ZOOM = false;
			TweenMax.to(this, .25,{x:this._startPos.x, y:this._startPos.y, scaleX:.25, scaleY:.25, rotation:0, ease:Back.easeOut});
		}
	}
}