/**
* TileClip Class by Giraldo Rosales.
* Visit www.liquidgear.net for documentation and updates.
*
*
* Copyright (c) 2010 Nitrogen Design, Inc. All rights reserved.
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
	//Flash Classes
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.BitmapData;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	//LG Classes
	import lg.flash.elements.Element;
	import lg.flash.elements.Image;
	import lg.flash.events.ElementEvent;
	
	public class TileClip extends Element {
		private var _background:Sprite	= new Sprite();
		private var _pixelData:BitmapData;
		private var _image:Image;
		
		public function TileClip() {
			super();
		}
		
		public function addImage(src:String):void {
			_image	= new Image({basePath:basePath, src:src});
			_image.loaded(onLoadedTile);
			_image.error(onError);
			
			addChild(_background);
			addChild(_image);
			//_loader.load(req);
		}
		
		/** @private **/
		private function onLoadedTile(e:Event):void {
			//If loaded item is a swf
			if(_image != null) {
				setSize(_image.width, _image.height);
			}
			
			_background.cacheAsBitmap = true;
			
			_pixelData = _image.image.bitmapData;
			_pixelData.draw(_background);
			redraw(_image.width, _image.height)
			trigger(ElementEvent.LOADED);
		}
		
		/** @private **/
		private function redraw(w:int, h:int):void {
			_background.graphics.clear();
			_background.graphics.beginBitmapFill(_pixelData);
			_background.graphics.drawRect(0, 0, w, h);
			_background.graphics.endFill();
			//_background.width	= w;
			//_background.height	= h;
		}
		
		public function setSize(width:Number, height:Number):void {
			//this.width	= width;
			//this.height	= height;
			
			if(_pixelData) {
				redraw(width, height);
			}
		}
		
		public function setPos(x:Number, y:Number):void {
			this.x	= x;
			this.y	= y;
		}
		
		/** @private **/
		private function onError(e:IOErrorEvent):void {
			trigger(ElementEvent.ERROR, e);
			trace('IO Error: '+e.text);
		}
	}
}