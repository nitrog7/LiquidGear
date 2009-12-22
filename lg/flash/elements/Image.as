/**
* Image Class by Giraldo Rosales.
* Visit www.liquidgear.net for documentation and updates.
*
*
* Copyright (c) 2009 Nitrogen Design, Inc. All rights reserved.
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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.system.LoaderContext;
	import flash.geom.Rectangle;
	import flash.external.ExternalInterface;
	
	import lg.flash.elements.VisualElement;
	import lg.flash.events.ElementEvent;
	
	/**
	*	<p>Loads external images including: GIF, JPG, and PNG. Images are loaded 
	*	into a Bitmap object. All Image objects have the cacheAsbitmap setting
	*	set to true.</p>
	*	<p>An external image file is loaded through a Loader object, as a result,
	*	the bitmap data is saved and the Loader is discarded.</p>
	*/
	public class Image extends VisualElement {
		//Public Vars
		//public var alt:String			= '';
		
		/** 
		*	Constructs a new Image object
		*	@param obj Object containing all properties to construct the class	
		**/
		public function Image(obj:Object) {
			super();
			cacheAsBitmap	= true;
			
			//Set Defaults
			data.x			= 0;
			data.y			= 0;
			data.src		= '';
			data.image		= null;
			
			//Set Attributes
			setAttributes(obj, ['src', 'image', 'width', 'height']);
			
			if(data.src != '') {
				src		= obj.src;
			}
			else if(data.image != null) {
				image	= obj.image;
			}
			
			isSetup = true;
		}
		
		/** Load new image. Any existing image will be replaced.
		*
		*	@param src Relative path of image. **/
		public function load(src:String):void {
			data.isLoaded	= false;
			
			//Remove old
			clean();
			
			//Add new image
			data.src				= src;
			var req:URLRequest		= new URLRequest(basePath+src);
			var ldr:Loader			= new Loader();
			ldr.name				= id;
			
			var lc:LoaderContext	= new LoaderContext();
			lc.checkPolicyFile		= true;

			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded);
			ldr.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			ldr.load(req, lc);
			
			//Cleanup
			req = null;
		}
		
		/** Relative path to the image **/
		public function get src():String {
			return data.src;
		}
		public function set src(value:String):void {
			data.src	= value;
			
			if(data.src != '') {
				load(data.src);
			}
		}
		
		/** Bitmap object containing the loaded image **/
		public function get image():Bitmap {
			return data.image;
		}
		public function set image(value:Bitmap):void {
			if(!value) {
				return;
			}
			
			clean();
			
			data.image		= value;
			value.smoothing	= true;
			addChild(value);
			
			//Set size to content if not already set
			if(position == 'stretch') {
				setSize(data.stage.stageWidth, data.stage.stageHeight);
			} else {
				if(!isNaN(data.width)) {
					width	= data.width;
				} else {
					width	= value.width;
				}
				
				if(!isNaN(data.height)) {
					height	= data.height;
				} else {
					height	= value.height;
				}
			}
			
			data.isLoaded	= true;
			trigger('element_loaded');
		}
		
		/** @private **/
		private function onLoaded(e:Event):void {
			var loadInfo:LoaderInfo	= e.target as LoaderInfo;
			loadInfo.removeEventListener(Event.COMPLETE, onLoaded);
			
			var ldr:Loader	= loadInfo.loader;
			
			if(ldr.content && ldr.content is Bitmap) {
				image	= Bitmap(ldr.content);
			}
		}
		
		/** @private **/
		private function onError(e:IOErrorEvent):void {
			trigger(ElementEvent.ERROR, null, e);
			trace('IO Error: '+e.text);
		}
		
		/** Get the bounds of the element **/
		public override function elementBounds():Rectangle {
			var bounds:Rectangle	= new Rectangle(0, 0, image.width, image.height);
			return bounds;
		}
		
		public function clone(getBitmap:Boolean=false):Bitmap {
			if(!image) {
				return null;
			}
			
			if(getBitmap) {
				var bdata:BitmapData	= image.bitmapData as BitmapData;
				var bitmap:Bitmap		= new Bitmap(bdata, 'auto', true);
				
				return bitmap;
			} else {
				return null;
			}
		}
		
		public function clean():void {
			if(image) {
				if(contains(image)) {
					removeChild(image);
					image	= null;
				}
			}
		}
		
		/** Kill the object and clean from memory. **/
		public override function kill():void {
			
			//Remove Children
			clean();
			
			//Nullify values
			//alt			= null;
			src			= null;
			
			//Image
			removeChild(image);
			image		= null;
			
			super.kill();
		}
	}
}