/**
* Paper by Giraldo Rosales.
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
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	import flash.filters.BlurFilter;
	import flash.system.System;
	import flash.events.MouseEvent;
	
	//PaperVision3D Classes
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.core.proto.MaterialObject3D;
	
	//LG Classes
	import lg.flash.elements.VisualElement;
	import lg.flash.events.ElementEvent;
	import lg.flash.motion.Tween;
	
	/**
	*	<p>Creates a Papervision Plane object. Adding all attributes and materials. The Plane and MovieMaterial
	*	can be accessed via public properties for further manipulation.</p>
	**/
	public class Paper extends VisualElement {
		/** Reference to the Papervision Plane. **/
		public var plane:Plane;
		/** Reference to the Papervision MaterialObject3D. **/
		public var material:MaterialObject3D;
		
		/** 
		*	Constructs a new Paper object
		*	@param obj Object containing all properties to construct the Paper class.
		**/
		public function Paper(obj:Object=null):void {
			super();
			
			//Set defaults
			data.transparent		= true;
			data.animated			= false;
			data.precise			= false;
			data.pixelPrecision 	= 8;
			data.interactive		= false;
			data.doubleSided		= false;
			data.oneSide			= true;
			data.allowAutoResize	= false;
			data.smooth				= true;
			data.color				= 0x000000;
			data.alpha				= 0;
			data.quality			= 5;
			data.blurIdx			= 0;
			data.blurX				= 0;
			data.blurY				= 0;
			data.fillAlpha			= 0;
			data.fillColor			= 0x000000;
			data.lineAlpha			= 0;
			data.lineColor			= 0x000000;
			data.baked				= true;
			
			//Add attributes from object
			setAttributes(obj);
		}
		
		/** @private **/
		protected function onLoadElement(e:ElementEvent):void {
			var element:VisualElement	= e.target as VisualElement;
			
			if(element) {
				getElement(element);
			}
		}
		
		/** @private **/
		protected function getElement(element:VisualElement):void {
			if(data.width == undefined || data.width < 0) {
				data.width	= element.width;
			}
			
			if(data.height == undefined || data.height < 0) {
				data.height	= element.height;
			}
			
			if(data.bounds == undefined) {
				var bounds:Rectangle	= element.elementBounds();
				data.bounds	= bounds;
			}
			
			addElement(element);
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
		public function addElement(element:VisualElement):void {
			//if(data.interactive) {
			//	element.button();
			//}
		}
		
		protected function onAddMaterial():void {
			plane						= new Plane(material, data.width, data.height, data.quality, data.quality);
			plane.useOwnContainer		= true;
			
			if(data.interactive) {
				interactive = Boolean(data.interactive);
			}
			
			if('x' in data) {
				plane.x				= data.x;
			}
			if('y' in data) {
				plane.y				= data.y;
			}
			if('z' in data) {
				plane.z				= data.z;
			}
			if('rotationX' in data) {
				plane.rotationX		= data.rotationX;
			}
			if('rotationY' in data) {
				plane.rotationY		= data.rotationY;
			}
			
			data.isLoaded	= true;
			trigger('element_loaded');
		}
		
		/** Set the position of the Paper object. **/
		public function set3DPos(x:int, y:int, z:int):void {
			plane.x	= x;
			plane.y	= y;
			plane.z	= z;
		}
		
		public override function animate(obj:Object):Tween {
			obj.target		= this;
			var tween:Tween	= new Tween(obj);
			
			return tween;
		}
		
		//Plane Properties
		public override function get x():Number {
			var value:Number	= 0;
			
			if(plane) {
				value	= plane.x;
			}
			return value;
		}
		public override function set x(value:Number):void {
			data.x	= value;
			
			if(plane) {
				plane.x = data.x;
			}
		}
		
		public override function get y():Number {
			var value:Number	= 0;
			
			if(plane) {
				value	= plane.y;
			}
			return value;
		}
		public override function set y(value:Number):void {
			data.y	= value;
			
			if(plane) {
				plane.y = data.y;
			}
		}
		
		public override function get z():Number {
			var value:Number	= 0;
			
			if(plane) {
				value	= plane.z;
			}
			return value;
		}
		public override function set z(value:Number):void {
			data.z	= value;
			
			if(plane) {
				plane.z = value;
			}
		}
		public override function get rotationY():Number {
			var value:Number	= 0;
			
			if(plane) {
				value	= plane.rotationY;
			}
			return value;
		}
		public override function set rotationY(value:Number):void {
			data.rotationY	= value;
			
			if(plane) {
				plane.rotationY = data.rotationY;
			}
		}
		public override function get rotationX():Number {
			var value:Number	= 0;
			
			if(plane) {
				value	= plane.rotationX;
			}
			return value;
		}
		public override function set rotationX(value:Number):void {
			data.rotationX	= value;
			
			if(plane) {
				plane.rotationX = data.rotationX;
			}
		}
		public override function get rotationZ():Number {
			var value:Number	= 0;
			
			if(plane) {
				value	= plane.rotationZ;
			}
			return value;
		}
		public override function set rotationZ(value:Number):void {
			data.rotationZ	= value;
			
			if(plane) {
				plane.rotationZ = data.rotationZ;
			}
		}
		
		public function get localRotationX():Number {
				var value:Number	= 0;
				
				if(plane) {
					value	= plane.localRotationX;
				}
				return value;
		}
		public function set localRotationX(value:Number):void {
			data.localRotationX	= value;
			
			if(plane) {
				plane.localRotationX = data.localRotationX;
			}
		}
		public function get localRotationY():Number {
				var value:Number	= 0;
				
				if(plane) {
					value	= plane.localRotationY;
				}
				return value;
		}
		public function set localRotationY(value:Number):void {
			data.localRotationY	= value;
			
			if(plane) {
				plane.localRotationY = data.localRotationY;
			}
		}
		public function get localRotationZ():Number {
				var value:Number	= 0;
				
				if(plane) {
					value	= plane.localRotationZ;
				}
				return value;
		}
		public function set localRotationZ(value:Number):void {
			data.localRotationZ	= value;
			
			if(plane) {
				plane.localRotationZ = data.localRotationZ;
			}
		}
		
		public override function get scaleX():Number {
				var value:Number	= 0;
				
				if(plane) {
					value	= plane.scaleX;
				}
				return value;
		}
		public override function set scaleX(value:Number):void {
			data.scaleX	= value;
			
			if(plane) {
				plane.scaleX = data.scaleX;
			}
		}
		
		public override function get scaleY():Number {
				var value:Number	= 0;
				
				if(plane) {
					value	= plane.scaleY;
				}
				return value;
		}
		public override function set scaleY(value:Number):void {
			data.scaleY	= value;
			
			if(plane) {
				plane.scaleY = data.scaleY;
			}
		}
		/*
		public override function get alpha():Number {
			if(material.movie) {
				return material.movie.alpha;
			}
			return 0;
		}
		public override function set alpha(value:Number):void {
			data.alpha	= value;
			material.movie.alpha = data.alpha;
		}
		*/
		/*
		public function getFilters():Array {
			if(material.movie) {
				return material.movie.filters;
			} else {
				return [];
			}
		}
		public function addFilter(value:Object):void {
			var filter:Array		= material.movie.filters;
			filter[filter.length]	= value;
			
			if(material.movie) {
				material.movie.filters	= filter;
			}
		}
		*/
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
		/*
		public function get transparent():Boolean {
			return material.movieTransparent;
		}
		public function set transparent(value:Boolean):void {
			data.transparent			= value;
			material.movieTransparent	= data.transparent;
		}
		public function get animated():Boolean {
			return material.animated;
		}
		public function set animated(value:Boolean):void {
			data.animated		= value;
			material.animated	= data.animated;
		}
		public function get precise():Boolean {
			return material.precise;
		}
		public function set precise(value:Boolean):void {
			data.precise		= value;
			material.precise	= data.precise;
		}
		*/
		public function get interactive():Boolean {
			return data.interactive;
		}
		public function set interactive(value:Boolean):void {
			data.interactive	= value;
			
			if(value) {
				if(material) {
					material.interactive = true;
				}
				if(plane && !plane.hasEventListener(InteractiveScene3DEvent.OBJECT_PRESS)) {
					plane.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, onClickPlane);
					plane.addEventListener(InteractiveScene3DEvent.OBJECT_DOUBLE_CLICK, onDblClickPlane);
					plane.addEventListener(InteractiveScene3DEvent.OBJECT_OVER, onOverPlane);
					plane.addEventListener(InteractiveScene3DEvent.OBJECT_OUT, onOutPlane);
				}
			} else {
				if(material) {
					material.interactive = false;
				}
				
				if(plane && plane.hasEventListener(InteractiveScene3DEvent.OBJECT_PRESS)) {
					plane.removeEventListener(InteractiveScene3DEvent.OBJECT_PRESS, onClickPlane);
					plane.removeEventListener(InteractiveScene3DEvent.OBJECT_DOUBLE_CLICK, onDblClickPlane);
					plane.removeEventListener(InteractiveScene3DEvent.OBJECT_OVER, onOverPlane);
					plane.removeEventListener(InteractiveScene3DEvent.OBJECT_OUT, onOutPlane);
				}
			}
		}
		/*
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
				material.movie.transform.colorTransform = new ColorTransform(1,1,1,1,bright,bright,bright,0);
			} else {
				bright = 1 + value;
				material.movie.transform.colorTransform = new ColorTransform(bright,bright,bright,1,0,0,0,0);
			}
		}
		*/
		/** @private **/
		private function onClickElement(e:ElementEvent):void {
			trigger('element_click', {}, e);
		}
		/** @private **/
		private function onDblClickElement(e:ElementEvent):void {
			trigger('element_dblclick', {}, e);
		}
		/** @private **/
		private function onOverElement(e:ElementEvent):void {
			trigger('element_mouseover', {}, e);
		}
		/** @private **/
		private function onOutElement(e:ElementEvent):void {
			trigger('element_mouseout', {}, e);
		}
		
		public function onClickPlane(e:InteractiveScene3DEvent):void {
			trigger('element_click', {}, e);
		}
		/** @private **/
		protected override function onClick(e:MouseEvent):void {
		}
		public function onDblClickPlane(e:InteractiveScene3DEvent):void {
			trigger('element_dblclick', {}, e);
		}
		/** @private **/
		protected override function onDoubleClick(e:MouseEvent):void {
		}
		public function onOverPlane(e:InteractiveScene3DEvent):void {
			trigger('element_mouseover', {}, e);
		}
		/** @private **/
		protected override function onMouseOut(e:MouseEvent):void {
		}
		public function onOutPlane(e:InteractiveScene3DEvent):void {
			trigger('element_mouseout', {}, e);
		}
		/** @private **/
		protected override function onMouseOver(e:MouseEvent):void {
		}
		
		public override function kill():void {
			//if(material.movie) {
			//	material.movie	= null;
			//}
			
			plane		= null;
			
			super.kill();
		}
	}
}