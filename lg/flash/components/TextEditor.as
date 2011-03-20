package lg.flash.components {
	//import fl.controls.ColorPicker;
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.ColorTransform;
	import flash.text.*;
	
	import lg.flash.elements.Text;
	import lg.flash.elements.VisualElement;
	import lg.flash.events.ElementEvent;
	
	public class TextEditor extends VisualElement {
		private var _format:TextFormat	= new TextFormat();
		private var _line:Array			= [];
		private var _list:Array			= [];
		
		private var tf:TextField;
		
		public function TextEditor(obj:Object) {
			holder();
			super.setAttributes(obj);
			
			//Text field
			tf						= new TextField();
			tf.type					= 'input';
			tf.width				= data.width;
			tf.height				= data.height;
			tf.embedFonts			= false;
			tf.useRichTextClipboard	= true;
			tf.background			= true;
			
			//Format
			_format.size			= 12;
			tf.setTextFormat(_format);
			addChild(tf);
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void {
			stage.focus = tf;
		}
		
		public function get text():String {
			return tf.text;
		}
		public function set text(value:String):void {
			tf.text	= value;
		}
		
		public override function set width(value:Number):void {
			if(tf) tf.width	= value;
		}
		public override function set height(value:Number):void {
			if(tf) tf.height	= value;
		}
		
		public function switchBlack():void {
			tf.textColor		= 0xffffff;
			tf.backgroundColor	= 0x000000;
		}
		public function switchWhite():void {
			tf.textColor		= 0x000000;
			tf.backgroundColor	= 0xffffff;
		}
		
		private function getParaLine(idx:int):String {
			var n : int;
			var s : String;
			
			n = tf.getFirstCharInParagraph(idx);
			s = tf.text.substring(n, n + tf.getParagraphLength(idx));
			
			return s;
		}
			
		private function getParaIndexFromCaret(idx:int):int {
			var list:Array;
			var g:int, n:int;
			
			list = tf.text.split('\r');
			
			for(g = 0; g<list.length; g++) {
				n += list[g].length;
				list[g] = {vText:list[g], vLength:n};
			}
			
			for(g=0; g<list.length; g++) {
				if (idx <= list[g].vLength) {
					break;
				}
			}
			
			return g;
		}
		
		private function setUI(txtFormat:TextFormat):void {
			var g:int, idx:int;
			var list:Array;
			var s:String;
			
			if (txtFormat.font != null) {
				s = txtFormat.font == "_sans" ? "Arial" : txtFormat.font;
				//cxOption_Font.selectedIndex = comboItemToIndex(cxOption_Font, s);
			}
			
			idx = tf.caretIndex;
			
			if (tf.caretIndex == tf.length) {
				idx -= 1;
			}
			/*
			if (txtFormat.size != null)
				cxOption_Size.selectedIndex = comboItemToIndex(cxOption_Size, txtFormat.size);
			cbOption_Underline.selected = txtFormat.underline;
			cbOption_Bold.selected = txtFormat.bold;
			cbOption_Italic.selected = txtFormat.italic;
			cpOption_Color.selectedColor = parseInt(String(txtFormat.color));
			*/
			list = tf.text.split('\r');
			
			for(g=0; g<list.length; g++) {
				if (list[g].replace(/\s+/g, '') == getParaLine(idx).replace(/\s+/g, '')) {	
					break;
				}
			}
			
			//this['rbAlign_' + getLineAlign(tf.htmlText, g)].selected = true;
		}
		/*
		private function getLineAlign(vHtml:String, lineNum:int):String {
			var prefix:String, s:String, t:String;
			
			t = vHtml.split("</P>")[lineNum];
			
			prefix = t.substring(0, t.indexOf("<P ALIGN", 0));
			s		= t.substring(prefix.length, t.indexOf("<FONT", 0));
			
			switch (s.toUpperCase()) {
				case "<P ALIGN=\"LEFT\">":
					s = "Left";
					break;
				case "<P ALIGN=\"CENTER\">":
					s = "Center";
					break;
				case "<P ALIGN=\"RIGHT\">":
					s = "Right";
					break;
			}
			
			return s;
		}
		*/
		/*
		private function setLineAlign(vParaN:int, alignment:String):void {
			var g:int;
			var list:Array;
			
			var txt:String		= tf.htmlText;
			var prefix:String	= txt.substring(0, txt.indexOf('<P ALIGN', 0));
			list				= txt.split('</P>');
			
			txt					= list[vParaN];
			var edit:String		= txt.substring(txt.indexOf('<FONT', 0), txt.length);
			txt					= prefix + '<P ALIGN="' + alignment.toUpperCase() + '">' + edit;
			edit				= '';
			
			for(g=0; g<list.length; g++) { 
				if (list[g] != '') {
					edit	+= ((g == vParaN ? txt : list[g]) + '</P>');
				}
			}
			
			if (edit.substr( -17) == '</TEXTFORMAT></P>') {			
				edit	= edit.substring(0, edit.length - 4);
			}
			
			tf.htmlText	= edit;
		}
		*/
		/*
		private function getLinePrefix(lineNum:int):int {
			var g:int, num:int;
			
			for (g=0; g<lineNum; g++) { 
				num += tf.getLineLength(g);
			}
			
			return num;
		}
		*/
		//public function onUpdateText(e:TextEvent):void {
			/*
			_format				= new TextFormat();
			_format.underline	= cbOption_Underline.selected;
			_format.bold		= cbOption_Bold.selected;
			_format.italic		= cbOption_Italic.selected;
			_format.size		= cxOption_Size.selectedItem.data;
			_format.font		= cxOption_Font.selectedItem.data;
			_format.color		= cpOption_Color.selectedColor;
			*/
		//	if (tf.caretIndex - 1 != -1) {
		//		tf.setTextFormat(_format, tf.caretIndex - 1, tf.caretIndex);
		//	}
		//}
		
		public function updateFormat(e:ElementEvent=null):void {
			var btn:VisualElement	= e.target as VisualElement;
			
			_list[0] = tf.selectionBeginIndex;
			_list[1] = tf.selectionEndIndex;
			
			tf.setSelection(_list[0], _list[1]);
			
			if (_list[0] == _list[1]) {
				return;
			}
			
			_format = tf.getTextFormat(_list[0], _list[1]);
			
			switch (btn.id.substring(btn.id.lastIndexOf('_') + 1, btn.id.length).toLowerCase()) {
				case 'underline':
					_format.underline	= !_format.underline;
					break;
				case "bold":
					_format.bold		= !_format.bold;
					break;
				case "italic":
					_format.italic		= !_format.italic;
					break;
				case "size":
					_format.size		= btn.data.value;
					break;
				case "font":
					_format.font		= btn.data.value;
					break;
				case "color":
					_format.color		= btn.data.value;
					break;
			}
			
			tf.setTextFormat(_format, _list[0], _list[1]);
			stage.focus = tf;
		}
	}
}