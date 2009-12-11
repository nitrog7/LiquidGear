/**
* GDS: list of known issues:
* - orphans doesn't seem to be working properly.
* - problems with setting the caret to the end of a line or on an empty line.
* - caret draws at end of last textfield if there is an overflow.
* - up/down arrow behaviour is (understandably) weird... paragraph at a time currently (because of nowrap).
* - double click to select word doesn't work.
* - right click menu operations don't work (and probably never will).
*
* Possible enhancements:
* - add caretIndex?
**/


/**
* TextFlow by Grant Skinner. Sep 9, 2007
* Major revisions Jan 14, 2009
* Visit www.gskinner.com/blog for documentation, updates and more free code.
*
* Modified by Giraldo Rosales
* For integration in LiquidGear
*
* Copyright (c) 2007 Grant Skinner
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
	//Flash
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	//LG
	import lg.flash.elements.Text;
	
	public class TextFlow {
		/** @private **/
		private static var caret:Sprite;
		/** @private **/
		private static var caretCount:int	= 0;
		/** @private **/
		private var ghost:TextField;
		/** @private **/
		private var dragProps:Object		= {};
		/** @private **/
		private var _entries:Array			= [];
		/** @private **/
		private var _fields:Array			= [];
		/** @private **/
		private var _alwaysShow:Boolean		= false;
		/** @private **/
		private var _orphans:int			= 1;
		/** @private **/
		private var _widows:int				= 2;
		/** @private **/
		private var _type:String			= 'input';
		/** @private **/
		private var _input:Boolean			= true;
		
		public function TextFlow(textFields:Array=null) {
			if(caret == null) {
				caret			= new Sprite();
				caret.blendMode	= 'difference';
				caret.graphics.lineStyle(1, 0x000000, 1, true, 'none', 'none');
				caret.graphics.lineTo(0,100);
			}
			
			_entries		= [];
			
			ghost			= new TextField();
			ghost.type		= _type;
			ghost.multiline	= true;
			ghost.width		= 0;
			ghost.height	= 0;
			ghost.alwaysShowSelection	= _alwaysShow;
			
			ghost.addEventListener(FocusEvent.FOCUS_OUT, handleGhostEvent, false, 0, true);
			ghost.addEventListener(Event.CHANGE, handleGhostEvent, false, 0, true);
			ghost.addEventListener(KeyboardEvent.KEY_DOWN, handleGhostEvent, false, 0, true);
			
			if(textFields) {
				fields	= textFields;
			}
		}
		
		/** @private **/
		private function updateText():void {
			if (_entries.length == 0) {
				return;
			}
			
			var l:int				= _entries.length;
			var lastIndex:Number	= 0;
			var txt:String			= ghost.text;
			var sub:String;
			var prev:Text;
			var trim:int;
			
			for (var i:int=0; i<l; i++) {
				var entry:Text			= _entries[i] as Text;
				entry.data.endIndex		= lastIndex;
				entry.data.beginIndex	= lastIndex;
				entry.data.trim			= 0;
				entry.text				= '';
				
				if (lastIndex >= txt.length) {
					continue;
				}
			
				sub	= txt.substr(lastIndex);
				
				if (i > 0) {
					entry.text				= ltrim(sub);
					trim					= sub.length - entry.text.length;
					lastIndex				+= trim;
					entry.data.beginIndex	= lastIndex;
					
					prev					= _entries[i-1] as Text;
					prev.data.trim			+= trim;
				} else {
					entry.text = sub;
				}
				
				//Find end
				entry.scrollV = 0;
				
				var nextLineIndex:int	= entry.bottomScrollV;
				
				//Use try/catch to find when we've reached the end of our text (maxScrollV is unreliable):
				try {
					var offset:int		= entry.textField.getLineOffset(nextLineIndex);
				} catch (e:*) {
					entry.data.endIndex = lastIndex = txt.length;
					continue;
				}
				
				if(_orphans > 1 && _widows > 1) {
					//Find start and end line index of last paragraph in field:
					var pBegin:int	= entry.textField.getLineIndexOfChar(entry.textField.getFirstCharInParagraph(offset));
					var pEnd:int	= entry.textField.getLineIndexOfChar(entry.textField.getFirstCharInParagraph(offset)+entry.textField.getParagraphLength(offset));
					
					//Check if the paragraph straddles the field break:
					if (pEnd > nextLineIndex && pBegin < nextLineIndex) {
						if((nextLineIndex-pbegin) < _orphans) {
							offset	= entry.textField.getFirstCharInParagraph(offset);
						}
						//Need to grab at least widows lines, +1 gets rid of leading space
						else if ((pend-nextLineIndex) < _widows) {
							offset	= entry.textField.getLineOffset(pend-_widows);
						}
					}
				}
				
				sub				= entry.text.substr(0,offset)
				entry.text		= rtrim(sub);
				entry.data.trim	= sub.length - entry.text.length;
				
				lastIndex			+= entry.text.length;
				entry.data.endIndex	= lastIndex;
				lastIndex			+= entry.data.trim;
			}
			
			lastIndex	= 0;
			setSelection(ghost.selectionBeginIndex,ghost.selectionEndIndex);
		}
		
		/** Clear the current selection **/
		public function clearSelection():void {
			for (var i:int=0; i<_entries.length; i++) {
				var fld:TextField = _entries[i].textField;
				fld.setSelection(0,0);
			}
			
			ghost.setSelection(0,0);
			
			if(caret.parent != null) {
				caret.parent.removeChild(caret);
			}
			
			if(ghost.stage.focus == ghost) {
				ghost.stage.focus = null;
			}
		}
		
		/** Sets as selected the text designated by the index values of the first and last characters, which are specified with the beginIndex and endIndex parameters. **/
		public function setSelection(beginIndex:int, endIndex:int):void {
			var beginFldObj:Object	= getFlowIndex(beginIndex);
			var endFldObj:Object	= getFlowIndex(endIndex);
			
			setFlowSelection(beginFldObj.fieldIndex,beginFldObj.index,endFldObj.fieldIndex,endFldObj.index);
			ghost.setSelection(beginIndex,endIndex);
		}
		
		/** @private **/
		private function getOverflow(textFieldIndex:int=-1, ltrimString:Boolean=true):String {
			if (textFieldIndex < 0) {
				textFieldIndex = _entries.length+textFieldIndex;
			}
			
			var txt:Text	= _entries[textFieldIndex] as Text;
			var str:String	= ghost.text.substr(txt.data.endIndex);
			var fStr:String	= (ltrimString) ? ltrim(str) : str;
			return fStr;
		}
		
		/** When set to true and the text field is not in focus, Flash Player highlights the selection in the text field in gray. **/
		public function set alwaysShowSelection(value:Boolean):void {
			if (ghost != null) {
				ghost.alwaysShowSelection	= value;
			}
			
			_alwaysShow	= value;
		}
		public function get alwaysShowSelection():Boolean {
			return _alwaysShow;
		}
		
		/** Indicates whether or not the text functions as an input, which a user can edit the text. 
		*	@default false **/
		public function set input(value:Boolean):void {
			if(value) {
				_type	= 'input';
			} else {
				_type	= 'dynamic';
			}
			
			_input	= value;
			
			if (ghost) {
				ghost.type = _type;
			}
		}
		public function get input():Boolean {
			return _input;
		}
		
		/** A string that is the current text in the TextField. **/
		public function get text():String {
			return ghost.text;
		}
		public function set text(value:String):void {
			ghost.text	= value;
			updateText();
		}
		
		public function get selectionBeginIndex():int {
			return ghost.selectionBeginIndex;
		}
		
		public function get selectionEndIndex():int {
			return ghost.selectionEndIndex;
		}
		
		
		public function set tabIndex(value:int):void {
			ghost.tabIndex = value;
		}
		public function get tabIndex():int {
			return ghost.tabIndex;
		}
		
		/** Add Text objects to the flow. **/
		public function set fields(value:Array):void {
			//Clean up old textfields, and restore them to their original state.
			while(_entries.length > 0) {
				var entry:Text				= _entries.pop();
				
				if(!entry.data) {
					continue;
				}
				
				entry.selectable			= entry.data.orgSelectable;
				delete(entry.data.orgSelectable);
				entry.input					= entry.data.orgInput;
				delete(entry.data.orgInput);
				entry.alwaysShowSelection	= entry.data.orgAlways;
				delete(entry.data.orgAlways);
				
				entry.textField.removeEventListener(MouseEvent.MOUSE_DOWN, handleFlowEvent);
			}
			
			_fields			= [];
			var valLen:int	= value.length;
			var txt:Text;
			
			//Set up new fields
			for(var g:int=0; g<valLen; g++) {
				txt	= value[g] as Text;
				
				if(txt == null) {
					continue;
				}
				
				_fields.push(txt);
				_entries.push(txt);
				
				//Set up field for flowing
				txt.data.orgAlways		= txt.alwaysShowSelection;
				txt.alwaysShowSelection = true;
				txt.data.orgSelectable	= txt.selectable;
				txt.selectable			= false;
				txt.data.orgInput		= txt.input;
				txt.input				= false;
				
				txt.textField.addEventListener(MouseEvent.MOUSE_DOWN, handleFlowEvent, false, 0, true);
			}
			
			//Add the ghost to the parent of the first textField
			if(ghost.stage == null && _entries.length > 0) {
				_fields[0].stage.addChild(ghost);
				ghost.stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, handleGhostEvent, false, 0, true);
			}
			
			updateText();
		}
		
		public function get fields():Array {
			return _fields;
		}
		
		/** @private **/
		private function handleFlowEvent(e:MouseEvent):void {
			var targetFld:TextField = e.target as TextField;
			
			if (e.type == MouseEvent.MOUSE_DOWN) {
				// start watching for a drag operation:
				ghost.stage.addEventListener(MouseEvent.MOUSE_MOVE,handleFlowEvent,false,0,true);
				ghost.stage.addEventListener(MouseEvent.MOUSE_UP,handleFlowEvent,false,0,true);
				
				// figure out where the press happened:
				var index:int		= getCharIndexAtPoint(targetFld,new Point(e.localX,e.localY));
				var fldIndex:int	= getFieldIndex(targetFld);
				
				if (e.shiftKey) {
					// make the selection, and prep for the drag:
					var flowIndex:Object = getFlowIndex(ghost.selectionBeginIndex);
					dragProps={fld:_entries[flowIndex.fieldIndex].textField,fldIndex:flowIndex.fieldIndex,selectionIndex:flowIndex.index};
					setFlowSelection(flowIndex.fieldIndex,flowIndex.index,fldIndex,index);
				} else {
					// set the caret, and prep for the drag:
					dragProps = {fld:targetFld, fldIndex:getFieldIndex(targetFld), selectionIndex:index};
					setFlowSelection(fldIndex,index,fldIndex,index);
				}
				
			} else if (e.type == MouseEvent.MOUSE_UP) {
				// drag ended:
				ghost.stage.removeEventListener(MouseEvent.MOUSE_MOVE,handleFlowEvent);
				ghost.stage.removeEventListener(MouseEvent.MOUSE_UP,handleFlowEvent);
				
			} else if (e.type == MouseEvent.MOUSE_MOVE) {
				// drag moved:
				var selectionIndex:int = -1;
				var fld:TextField;
				
				// start from last fld and move backwards, trying to find furthest selection:
				for (var i:int = _entries.length-1; i>=0; i--) {
					fld = _entries[i].textField;
					
					if (fld.mouseX > 0 && fld.mouseY > 0) {
						selectionIndex = getCharIndexAtPoint(fld,new Point(fld.mouseX,fld.mouseY));
						setFlowSelection(dragProps.fldIndex,dragProps.selectionIndex,i,selectionIndex);
						e.updateAfterEvent();
						break;
					}
				}
				
				if (selectionIndex == -1) {
					// we dragged up or left of all fields. Find the point relative to the first field:
					var lineIndex:int = Math.max(0,fld.getLineIndexAtPoint(2,Math.min(fld.height - 2, fld.mouseY)));
					selectionIndex = Math.max(0,fld.getLineOffset(lineIndex));
					setFlowSelection(dragProps.fldIndex,dragProps.selectionIndex,0,selectionIndex);
				}
			}
		}
		
		/** @private **/
		private function setFlowSelection(beginTextFieldIndex:int, beginCharacterIndex:int, endTextFieldIndex:int, endCharacterIndex:int):void {
			clearSelection();
			ghost.stage.focus = ghost;
			
			if (beginTextFieldIndex == endTextFieldIndex && beginCharacterIndex == endCharacterIndex) {
				setFlowCaret(beginTextFieldIndex, beginCharacterIndex);
				return;
			}
			
			// swap field and character indexes if the fields are in the wrong order (to allow reverse selections):
			if (beginTextFieldIndex > endTextFieldIndex) {
				var tmp:int			= endTextFieldIndex;
				endTextFieldIndex	= beginTextFieldIndex;
				beginTextFieldIndex	= tmp;
				tmp					= endCharacterIndex;
				endCharacterIndex	= beginCharacterIndex;
				beginCharacterIndex	= tmp;
			}
			
			var beginFld:TextField	= _entries[beginTextFieldIndex].textField;
			var endFld:TextField	= (_entries[endTextFieldIndex] as Text).textField;
			
			if (beginTextFieldIndex == endTextFieldIndex) {
				// single field selection.
				beginFld.setSelection(beginCharacterIndex, endCharacterIndex );
			} else {
				// multi field selection.
				beginFld.setSelection( beginCharacterIndex, beginFld.text.length );
				endFld.setSelection( 0, endCharacterIndex );
				for (var i:int=beginTextFieldIndex+1; i<endTextFieldIndex; i++) {
					var fld:TextField = _entries[i].textField;
					fld.setSelection(0,fld.text.length);
				}
			}
			
			// set the ghost selection:
			ghost.setSelection(getGhostIndex(beginTextFieldIndex,beginCharacterIndex) , getGhostIndex(endTextFieldIndex,endCharacterIndex));
		}
		
		/** @private **/
		private function setFlowCaret(textFieldIndex:int, characterIndex:int):void {
			var ghostIndex:int	= getGhostIndex(textFieldIndex,characterIndex);
			
			ghost.setSelection(ghostIndex,ghostIndex);
			
			if (ghost.stage.focus != ghost) {
				return;
			}
			var txt:Text				= _entries[textFieldIndex] as Text;
			var fld:TextField			= txt.textField;
			var charBounds:Rectangle	= fld.getCharBoundaries(characterIndex);
			var widthMult:Number		= 0;
			
			//Deal with carriage returns (they return null charBounds):
			while(charBounds == null && characterIndex >= 0) {
				charBounds	= fld.getCharBoundaries(--characterIndex);
				widthMult	= 1;
			}
			
			if (charBounds == null) {
				//trace("Error occurred. Unable to get character bounds for character ("+characterIndex+ ") of textField ("+textFieldIndex+")");
				return;
			}
			
			//Need to use matrix values to get around a bug with text fields created in authoring:
			caret.x			= fld.transform.matrix.tx + charBounds.x + charBounds.width*widthMult;
			caret.y			= fld.transform.matrix.ty + charBounds.y;
			caret.height	= charBounds.height;
			caret.addEventListener(Event.ENTER_FRAME,handleCaretEvent);
			fld.parent.addChildAt(caret,fld.parent.getChildIndex(fld)+1);
		}
		
		/** @private **/
		private function handleGhostEvent(e:Event):void {
			if (e.type == FocusEvent.FOCUS_OUT) {
				if (!_alwaysShow) { clearSelection(); }
			} else if (e.type == FocusEvent.KEY_FOCUS_CHANGE) {
				if ((e as FocusEvent).relatedObject == ghost) {
					// select all:
					setSelection(0,ghost.text.length);
				}
			} else if (e.type == Event.CHANGE) {
				text = ghost.text;
			} else if (e.type == KeyboardEvent.KEY_DOWN) {
				var keyCode:int = (e as KeyboardEvent).keyCode;
				// only worry about nav keys and cmd/ctrl-a
				if ((keyCode >= 33 && keyCode <= 40) || (keyCode==65 && (e as KeyboardEvent).ctrlKey)) {
					ghost.addEventListener(Event.ENTER_FRAME,handleGhostEvent,false,0,true);
					// reset caret blinking, so it doesn't disappear while using arrow keys.
					caretCount = 0;
				}
			} else if (e.type == Event.ENTER_FRAME) {
				ghost.removeEventListener(Event.ENTER_FRAME,handleGhostEvent);
				setSelection(ghost.selectionBeginIndex,ghost.selectionEndIndex);
			}
		}
		
		/** @private **/
		private function handleCaretEvent(e:Event):void {
			caretCount++;
			// blink 3 times per second:
			if (caretCount == Math.ceil(ghost.stage.frameRate/3)) {
				caret.visible = !caret.visible;
				caretCount = 0;
			}
		}
		
		/** @private **/
		private function getGhostIndex(textFieldIndex:int,characterIndex:int):int {
			return (textFieldIndex > 0) ? characterIndex+_entries[textFieldIndex-1].data.endIndex : characterIndex;
		}
		
		/** @private **/
		private function getFlowIndex(index:int):Object {
			for (var i:int=0; i<_entries.length; i++) {
				var entry:Text = (_entries[i] as Text);
				if(entry.data.endIndex + entry.data.trim >= index) {
					return {fieldIndex:i,index:index-entry.data.beginIndex};
				}
			}
			return {fieldIndex:_entries.length-1,index:(_entries[_entries.length-1] as Text).data.endIndex};
		}
		
		/** @private **/
		private function getCharIndexAtPoint(textField:TextField,point:Point):int {
			var index:int = textField.getCharIndexAtPoint(point.x,point.y);
			
			if (index > -1) {
				return index;
			}
			
			var lineIndex:int = Math.max(0,textField.getLineIndexAtPoint(2,Math.min(textField.height - 2,point.y)));
			
			if (lineIndex == 0 && point.y > textField.height - 4) {
				lineIndex = textField.bottomScrollV-1;
			}
			
			index = Math.min(textField.text.length,textField.getLineOffset(lineIndex)+textField.getLineLength(lineIndex));
			return index;
		}
		
		/** @private **/
		private function getFieldIndex(textField:TextField):int {
			for (var i:int=0;i<_entries.length;i++) {
				if(_entries[i].textField == textField) {
					return i;
				}
			}
			return -1;
		}
		
		/** @private **/
		private function rtrim(string:String):String {
			return string.replace(/[\n\r]+\s*$/,'');
		}
		
		/** @private **/
		private function ltrim(string:String):String {
			return string.replace(/^\s*[\n\r]/, '');
		}
	}
}