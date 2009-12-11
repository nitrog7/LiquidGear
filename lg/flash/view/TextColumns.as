/**
* TextColumns by Giraldo Rosales.
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

package lg.flash.view {
	//LG
	import lg.flash.elements.Text;
	import lg.flash.elements.VisualElement;

	public class TextColumns extends VisualElement {
		private var _flow:TextFlow;
		private var _colWidth:Number	= 50;
		
		public function TextColumns(obj:Object) {
			data.text		= '';
			data.width		= 100;
			data.height		= 100;
			data.columns	= 2;
			data.font		= '_sans';
			data.embedFonts	= false;
			data.gutter		= 5;
			
			//Set Attributes
			for(var s:String in obj) {
				data[s]	= obj[s];
				
				if(s in this) {
					this[s] = obj[s];
				}
			}
			
			_flow	= new TextFlow();
			isSetup	= true;
			updateColumns();
		}
		
		/** Width, in pixels. 
		*	@default 100 **/
		public override function set width(value:Number):void {
			data.width	= value;
			_colWidth	= data.width / data.columns;
			updateColumns();
		}
		public override function get width():Number {
			return data.width;
		}
		
		/** Height, in pixels. 
		*	@default 100 **/
		public override function set height(value:Number):void {
			data.height	= value;
			updateColumns();
		}
		public override function get height():Number {
			return data.height;
		}
		
		/** Number of columns to create. 
		*	@default 2 **/
		public function set columns(value:int):void {
			data.columns	= value;
			_colWidth		= data.width / data.columns;
			updateColumns();
		}
		public function get columns():int {
			return data.columns;
		}
		
		/** Name of the embedded font class.  
		*	@default _sans **/
		public function set font(value:String):void {
			data.font	= value;
			updateColumns();
		}
		public function get font():String {
			return data.font;
		}
		
		/** Specifies whether to render by using embedded font outlines. 
		*	@default false **/
		public function set embedFonts(value:Boolean):void {
			data.embedFonts	= value;
			updateColumns();
		}
		public function get embedFonts():Boolean {
			return data.embedFonts;
		}
		
		/** Size of the gutter between columns in pixels. 
		*	@default 5 **/
		public function set gutter(value:Number):void {
			data.gutter	= value;
			updateColumns();
		}
		public function get gutter():Number {
			return data.gutter;
		}
		
		/** A string that is the current text in the TextField. **/
		public function set text(value:String):void {
			data.text	= value;
			updateColumns();
		}
		public function get text():String {
			return data.text;
		}
		
		/** @private **/
		private function updateColumns():void {
			if(!isSetup) {
				return;
			}
			
			//Clear existing fields
			var colLen:int	= children.length;
			var g:int;
			
			for(g=colLen-1; g>=0; g--) {
				removeChild(children[g]);
			}
			
			//Add new fields
			var txt:Text;
			
			for(g=0; g<data.columns; g++) {
				txt	= new Text({id:'column'+g, stage:stage, x:g*_colWidth, y:0, width:_colWidth - data.gutter, height:data.height, font:data.font, embedFonts:data.embedFonts, multiline:true, wordWrap:true});
				addChild(txt);
			}
			
			_flow.fields	= children;
			_flow.text		= data.text;
		}
	}
}