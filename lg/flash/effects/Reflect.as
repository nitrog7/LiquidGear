/**
* Reflect by Ben Pritchard.
* Modified by: Giraldo Rosales
* Visit www.liquidgear.net for documentation and updates.
*
*
* Copyright (c) 2010 Nitrogen Labs, Inc. All rights reserved.
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

package lg.flash.effects {
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	
	import lg.flash.elements.Element;
	
	public class Reflect extends Sprite {
		/** @private **/
		private var element:Element;
		/** @private **/
		private var elementBitmap:BitmapData;
		/** @private **/
		private var reflectionBitmap:Bitmap;
		/** @private **/
		private var gradientMask:Sprite	= new Sprite();
		/** @private **/
		private var updateInt:Number;
		/** @private **/
		private var bounds:Object;
		/** @private **/
		private var distance:Number = 0;
	
		/**
		*	Creates a reflection of an element 
		*	@param prop Properties used to create the reflection.
		*	<ul>
		*		<li><strong>target</strong>:<em>VisualElement</em> - Element which is referenced.</li>
		*		<li><strong>alpha</strong>:<em>Number</em> - (optional) Opacity of the reflection. (default: .15)</li>
		*		<li><strong>ratio</strong>:<em>Number</em> - (optional) The ratio opaque color used in the gradient mask. (default: 100)</li>
		*		<li><strong>distance</strong>:<em>Number</em> - (optional) Distance from original element. (default: 0)</li>
		*		<li><strong>updateTime</strong>:<em>Number</em> - (optional) Time persiod to update reflection. Use when animating element. To save on performance, set to -1 to turn off if not animating the element. (default: -1)</li>
		*		<li><strong>reflectionDropoff</strong>:<em>Number</em> - (optional) The distance at which the reflection visually drops off at. (default: 0)</li>
		*	</ul>
		**/
		function Reflect(prop:Object){
			var obj:Object			= {};
			
			obj.alpha				= .15;
			obj.ratio				= 100;
			obj.distance			= 0;
			obj.updateTime			= -1;
			obj.reflectionDropoff	= 0;
			
			for(var s:String in prop) {
				obj[s] = prop[s];
			}
			
			element = prop.target;
			
			//store width and height of the clip
			var eHeight:int	= element.height;
			var eWidth:int	= element.width;
			
			//store the bounds of the reflection
			bounds			= new Object();
			bounds.width	= eWidth;
			bounds.height	= eHeight;
			
			//create the BitmapData that will hold a snapshot of the movie clip
			elementBitmap	= new BitmapData(bounds.width, bounds.height, true, 0xffffff);
			elementBitmap.draw(element);
			
			//create the BitmapData the will hold the reflection
			reflectionBitmap			= new Bitmap(elementBitmap);
			reflectionBitmap.scaleY		= -1;
			reflectionBitmap.y			= (bounds.height*2) + obj.distance;
			reflectionBitmap.smoothing	= true;
			
			element.addChild(reflectionBitmap);
			element.addChild(gradientMask);
			
			//set the values for the gradient fill
			var fillType:String			= GradientType.LINEAR;
		 	var colors:Array			= [];
		 	colors[0]					= 0xFFFFFF;
		 	colors[1]					= 0xFFFFFF;
		 	
		 	var alphas:Array			= [];
		 	alphas[0]					= obj.alpha;
		 	alphas[1]					= 0;
		 	
		 	var ratios:Array			= [];
		 	ratios[0]					= 0;
		 	ratios[1]					= obj.ratio;
		 	
			var spreadMethod:String		= SpreadMethod.PAD;
			
			//create the Matrix and create the gradient box
		  	var matr:Matrix = new Matrix();
			var matrixHeight:Number;
			
			if (obj.reflectionDropoff <= 0) {
				matrixHeight = bounds.height;
			} else {
				matrixHeight = bounds.height/obj.reflectionDropoff;
			}
			
			matr.createGradientBox(bounds.width, matrixHeight, (90/180)*Math.PI, 0, 0);
			
			gradientMask.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);  
		    gradientMask.graphics.drawRect(0,0,bounds.width,bounds.height);
			
			//position the mask over the reflection clip			
			gradientMask.y = reflectionBitmap.y - reflectionBitmap.height;
			//cache clip as a bitmap so that the gradient mask will function
			gradientMask.cacheAsBitmap		= true;
			reflectionBitmap.cacheAsBitmap	= true;
			//set the mask for the reflection as the gradient mask
			reflectionBitmap.mask			= gradientMask;
			
			//if we are updating the reflection for a video or animation do so here
			if(obj.updateTime > -1){
				updateInt = setInterval(update, obj.updateTime, element);
			}
		}
		
		/** Allows the user to set the area that the reflection is allowed this is useful
		*	for clips that move within themselves
		**/
		public function setBounds(w:Number,h:Number):void{
			bounds.width = w;
			bounds.height = h;
			gradientMask.width = bounds.width;
			redrawBitmap(element);
		}
		
		/** Redraws the bitmap reflection - Mim Gamiet [2006] **/
		public function redrawBitmap(element:Sprite):void {
			elementBitmap.dispose();
			elementBitmap = new BitmapData(bounds.width, bounds.height, true, 0xFFFFFF);
			elementBitmap.draw(element);
		}
		
		/** Updates the reflection to visually match the movie clip. **/
		private function update(element:Element):void {
			elementBitmap = new BitmapData(bounds.width, bounds.height, true, 0xFFFFFF);
			elementBitmap.draw(element);
			reflectionBitmap.bitmapData = elementBitmap;
		}
		
		/** Kill the object and clean from memory. **/
		public function kill():void{
			element.removeChild(reflectionBitmap);
			element.removeChild(gradientMask);
			elementBitmap.dispose();
			
			clearInterval(updateInt);
			
			reflectionBitmap	= null;
			gradientMask		= null;
		}
	}
}
