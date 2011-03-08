/**
* Image Class by Giraldo Rosales.
* Visit www.liquidgear.net for documentation and updates.
*
*
* Copyright (c) 2011 Nitrogen Labs, Inc. All rights reserved.
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
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
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
		public function Image(obj:Object=null) {
			super();
			
			//Set Defaults
			data.x			= 0;
			data.y			= 0;
			data.src		= '';
			data.image		= null;
			
			//Set Attributes
			setAttributes(obj, ['src', 'image']);
			
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
			data._isLoaded	= false;
			
			//Remove old
			clean();
			
			//Add new image
			data.src				= src;
			var fullPath:String		= basePath + src;
			
			if(src && src.indexOf('://') >= 0) {
				fullPath	= src;
			}
			
			var req:URLRequest		= new URLRequest(fullPath);
			var ldr:Loader			= new Loader();
			ldr.name				= id;
			
			var lc:LoaderContext	= new LoaderContext();
			lc.checkPolicyFile		= true;
			
			if(!isDevelopment) {
				lc.securityDomain		= SecurityDomain.currentDomain;
				lc.applicationDomain	= ApplicationDomain.currentDomain;
			}
			
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
		public function set image(bitmap:Bitmap):void {
			if(!bitmap) {
				return;
			}
			
			clean();
			
			data.image			= bitmap;
			bitmap.smoothing	= true;
			addChild(bitmap);
			
			//Set size to content if not already set
			if(position == 'stretch') {
				setSize(data.stage.stageWidth, data.stage.stageHeight);
			} else {
				if(!isNaN(data.width)) {
					width		= data.width;
				} else {
					data.width	= bitmap.width;
				}
				
				if(!isNaN(data.height)) {
					height		= data.height;
				} else {
					data.height	= bitmap.height;
				}
			}
			/*
			if(!isNaN(data.scaleX)) {
				image.scaleX	= data._scaleX;
			}
			if(!isNaN(data.scaleY)) {
				image.scaleY	= data._scaleY;
			}
			*/
			data._isLoaded	= true;
			trigger(ElementEvent.LOADED);
		}
		
		public override function set width(value:Number):void {
			data.width	= value;
			
			if(image) {
				image.width	= value;
				trigger(ElementEvent.RESIZE);
			}
		}
		
		public override function set height(value:Number):void {
			data.height	= value;
			
			if(image) {
				image.height	= value;
				trigger(ElementEvent.RESIZE);
			}
		}
		
		public override function set scaleX(value:Number):void {
			data._scaleX	= value;
			
			if(image) {
				data.image.scaleX	= value;
			}
		}
		
		public override function set scaleY(value:Number):void {
			data._scaleY	= value;
			
			if(image) {
				data.image.scaleY	= value;
			}
		}
		
		public function get actualWidth():Number {
			return image.width;
		}
		public function get actualHeight():Number {
			return image.height;
		}
		
		public function get resizedWidth():Number {
			var minVal:Number	= (image.height > data.height) ? data.height : image.height;
			var maxVal:Number	= (data.height > image.height) ? data.height : image.height;
			var value:Number	= image.width * (minVal / maxVal);
			return value;
		}
		public function get resizedHeight():Number {
			var minVal:Number	= (image.width > data.width) ? data.width : image.width;
			var maxVal:Number	= (data.width > image.width) ? data.width : image.width;
			var value:Number	= image.height * (minVal / maxVal);
			return value;
		}
		
		/** @private **/
		private function onLoaded(e:Event):void {
			var info:LoaderInfo	= e.target as LoaderInfo;
			
			if(info.content && info.content is Bitmap) {
				image	= Bitmap(info.content);
			}
		} 
		
		/** @private **/
		private function onError(e:IOErrorEvent):void {
			trigger(ElementEvent.ERROR, null, e);
			trace('IO Error: id:', id, '::', e.text);
		}
		
		/** Get the bounds of the element **/
		public override function elementBounds():Rectangle {
			var bounds:Rectangle	= new Rectangle(0, 0, image.width, image.height);
			return bounds;
		}
		
		/** Clone the Image element.
		 * @return Cloned Image element.
		 */		
		public function clone():Image {
			if(!image) {
				return null;
			}
			
			var bdata:BitmapData	= image.bitmapData as BitmapData;
			var bitmap:Bitmap		= new Bitmap(bdata, 'auto', true);
			var img:Image			= new Image({image:bitmap});	
			
			return img;
		}
		
		/** Flip the element horizontally **/
		public override function flipX():void {
			var matrix:Matrix		= image.transform.matrix;
			matrix.a				= -1;
			matrix.tx				= image.width + image.x;
			image.transform.matrix	= matrix;
		}
		
		/** Flip the element vertically **/
		public override function flipY():void {
			var matrix:Matrix		= image.transform.matrix;
			matrix.d				= -1;
			matrix.ty				= image.height + image.y;
			image.transform.matrix	= matrix;
		}
		
		/** Clean up element and restore to empty state **/
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
			if(image && contains(image)) {
				removeChild(image);
			}
			
			image		= null;
			
			super.kill();
		}
	}
}