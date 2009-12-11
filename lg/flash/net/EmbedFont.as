/**
* EmbedFont Class by Giraldo Rosales.
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

package lg.flash.net {
	//Flash
	import flash.text.Font;
	import flash.system.ApplicationDomain;
	
	//LG
	import lg.flash.elements.Element;
	import lg.flash.elements.Flash;
	import lg.flash.events.ElementEvent;
	import lg.flash.net.ExternalList;
	
	public class EmbedFont extends Element {
		private var _list:ExternalList	= new ExternalList();
		
		public function EmbedFont() {
		}
		
		public function getSWF(fileName:String, base:String=''):void {
			data.filePath	= fileName;
			data.basePath	= base;
			
			//Get filename
			var fArr:Array	= fileName.split('/');
			var fLen:int	= 0;
			
			if(fArr.length > 0) {
				fLen	= fArr.length-1;
			}
			
			data.fileName	= fArr[fLen];
			data.clsName	= data.fileName.substring(0, data.fileName.length-4);
			
			//Check if already downloaded
			
			if(!ExternalList.isLoaded(data.filePath)) {
				ExternalList.add(name, data.filePath);
				var swfFont:Flash = new Flash({id:name, src:data.filePath, basePath:data.basePath});
				swfFont.loaded(onLoadFont);
				swfFont.error(onErrorFont);
			} else {
				//data.fontName	= ExternalList.getName(data.filePath);
				
				_list.bind('ext_'+name, onLoadedExternal);
				//trigger('element_loaded');
			}
		}
		
		private function onLoadFont(e:ElementEvent):void {
			var swfFont:Flash	= e.target as Flash;
			swfFont.unbind('element_loaded', onLoadFont);
			
			var domain:ApplicationDomain	= swfFont.domain;
			var fontClass:Class				= domain.getDefinition(data.clsName) as Class;
			var newFont:Font				= new fontClass();
			data.fontName					= newFont.fontName;
			Font.registerFont(fontClass);
			
			//Add to list of loaded fonts
			ExternalList.addName(swfFont.name, data.filePath, newFont.fontName);
				
			trigger('element_loaded', e);
		}
		
		private function onLoadedExternal(e:ElementEvent):void {
			data.fontName	= ExternalList.getName(data.filePath);
			trigger('element_loaded', e);
		}
		
		private function onErrorFont(e:ElementEvent):void {
			trace('onErrorFont');
		}
	}
}