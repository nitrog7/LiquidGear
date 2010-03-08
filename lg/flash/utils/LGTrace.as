/**
 * LGTrace Class by Giraldo Rosales.
* Visit www.liquidgear.net for documentation and updates.
*
*
* Copyright (c) 2010 Nitrogen Design, Inc. All rights reserved.
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

package lg.flash.utils {
	import flash.display.Stage;
	//import flash.events.Event;
	//import flash.events.MouseEvent;
	
	import lg.flash.elements.VisualElement;
	import lg.flash.elements.Text;
	import lg.flash.elements.Shape;
	import lg.flash.events.ElementEvent;
	
	public class LGTrace extends VisualElement {
		private var txtOutput:Text;
		private var titleBar:VisualElement;
		private var btnClear:Text;
		private var mainStage:Stage;
		private static var instance:LGTrace;
		private static var maxChars:int			= 10000;
		public static var autoExpand:Boolean	= false;
		public static var outputEnabled:Boolean	= false;
		
		/**
		 * Constructor 
		 */
		public function LGTrace(targetStage:Stage = null, outputHeight:int=155) {
			if (instance && instance.parent){
				instance.parent.removeChild(instance);
			}
			
			instance			= this;
			
			// assign the passed stage to mainStage
			mainStage	= (targetStage) ? targetStage : stage;
			data.stageWidth		= mainStage.stageWidth;
			data.stageHeight	= mainStage.stageHeight;
			
			//Output box
			txtOutput			= new Text({id:'content', width:data.stageWidth, height:outputHeight, font:'_typewriter', multiline:true, wordWrap:true, color:0xffffff, embedfonts:false, selectable:true, background:true, backgroundColor:0x000000});
			txtOutput.visible	= false;
			addChild(txtOutput);
			
			//Title Bar
			titleBar	= new Shape({id:'titleBar', width:data.stageWidth, height:25, color:0x000000, fillAlpha:.75});
			titleBar.button();
			addChild(titleBar);
			
			var barLabel:Text = new Text({id:'label', text:'Output | ', font:'Arial', x:3, y:3, color: 0xffffff, bold:true, embedfonts:false, selectable:false});
			titleBar.addChild(barLabel);
			
			var btnClear:Text = new Text({id:'clear', text:'Clear', font:'Arial', x:3, y:3, color: 0xffffff, bold:true, embedfonts:false, selectable:false});
			titleBar.addChild(btnClear);
			btnClear.setPos(barLabel.x+barLabel.width, barLabel.y);
			btnClear.button();
			btnClear.click(onClickClear);
			
			//Listeners
			titleBar.click(toggleCollapse);
			
			
			// start off fit to stage and collapsed
			update({width:data.stageWidth, height:data.stageHeight});
			toggleCollapse();
		}
		
		private function onClickClear(e:ElementEvent):void {
			clear();	
		}
		
		/**
		 * trace
		 * sends arguments to the output text field for display
		 */
		public static function trace(...args):void {
			// if not enabled, exit
			if (!instance) return;
			if(!outputEnabled) return;
			
			instance.txtOutput.text	= instance.txtOutput.text + (args.toString().split(',').join(' ') + "\n");
			
			if (instance.txtOutput.text.length > maxChars) {
				instance.txtOutput.text = instance.txtOutput.text.slice(-maxChars);
			}
			
			// scroll to bottom of text field
			instance.txtOutput.textField.scrollV = instance.txtOutput.textField.maxScrollV;
			
			// Make visible and expand if not already
			if (!instance.visible) instance.visible = true;
			if (autoExpand && !instance.txtOutput.visible) {
				toggleCollapse();
			}
		}
		
		/**
		 * clear
		 * clears output text field text
		 */
		public static function clear():void {
			if (!instance) return;
			instance.txtOutput.text = '';
		}
		
		/**
		 * Collapses/Expands the output panel
		 */
		public static function toggleCollapse(e:ElementEvent=null):void {
			if (!instance) {
				return void;
			}
			
			instance.txtOutput.visible = !instance.txtOutput.visible;
			instance.update({width:instance.data.stageWidth, height:instance.data.stageHeight});
		}
		
		/**
		 * When the stage resizes, stretch to fit horizontally and position at the bottom of the screen
		 */
		public override function update(obj:Object=null):void {
			if(!obj) {
				return void;
			}
			
			data.stageWidth		= obj.width;
			data.stageHeight	= obj.height;
			
			txtOutput.width	= obj.width;
			txtOutput.y		= obj.height - txtOutput.height;
			
			titleBar.y		= (txtOutput.visible) ? txtOutput.y - titleBar.height + 1 : obj.height - titleBar.height + 1;
			titleBar.width	= obj.width;
		}
	}
}