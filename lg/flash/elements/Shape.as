/**
* Shape by Giraldo Rosales.
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
	//Flash
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	
	//LG
	import lg.flash.events.ElementEvent;
	import lg.flash.elements.VisualElement;
	
	/**
	*	<p>Creates a shape.</p>
	*	<p>Quickly create a shape</p>
	*/
	public class Shape extends VisualElement {
		/** @private **/
		private var _gradMatrix:Matrix;
		/** @private **/
		private var _shape:Sprite	= new Sprite();
		/** @private **/
		private var _custom:Boolean	= false;
		
		/** <p>Constructs a new Shape object. Creates a shape using the graphic class.</p>
		*	@param obj Object containing all properties to construct the class.
		**/
		public function Shape(obj:Object=null) {
			super();
			
			addChild(_shape);
			cacheAsBitmap		= true;
			
			//Set defaults
			data.x				= 0;
			data.y				= 0;
			data.color			= 0x000000;
			data.shape			= 'rect';
			data.radius			= 5;
			data.fillAlpha		= 1;
			data.width			= 50;
			data.height			= 50;
			data.stretch		= true;
			data.colorAlpha		= 1;
			data.gradientAlpha	= 1;
			
			//Set Attributes
			setAttributes(obj);
			
			isSetup = true;
			create();
		}
		
		/** @private **/
		private function create():void {
			if(!isSetup || _custom) {
				return;
			}
			
			_shape.graphics.clear();
			
			if(data.lineWidth) {
				if(data.lineColor == undefined) {
					data.lineColor	= 0x000000;
				}
				if(data.lineAlpha == undefined) {
					data.lineAlpha	= 1;
				}
				if(data.lineScale == undefined) {
					data.lineScale	= null;
				}
				if(data.lineCaps == undefined) {
					data.lineCaps	= null;
				}
				
				_shape.graphics.lineStyle(data.lineWidth, data.lineColor, data.lineAlpha, data.lineScale, data.lineCaps);
			}
			
			if(data.gradientColor) {
				_gradMatrix	= new Matrix();
				_gradMatrix.createGradientBox(data.width, data.height, Math.PI/2, 0, 0);
				
				_shape.graphics.beginGradientFill('linear', [data.color, data.gradientColor], [data.colorAlpha, data.gradientAlpha], [0, 255], _gradMatrix);
			} else {
				_shape.graphics.beginFill(data.color, data.fillAlpha);
			}
			
			switch(data.shape.toLowerCase()) {
				case 'rect':
					_shape.graphics.drawRect(0, 0, data.width, data.height);
					break;
				case 'roundrect':
					_shape.graphics.drawRoundRect(0, 0, data.width, data.height, data.radius, data.radius);
					break;
				case 'circle':
					_shape.graphics.drawEllipse(0, 0, data.width, data.width);
					break;
				case 'ellipse':
					_shape.graphics.drawEllipse(0, 0, data.width, data.height);
					break;
			}
			
			_shape.graphics.endFill();
		}
		
		/** Fills a drawing area with a bitmap image. **/
		public function beginBitmapFill(bitmap:BitmapData, matrix:Matrix=null, repeat:Boolean=true, smooth:Boolean=false):void {
			_custom	= true;
			_shape.graphics.beginBitmapFill(bitmap, matrix, repeat, smooth);
		}
		
		/** Specifies a simple one-color fill that subsequent calls to other Shape methods (such as lineTo() or drawCircle()) use when drawing. **/
		public function beginFill(color:uint, alpha:Number=1):void {
			_custom	= true;
			_shape.graphics.beginFill(color, alpha);
		}
		
		/** Specifies a gradient fill that subsequent calls to other Shape methods (such as lineTo() or drawCircle()) use when drawing. **/
		public function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix=null, spreadMethod:String='pad', interpolationMethod:String='rgb', focalPointRatio:Number=0):void {
			_custom	= true;
			_shape.graphics.beginGradientFill(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
		}
		
		/** Clears the graphics that were drawn to this Graphics object, and resets fill and line style settings. **/
		public function clear():void {
			_shape.graphics.clear();
		}
		
		/** Draws a curve using the current line style from the current drawing position to (anchorX, anchorY) and using the control point that (controlX, controlY) specifies. **/
		public function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):void {
			_custom	= true;
			_shape.graphics.curveTo(controlX, controlY, anchorX, anchorY);
		}
		
		/** Draws a circle. **/
		public function drawCircle(x:Number, y:Number, radius:Number):void {
			_custom	= true;
			_shape.graphics.drawCircle(x, y, radius);
		}
		
		/** Draws an ellipse. **/
		public function drawEllipse(x:Number, y:Number, width:Number, height:Number):void {
			_custom	= true;
			_shape.graphics.drawEllipse(x, y, width, height);
		}
		
		/** Draws a rectangle. **/
		public function drawRect(x:Number, y:Number, width:Number, height:Number):void {
			_custom	= true;
			_shape.graphics.drawRect(x, y, width, height);
		}
		
		/** Draws a rounded rectangle. **/
		public function drawRoundRect(x:Number, y:Number, width:Number, height:Number, ellipseWidth:Number, ellipseHeight:Number = NaN):void {
			_custom	= true;
			_shape.graphics.drawRoundRect(x, y, width, height, ellipseWidth, ellipseHeight);
		}
		
		/** Applies a fill to the lines and curves that were added since the last call to the beginFill(), beginGradientFill(), or beginBitmapFill() method. **/
		public function endFill():void {
			_shape.graphics.endFill();
		}
		
		/** Specifies a gradient for the line style that subsequent calls to other Graphics methods (such as lineTo() or drawCircle()) use for drawing. **/
		public function lineGradientStyle(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix=null, spreadMethod:String='pad', interpolationMethod:String='rgb', focalPointRatio:Number=0):void {
			_custom	= true;
			_shape.graphics.lineGradientStyle(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
		}
		
		/** Specifies a line style that Flash uses for subsequent calls to other Graphics methods (such as lineTo() or drawCircle()) for the object. **/
		public function lineStyle(thickness:Number=NaN, color:uint=0, alpha:Number=1, pixelHinting:Boolean=false, scaleMode:String='normal', caps:String=null, joints:String=null, miterLimit:Number=3):void {
			_custom	= true;
			_shape.graphics.lineStyle(thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);
		}
		
		/** Draws a line using the current line style from the current drawing position to (x, y); the current drawing position is then set to (x, y). **/
		public function lineTo(x:Number, y:Number):void {
			_custom	= true;
			_shape.graphics.lineTo(x, y);
		}
		
		/** Moves the current drawing position to (x, y). **/
		public function moveTo(x:Number, y:Number):void {
			_custom	= true;
			_shape.graphics.moveTo(x, y);
		}
		
		/**	Color of the shape. **/
		public function get color():uint {
			return data.color;
		}		
		public function set color(value:uint):void {
			data.color	= value;
			create();
		}
		
		/**	Gradient color of the shape. 
		*	@default null **/
		public function get gradientColor():uint {
			return data.gradientColor;
		}		
		public function set gradientColor(value:uint):void {
			data.gradientColor	= value;
			create();
		}
		
		/**	Type of shape to create. Shapes include rect (rectangle), roundrect (rectangle with rounded corners), circle, and ellipse. default: rect. **/
		public function get shape():String {
			return data.shape;
		}		
		public function set shape(value:String):void {
			data.shape	= value;
			create();
		}
		
		/**	If creating a rectangle with rounded corners, you can specify the radius. 
		*	@default 5 **/
		public function get radius():Number {
			return data.radius;
		}		
		public function set radius(value:Number):void {
			data.radius	= value;
			create();
		}
		
		/**	Alpha of the fill. 
		*	@default 1**/
		public function get fillAlpha():Number {
			return data.fillAlpha;
		}		
		public function set fillAlpha(value:Number):void {
			data.fillAlpha	= value;
			create();
		}
		
		/**	Width of the border. **/
		public function get lineWidth():Number {
			return data.lineWidth;
		}		
		public function set lineWidth(value:Number):void {
			data.lineWidth	= value;
			create();
		}
		
		/**	Alpha value of the line. **/
		public function get lineAlpha():Number {
			return data.lineAlpha;
		}		
		public function set lineAlpha(value:Number):void {
			data.lineAlpha	= value;
			create();
		}
		
		/**	Scale mode of the line. options: horizontal, none, normal, vertical. **/
		public function get lineScale():String {
			return data.lineScale;
		}		
		public function set lineScale(value:String):void {
			data.lineScale	= value;
			create();
		}
		
		/**	Specifies the type of caps at the end of lines. options:none, round, square. **/
		public function get lineCaps():String {
			return data.lineCaps;
		}		
		public function set lineCaps(value:String):void {
			data.lineCaps	= value;
			create();
		}
		
		/** Indicates the width of the display object, in pixels. 
		*	@default 50 **/
		public override function get width():Number {
			return data.width;
		}		
		public override function set width(value:Number):void {
			data.width		= value;
			create();
		}
		
		/** Indicates the height of the display object, in pixels. 
		*	@default 50 **/
		public override function get height():Number {
			return data.height;
		}
		public override function set height(value:Number):void {
			data.height		= value;
			create();
		}
		
		/** Kill the object and clean from memory. **/
		public override function kill():void {
			_shape.graphics.clear();
			removeChild(_shape);
			_shape	= null;
			
			super.kill();
		}
	}
}