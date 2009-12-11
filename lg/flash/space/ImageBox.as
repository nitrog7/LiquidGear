/**
* ImageBox Class by Giraldo Rosales.
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
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import lg.flash.elements.Image;
	
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;
	
	/**
	*	<p>Loads external image files, giving it all the functionality of the Image object within a 3D space.</p>
	**/
	public class ImageBox extends Box {
		//public var material:BitmapFileMaterial;
		
		private var _numFaces:int		= 0;
		private var _sides:Array		= [];
		private var _loaded:Timer		= new Timer(500, 0);
		
		/** 
		*	Constructs a new ImageBox object
		*	@param obj Object containing all properties to construct the ImageBox class. You can use a 
		*	compination of both Image properties and Papervision's Plane properties.	
		**/
		public function ImageBox(obj:Object):void {
			super(obj);
			_loaded.addEventListener('timer', onLoadedBitmap);
			var faces:Array	= data.faces as Array;
			addImages(faces);
		}
		
		public function addImages(faces:Array):void {
			var face:Object		= {};
			_numFaces			= faces.length;
			var pos:String;
			var element:Image;
			
			materialsList		= new MaterialsList();
			
			for(var g:int=0; g<_numFaces; g++) {
				face	= faces[g];
				
				if(_numFaces == 1) {
					pos		= 'all';
				} else {
					pos		= face.side;
				}
				
				face.type	= (face.type != undefined) ? face.type : 'color';
				face.color	= (face.color != undefined) ? face.color : 0x000000;
				face.alpha	= (face.alpha != undefined) ? face.alpha : 1;
				
				switch(face.type) {
					case  'image':
						material	= new BitmapFileMaterial(face.src);
						break;
					default:
						material	= new ColorMaterial(face.color, face.alpha, true);
						break;
				}
				
				material.name			= pos;
				material.oneSide		= data.oneSide;
				material.smooth			= true;
				material.interactive	= true;
				_sides[g]				= material;
				materialsList.addMaterial(material, pos);
			}
			
			_loaded.start();
				
			cube					= new Cube(materialsList, data.width, data.depth, data.height, data.quality, data.quality, data.quality, data.insideFaces, data.excludeFaces);
			cube.useOwnContainer	= true;
			cube.useClipping		= false;
			
			if(data.interactive) {
				interactive = Boolean(data.interactive);
			}
			
			if('x' in data) {
				cube.x				= data.x;
			}
			if('y' in data) {
				cube.y				= data.y;
			}
			if('z' in data) {
				cube.z				= data.z;
			}
			if('rotationX' in data) {
				cube.rotationX		= data.rotationX;
			}
			if('rotationY' in data) {
				cube.rotationY		= data.rotationY;
			}
		}
		
		
		private function onLoadedBitmap(e:TimerEvent):void {
			var faces:int	= 0;
			
			for(var g:int=0; g<_numFaces; g++) {
				if(_sides[g] is BitmapMaterial) {
					if(_sides[g].loaded) {
						faces++;
					}
				} else {
					faces++;
				}
			}
			trace('faces', faces);
			if(faces == 6) {
				_loaded.stop();
				trigger('element_loaded');
			}
		}
	}
}