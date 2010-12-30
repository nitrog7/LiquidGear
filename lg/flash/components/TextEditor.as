package lg.flash.components {
	//import fl.controls.ColorPicker;
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.*;
	
	import flashx.textLayout.edit.SelectionManager;
	import flashx.textLayout.elements.TextFlow;
	
	import lg.flash.elements.Text;
	import lg.flash.elements.VisualElement;
	import lg.flash.events.ElementEvent;
	
	public class TextEditor extends VisualElement {
		/*
		private var underline	= cbOption_Underline.selected;
		public var bold		= cbOption_Bold.selected;
		_format.italic		= cbOption_Italic.selected;
		_format.size		= cxOption_Size.selectedItem.data;
		_format.font		= cxOption_Font.selectedItem.data;
		_format.color
		*/
		private var _fontSizeStart:int	= 8;
		private var _fontSizeEnd:int	= 20;
		
		private var _format:TextFormat;
		private var _list:Array		= [];
		private var _line:Array		= [];
		private var xColorPickerOpen:Boolean;
		
		private var tf:TextField;
		
		public function TextEditor(obj:Object) {
			holder();
			super.setAttributes(obj);
			
			//Text field
			tf			= new TextField();
			tf.width	= data.width;
			tf.height	= data.height;
			addChild(tf);
			
			var i : int;
			var list:Array;
			/*
			addEventListener(Event.CHANGE, xfOnEvent, false, 0, true);
			addEventListener(MouseEvent.MOUSE_DOWN, xfOnEvent, false, 0, true);
			addEventListener(MouseEvent.CLICK, xfOnEvent, false, 0, true);
			*/
			
			if (stage != null) {
				stage.addEventListener(MouseEvent.MOUSE_UP, xfOnEvent, false, 0, true);
			}
			
			addEventListener(MouseEvent.MOUSE_MOVE, xfOnEvent, false, 0, true);
			addEventListener(KeyboardEvent.KEY_UP, xfOnEvent, false, 0, true);
			//cxOption_Size.addEventListener(Event.CHANGE, xfOnEvent, false, 0, true);
			//cxOption_Font.addEventListener(Event.CHANGE, xfOnEvent, false, 0, true);
			
			list = Font.enumerateFonts(true);
			list.sort();
			
			/*
			for (i = 0; i < list.length; i++) { 
				cxOption_Font.addItem( { label: list[i].fontName, data: list[i].fontName } );
			}
			
			for (i = _fontSizeStart; i < _fontSizeEnd + 1; i++) {
				cxOption_Size.addItem( { label: i, data: i } );
			}
			*/
			
			tf.embedFonts			= false;
			tf.useRichTextClipboard	= true;
			
			if (stage != null) {
				stage.focus = tf;
			}
			
			if(tf.text != '') {
				tf.setSelection(tf.length, tf.length);
				setUI(tf.getTextFormat(tf.length - 1, tf.length));
			}
		}
		
		public function get text():String {
			return tf.text;
		}
		public function set text(value:String):void {
			tf.text	= value;
		}
		/*
		public function setBold():void {
			var textflow:TextFlow		= super.textFlow;
			var sel:SelectionManager	= textFlow.interactionManager as SelectionManager;
			
			if(!sel.hasSelection()) {
				return;
			}
			
			var str:String		= super.htmlText;
			var begin:String	= str.slice(0, sel.absoluteStart);
			var edit:String		= str.slice(sel.absoluteStart, sel.absoluteEnd);
			var end:String		= str.slice(sel.absoluteEnd, str.length);
			var update:String	= begin+'<b>'+edit+'</b>'+end;
			
			super.htmlText		= update;
			trace(sel.absoluteStart, sel.absoluteEnd, super.htmlText);
		}
		*/
		
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
			
			this['rbAlign_' + getLineAlign(tf.htmlText, g)].selected = true;
		}
		
		private function comboItemToIndex(combo:*, item:Object):int {
			var g:int;
			
			for(g=0; g<combo.length; g++) {
				if(combo.getItemAt(g).data.toString() == item.toString()) {
					return g;
				}
			}
			
			return -1;
		}
		
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
		
		private function getLinePrefix(lineNum:int):int {
			var g:int, num:int;
			
			for (g=0; g<lineNum; g++) { 
				num += tf.getLineLength(g);
			}
			
			return num;
		}
		
		protected function xfOnEvent(e:*):void {
			var i:int, j:int, n:int;
			var vTarget:*;
			var list:Array;
			
			vTarget = e.target;
			
			switch (e.type) {
				case MouseEvent.MOUSE_MOVE:
					e.updateAfterEvent();	// for extra smoothing
					break;
				case KeyboardEvent.KEY_UP:
				case MouseEvent.MOUSE_UP:
					_list[0] = tf.selectionBeginIndex;
					_list[1] = tf.selectionEndIndex;
					_line[0] = tf.getLineIndexOfChar(_list[0] == tf.length ? _list[0] - 1 : _list[0]);
					_line[1] = tf.getLineIndexOfChar(_list[1] == tf.length ? _list[1] - 1 : _list[1]);
					_line.sort(Array.NUMERIC);
					_list.sort(Array.NUMERIC);
					
					if (_list[0] == _list[1]) {			
						_list[0] -= 1;				
						if (_list[0] == -1) {
							_list[0] = 0;
							return;
						}
						
						_format = tf.getTextFormat(_list[0], _list[1]);		
						_list[0] += 1;
					} else {
						_format = tf.getTextFormat(_list[0], _list[0] + 1);
					}
					/*
					if (vTarget.parent is ColorPicker) {
						xColorPickerOpen = true;
					}
					
					if (!xColorPickerOpen) {
						setUI(_format);
					}
					*/
					break;
				
				case MouseEvent.CLICK:
					/*
					if (vTarget.name.substring(0, 8) == "rbAlign_") {		
						for(g=_line[0]; g<_line[1] + 1; g++) {
							setLineAlign(getParaIndexFromCaret(getLinePrefix(g)), vTarget.name.substring(vTarget.name.lastIndexOf('_') + 1, vTarget.name.length));
						}
						
						stage.focus = tf;
						tf.setSelection(_list[0], _list[1]);
					}
					*/
					break;		
			}
			
			trace(tf.htmlText);
		}
		
		public function onUpdateText(e:TextEvent):void {
			/*
			_format				= new TextFormat();
			_format.underline	= cbOption_Underline.selected;
			_format.bold		= cbOption_Bold.selected;
			_format.italic		= cbOption_Italic.selected;
			_format.size		= cxOption_Size.selectedItem.data;
			_format.font		= cxOption_Font.selectedItem.data;
			_format.color		= cpOption_Color.selectedColor;
			*/
			if (tf.caretIndex - 1 != -1) {
				tf.setTextFormat(_format, tf.caretIndex - 1, tf.caretIndex);
			}
		}
		
		public function onOptionChange(e:ElementEvent):void {
			var btn:VisualElement	= e.target as VisualElement;
			
			if (btn.id.substring(2, btn.id.lastIndexOf('_')) == 'Option') {
				stage.focus = tf;
				tf.setSelection(_list[0], _list[1]);
				
				if (_list[0] == _list[1]) {
					return;
				}
				
				_format = new TextFormat();
				_format = tf.getTextFormat(_list[0], _list[1]);
				
				switch (btn.id.substring(btn.id.lastIndexOf('_') + 1, btn.id.length).toLowerCase()) {
					case 'underline':
						_format.underline	= '';//btn.selected;
						break;
					case "bold":
						_format.bold		= '';//btn.selected;
						break;
					case "italic":
						_format.italic		= '';//btn.selected;
						break;
					case "size":
						_format.size		= '';//btn.selectedItem.data;
						break;
					case "font":
						_format.font		= '';//btn.selectedItem.data;
						break;
					case "color":
						_format.color		= '';//btn.selectedColor;
						break;
				}
				
				tf.setTextFormat(_format, _list[0], _list[1]);
				xColorPickerOpen = false;			
			}
		}
	}
}