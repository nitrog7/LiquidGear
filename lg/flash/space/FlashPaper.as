/**
* FlashPaper Class by Giraldo Rosales.
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
	
	//LG Classes
	import lg.flash.elements.VisualElement;
	import lg.flash.elements.Flash;
	import lg.flash.events.ElementEvent;
	
	//Papervision
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.core.proto.MaterialObject3D;
	
	/**
	*	<p>Loads external flash files and movieclips, giving it all the functionality of the Flash object within a 3D space.</p>
	**/
	public class FlashPaper extends Paper {
		/** Reference to the Element. **/
		public var element:VisualElement;
		
		/** 
		*	Constructs a new FlashPaper object
		*	@param obj Object containing all properties to construct the FlashPaper class. You can use a 
		*	compination of both Flash properties and Papervision's Plane properties.	
		**/
		public function FlashPaper(obj:Object):void {
			super(obj);
			
			if(obj.flash != undefined) {
				element	= obj.flash as VisualElement;
				getElement(element);
			} else {
				obj.x	= 0;
				obj.y	= 0;
				element	= new Flash(obj) as VisualElement;
				
				if(!element.isLoaded) {
					element.loaded(onLoadElement);
				} else {
					getElement(element);
				}
			}
		}
		
		public override function addElement(element:VisualElement):void {
			var elementRect:Rectangle;
			
			if('bounds' in data) {
				elementRect	= data.bounds;
			} else {
				elementRect	= element.getSize();
			}
			
			var mmat:MovieMaterial		= new MovieMaterial(element, data.transparent, data.animated, data.precise, elementRect);
			mmat.smooth					= data.smooth;
			mmat.doubleSided			= data.doubleSided;
			//mmat.pixelPrecision		= data.pixelPrecision;
			mmat.oneSide				= !data.doubleSided;
			//mmat.allowAutoResize		= true;
			mmat.interactive			= data.interactive;
			mmat.baked					= data.baked;
			
			material					= mmat as MaterialObject3D;
			onAddMaterial();
		}
		
		public override function kill():void {
			//if(material.movie) {
			//	material.movie	= null;
			//}
			
			material	= null;
			plane		= null;
			
			super.kill();
		}
	}
}