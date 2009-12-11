/**
* ImagePaper Class by Giraldo Rosales.
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

package lg.flash.space {
	//Flash
	import flash.geom.Rectangle;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	//LG Classes
	import lg.flash.elements.Image;
	import lg.flash.elements.VisualElement;
	import lg.flash.events.ElementEvent;
	
	//PaperVision3D Classes
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.core.proto.MaterialObject3D;
	
	/**
	*	<p>Loads external image files, giving it all the functionality of the Image object within a 3D space.</p>
	**/
	public class ImagePaper extends Paper {
		/** Reference to the Element. **/
		public var bitmap:BitmapData;
		
		private var _loaded:Timer	= new Timer(500, 0);
		/** 
		*	Constructs a new ImagePaper object
		*	@param obj Object containing all properties to construct the ImagePaper class. You can use a 
		*	compination of both Image properties and Papervision's Plane properties.	
		**/
		public function ImagePaper(obj:Object):void {
			super(obj);
			
			_loaded.addEventListener('timer', onLoadedBitmap);
			
			if(obj.image != undefined) {
				var element:VisualElement	= obj.image as VisualElement;
				getElement(element);
			}
			else if(obj.src != undefined) {
				addImage(obj.src);
			}
		}
		
		public override function addElement(element:VisualElement):void {
			//Get bitmap data
			var element:VisualElement	= element as VisualElement;
			var bmap:BitmapData			= new BitmapData(element.width, element.height, true, 0x000000);
			bmap.draw(element, null, null, null, null, true);
			
			var bmat:BitmapMaterial		= new BitmapMaterial(bmap, true)
			bmat.smooth					= data.smooth;
			bmat.fillAlpha				= data.fillAlpha;
			bmat.fillColor				= data.fillColor;
			bmat.lineAlpha				= data.lineAlpha;
			bmat.lineColor				= data.lineColor;
			bmat.baked					= data.baked;
			bmat.doubleSided			= data.doubleSided;
			bmat.oneSide				= !data.doubleSided;
			
			material					= bmat as MaterialObject3D;
			
			onAddMaterial();
		}
		
		public function addImage(src:String):void {
			var bmat:BitmapFileMaterial	= new BitmapFileMaterial(src, true);
			bmat.smooth					= data.smooth;
			bmat.fillAlpha				= data.fillAlpha;
			bmat.fillColor				= data.fillColor;
			bmat.lineAlpha				= data.lineAlpha;
			bmat.lineColor				= data.lineColor;
			bmat.baked					= data.baked;
			bmat.doubleSided			= data.doubleSided;
			bmat.oneSide				= !data.doubleSided;
			
			material					= bmat as MaterialObject3D;
			_loaded.start();
		}
		
		private function onLoadedBitmap(e:TimerEvent):void {
			var bmat:BitmapFileMaterial	= material as BitmapFileMaterial;
			
			if(bmat.loaded) {
				_loaded.stop();
				bitmap	= bmat.bitmap;
				onAddMaterial();
			}
		}
		
		public override function kill():void {
			material	= null;
			super.kill();
		}
	}
}