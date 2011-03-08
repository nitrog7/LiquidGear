/**
 * Text by Giraldo Rosales.
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
	//Text Layout Framework
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.edit.EditManager;
	import flashx.textLayout.edit.SelectionManager;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.undo.UndoManager;
	
	import lg.flash.events.ElementEvent;
	import lg.flash.motion.Tween;
	import lg.flash.motion.easing.Quint;
	
	/**
	 * Dispatched when the text scrolls up or down.
	 * @eventType mx.events.ElementEvent.SCROLL
	 */
	[Event(name="element_scroll", type="lg.flash.events.ElementEvent")]
	
	/**
	 * Dispatched when the text is submitted.
	 * @eventType mx.events.ElementEvent.SUBMIT
	 */
	[Event(name="element_submit", type="lg.flash.events.ElementEvent")]
	
	public class Text extends VisualElement {
		public var textfield:TextField						= new TextField();
		public var format:TextFormat						= new TextFormat();
		
		/** 
		 *	Constructs a new Text object.
		 *	@param obj Object containing all properties to construct the class	
		 **/
		public function Text(obj:Object) {
			super();
			holder();
			
			data.align				= 'left';
			data.backgroundColor	= 0xffffff;
			data.bold				= false;
			data.color				= 0x000000;
			data.embedFonts			= false;
			data.font				= 'device';
			data.ignoreWhitespace	= false;
			data.input				= false;
			data.italic				= false;
			data.size				= 12;
			data.htmlText			= null;
			data.text				= '';
			data.underline			= false;
			
			textfield.antiAliasType	= 'advanced';
			textfield.gridFitType	= 'pixel';
			textfield.type			= 'dynamic';
			textfield.autoSize		= 'left';
			textfield.selectable	= false;
			
			addChild(textfield);
			setAttributes(obj);
			
			isSetup = true;
			resetFormat();
		}
		
		private function resetFormat():void {
			if(!isSetup) {
				return;
			}
			
			textfield.setTextFormat(format);
			textfield.defaultTextFormat	= format;
		}
		
		public function get text():String {
			return data.text;
		}
		public function set text(value:String):void {
			data.text		= value;
			textfield.text	= value;
			//resetFormat();
		}
		
		public function get htmlText():String {
			return data.htmlText;
		}
		public function set htmlText(value:String):void {
			data.htmlText		= value;
			textfield.htmlText	= value;
		}
		
		public function get align():String {
			return data.align;
		}
		public function set align(value:String):void {
			data.align		= value.toLowerCase();
			format.align	= data.align;
			
			if(value == 'left') {
				textfield.gridFitType	= 'pixel';
			} else {
				textfield.gridFitType	= 'subpixel';
			}
			
			resetFormat();
		}
		
		public function get backgroundColor():uint {
			return data.backgroundColor;
		}
		public function set backgroundColor(value:uint):void {
			data.backgroundColor		= value;
			textfield.background		= true;
			textfield.backgroundColor	= value;
		}
		
		public function get bold():Boolean {
			return data.bold;
		}
		public function set bold(value:Boolean):void {
			data.bold	= value;
			format.bold	= value;
			resetFormat();
		}
		
		public function get color():uint {
			return data.color;
		}
		public function set color(value:uint):void {
			data.color		= value;
			format.color	= value;
			resetFormat();
		}
		
		public function get embedFonts():Boolean {
			return data.embedFonts;
		}
		public function set embedFonts(value:Boolean):void {
			data.embedFonts			= value;
			textfield.embedFonts	= value;
			resetFormat();
		}
		
		public function get font():String {
			return data.font;
		}
		public function set font(value:String):void {
			data.font	= value;
			format.font	= value;
			resetFormat();
		}
		
		public function get italic():Boolean {
			return data.italic;
		}
		public function set italic(value:Boolean):void {
			data.italic		= value;
			format.italic	= value;
			resetFormat();
		}
		
		public function get ignoreWhitespace():Boolean {
			return data.ignoreWhitespace;
		}
		public function set ignoreWhitespace(value:Boolean):void {
			data.ignoreWhitespace	= value;
			textfield.condenseWhite	= value;
		}
		
		public function get input():Boolean {
			return data.input;
		}
		public function set input(value:Boolean):void {
			data.input	= value;
			
			if(value) {
				textfield.type	= 'input';
			} else {
				textfield.type	= 'dynamic';
			}
			resetFormat();
		}
		
		public function get selectable():Boolean {
			return data.selectable;
		}
		public function set selectable(value:Boolean):void {
			data.selectable			= value;
			textfield.selectable	= value;
		}
		
		public function get size():Number {
			return data.size;
		}
		public function set size(value:Number):void {
			data.size	= value;
			format.size	= value;
			resetFormat();
		}
		
		public function get underline():Boolean {
			return data.underline;
		}
		public function set underline(value:Boolean):void {
			data.underline		= value;
			format.underline	= value;
			resetFormat();
		}
		public function get textWidth():Number {
			return textfield.textWidth;
		}
		public function get textHeight():Number {
			return textfield.textHeight;
		}
		
		public override function get width():Number {
			return textfield.width;
		}
		public override function set width(value:Number):void {
			data.width		= value;
			
			if(isSetup) {
				if(stretch) {
					super.width			= value;
				} else {
					textfield.autoSize	= 'none';
					textfield.width		= value;
					
					if(isNaN(data.height)) {
						textfield.height	= textfield.textHeight;
					}
				}
			}
		}
		
		public override function set height(value:Number):void {
			data.height		= value;
			
			if(isSetup) {
				if(stretch) {
					super.height		= value;
				} else {
					textfield.autoSize	= 'none';
					textfield.height	= value;
					
					if(isNaN(data.width)) {
						textfield.width	= textfield.textWidth;
					}
				}
			}
		}
		public override function get height():Number {
			return textfield.height;
		}
		
		/** Kill the object and clean from memory. **/
		public override function kill():void {
			format		= null;
			
			if(textfield && contains(textfield)) {
				removeChild(textfield);
				textfield	= null;
			}
			
			super.kill();
		}
	}
}