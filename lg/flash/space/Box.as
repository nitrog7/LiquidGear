/**
* Box by Giraldo Rosales.
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
	//Flash Classes
	import lg.flash.elements.VisualElement;
	import lg.flash.motion.Tween;
	
	import org.papervision3d.core.proto.DisplayObjectContainer3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;
	
	/**
	*	<p>Creates a Papervision Cube object. Adding all attributes and materials. The Cube and MovieMaterial
	*	can be accessed via public properties for further manipulation.</p>
	**/
	public class Box extends VisualElement {
		public static const ALL:int		= Cube.ALL;
		public static const FRONT:int	= Cube.FRONT;
		public static const BACK:int	= Cube.BACK;
		public static const LEFT:int	= Cube.LEFT;
		public static const RIGHT:int	= Cube.RIGHT;
		public static const TOP:int		= Cube.TOP;
		public static const BOTTOM:int	= Cube.BOTTOM;
		
		/** Reference to the Papervision Cube. **/
		public var cube:Cube;
		public var material:MaterialObject3D	= new MaterialObject3D();
		
		/** Reference to the Papervision MovieMaterial. **/
		public var materialsList:MaterialsList;
		/** 
		*	Constructs a new Box object
		*	@param obj Object containing all properties to construct the Box class.
		**/
		public function Box(obj:Object=null):void {
			super();
			
			//Set defaults
			data.transparent		= false;
			data.animated			= false;
			data.precise			= false;
			data.interactive		= false;
			data.doubleSided		= false;
			data.oneSide			= true;
			data.allowAutoResize	= false;
			data.smooth				= true;
			data.color				= 0x000000;
			data.alpha				= 0;
			data.depth				= 0;
			data.quality			= 5;
			data.blurIdx			= 0;
			data.blurX				= 0;
			data.blurY				= 0;
			data.insideFaces		= 0;
			data.excludeFaces		= 0;
			data.faces				= [];
			
			//Add attributes from object
			setAttributes(obj);
		}
		public override function button():void {
			interactive	= true;
		}
		public override function holder():void {
			interactive	= false;
		}
		public override function ghost():void {
			interactive	= false;
		}
		/*
		public function addSides(faces:Array):void {
			var face:Object	= {};
			var faceLen:int		= faces.length;
			var pos:String;
			var element:Image;
			var material:BitmapFileMaterial;
			
			materialsList		= new MaterialsList();
			
			for(var g:int=0; g<faceLen; g++) {
				face	= faces[g];
				
				if(faceLen == 1) {
					pos		= 'all';
				} else {
					pos		= face.side;
				}
				
				material	= new BitmapFileMaterial(face.src);//createSide(element, pos) as MovieMaterial;
				trace('pos', pos);
				materialsList.addMaterial(material, pos);
			}
			
			cube					= new Cube(materialsList, data.width, data.depth, data.height, data.segmentsS, data.segmentsT, data.segmentsH, data.insideFaces, data.excludeFaces);
			cube.useOwnContainer	= true;
			
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
			
			trigger('element_loaded');
		}
		
		protected function createSide(element:Image, side:String):MovieMaterial {
			var material:MovieMaterial	= new MovieMaterial(element);
			
			material.movieTransparent	= data.transparent;
			material.animated			= data.animated;
			material.precise			= data.precise;
			material.smooth				= data.smooth;
			material.doubleSided		= data.doubleSided;
			material.oneSide			= !data.doubleSided;
			material.allowAutoResize	= true;
			material.interactive		= true;
			material.baked				= true;
			
			return material;
		}
		*/
		/** Set the position of the Paper object. **/
		public override function setPos(x:Number, y:Number, z:Number=0):void {
			cube.x	= x;
			cube.y	= y;
			cube.z	= z;
		}
		
		public override function animate(obj:Object):Tween {
			obj.target		= this;
			var tween:Tween	= new Tween(obj);
			
			return tween;
		}
		
		//Cube Properties
		public override function get width():Number {
			return data.width;
		}
		public override function set width(value:Number):void {
			data.width	= value;
			
			if(cube) {
				//cube.width	= value;
			}
		}
		
		public override function get height():Number {
			return data.height;
		}
		public override function set height(value:Number):void {
			data.height	= value;
			
			if(cube) {
				//cube.height = value;
			}
		}
		
		public override function get x():Number {
			return cube.x;
		}
		public override function set x(value:Number):void {
			data.x	= value;
			
			if(cube) {
				cube.x = data.x;
			}
		}
		
		public override function get y():Number {
			return cube.y;
		}
		public override function set y(value:Number):void {
			data.y	= value;
			
			if(cube) {
				cube.y = data.y;
			}
		}
		
		public override function get z():Number {
			return cube.z;
		}
		public override function set z(value:Number):void {
			data.z	= value;
			
			if(cube) {
				cube.z = data.z;
			}
		}
		public override function get rotationY():Number {
			return cube.rotationY;
		}
		public override function set rotationY(value:Number):void {
			data.rotationY	= value;
			
			if(cube) {
				cube.rotationY = data.rotationY;
			}
		}
		public override function get rotationX():Number {
			return cube.rotationX;
		}
		public override function set rotationX(value:Number):void {
			data.rotationX	= value;
			
			if(cube) {
				cube.rotationX = data.rotationX;
			}
		}
		public override function get rotationZ():Number {
			return cube.rotationZ;
		}
		public override function set rotationZ(value:Number):void {
			data.rotationZ	= value;
			
			if(cube) {
				cube.rotationZ = data.rotationZ;
			}
		}
		
		public function get localRotationX():Number {
			return cube.localRotationX;
		}
		public function set localRotationX(value:Number):void {
			data.localRotationX	= value;
			
			if(cube) {
				cube.localRotationX = data.localRotationX;
			}
		}
		public function get localRotationY():Number {
			return cube.localRotationY;
		}
		public function set localRotationY(value:Number):void {
			data.localRotationY	= value;
			
			if(cube) {
				cube.localRotationY = data.localRotationY;
			}
		}
		public function get localRotationZ():Number {
			return cube.localRotationZ;
		}
		public function set localRotationZ(value:Number):void {
			data.localRotationZ	= value;
			
			if(cube) {
				cube.localRotationZ = data.localRotationZ;
			}
		}
		
		public override function get scaleX():Number {
			return cube.scaleX;
		}
		public override function set scaleX(value:Number):void {
			data.scaleX	= value;
			
			if(cube) {
				cube.scaleX = data.scaleX;
			}
		}
		
		public override function get scaleY():Number {
			return cube.scaleY;
		}
		public override function set scaleY(value:Number):void {
			data.scaleY	= value;
			cube.scaleY = data.scaleY;
		}
		
		public function getFilters():Array {
			/*
			if(material.movie) {
				return material.movie.filters;
			} else {
				return [];
			}
			*/
			return [];
		}
		
		public function addFilter(value:Object):void {
			/*
			var filter:Array		= material.movie.filters;
			filter[filter.length]	= value;
			
			if(material.movie) {
				material.movie.filters	= filter;
			}
			*/
		}
		
		public function get blurX():Number {
			return data.blurX;
		}
		public function set blurX(value:Number):void {
			data.blurX	= value;
			blur(value);
		}
		
		public function get blurY():Number {
			return data.blurY;
		}
		public function set blurY(value:Number):void {
			data.blurY	= value;
			blur(value);
		}
		public function get transparent():Boolean {
			//return material.movieTransparent;
			return data.transparent;
		}
		public function set transparent(value:Boolean):void {
			data.transparent			= value;
			//material.movieTransparent	= data.transparent;
		}
		public function get animated():Boolean {
			//return material.animated;
			return data.animated;
		}
		public function set animated(value:Boolean):void {
			data.animated		= value;
			//material.animated	= data.animated;
		}
		public function get precise():Boolean {
			//return material.precise;
			return data.precise;
		}
		public function set precise(value:Boolean):void {
			data.precise		= value;
			//material.precise	= data.precise;
		}
		public function get interactive():Boolean {
			//return material.interactive;
			return data.interactive;
		}
		public function set interactive(value:Boolean):void {
			data.interactive	= value;
			
			if(cube) {
				if(value) {
					cube.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, onClickCube);
					cube.addEventListener(InteractiveScene3DEvent.OBJECT_DOUBLE_CLICK, onDblClickCube);
					cube.addEventListener(InteractiveScene3DEvent.OBJECT_OVER, onOverCube);
					cube.addEventListener(InteractiveScene3DEvent.OBJECT_OUT, onOutCube);
				} else {
					cube.removeEventListener(InteractiveScene3DEvent.OBJECT_PRESS, onClickCube);
					cube.removeEventListener(InteractiveScene3DEvent.OBJECT_DOUBLE_CLICK, onDblClickCube);
					cube.removeEventListener(InteractiveScene3DEvent.OBJECT_OVER, onOverCube);
					cube.removeEventListener(InteractiveScene3DEvent.OBJECT_OUT, onOutCube);
				}
			}
		}
		
		public function get doubleSided():Boolean {
			return material.doubleSided;
		}
		public function set doubleSided(value:Boolean):void {
			data.doubleSided		= value;
			material.doubleSided	= data.doubleSided;
		}
		public function get smooth():Boolean {
			return material.smooth;
		}
		public function set smooth(value:Boolean):void {
			data.smooth		= value;
			material.smooth	= data.smooth;
		}
		
		public function get brightness():Number {
			return data.brightness;
		}
		public function set brightness(value:Number):void {
			data.brightness	= value;
			var bright:Number;
			
			if(value >= 0) {
				bright = int(data.brightness * 255);
				//material.movie.transform.colorTransform = new ColorTransform(1,1,1,1,bright,bright,bright,0);
			} else {
				bright = 1 + value;
				//material.movie.transform.colorTransform = new ColorTransform(bright,bright,bright,1,0,0,0,0);
			}
		}
		
		public function onClickCube(e:InteractiveScene3DEvent):void {
			trace('onClickCube');
			trigger('element_click', e);
		}
		public function onDblClickCube(e:InteractiveScene3DEvent):void {
			trigger('element_dblclick', e);
		}
		public function onOverCube(e:InteractiveScene3DEvent):void {
			trace('onOverCube');
			trigger('element_mouseover', e);
		}
		public function onOutCube(e:InteractiveScene3DEvent):void {
			trigger('element_mouseout', e);
		}
		
		public override function kill():void {
			//if(material.movie) {
			//	material.movie	= null;
			//}
			
			material	= null;
			cube		= null;
			
			super.kill();
		}
	}
}