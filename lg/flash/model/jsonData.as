/**
* jsonData Class by Giraldo Rosales.
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

 package lg.flash.model {
	//Flash Classes
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.System;
	
	//LG Classes
	import lg.flash.model.LGData;
	import lg.flash.events.ElementEvent;
	import lg.flash.events.ModelEvent;
	import lg.flash.net.FileLoader;
	import lg.flash.utils.LGjson;
	
	public class jsonData extends LGData {
		public var isLoading:Boolean		= false;
		private var _queue:Vector.<String>	= new Vector.<String>();
		private var ldr:FileLoader			= new FileLoader()
		
		/** Load data from an XML file. **/
		public function jsonData() {
		}
		
		/** Get data. 
		*	@param name Returns all data associated with an id.
		**/
		public function getObject(name:String):* {
			return _data[name];
		}
		
		/** Get data. 
		*	@param name Returns all data associated with an id.
		**/
		public function getXMLData(name:String):XML {
			return _data[name];
		}
		
		/** Load data. 
		*	@param obj Object containing all the properties to load data from an XML.
		**/
		public override function load(obj:Object):void {
			if(!isLoading) {
				isLoading = true;
				
				var req:URLRequest, header:URLRequestHeader;
				
				obj.basePath	= ('basePath' in obj) ? obj.basePath : '';
				
				req				= new URLRequest(obj.basePath+obj.url);
				header			= new URLRequestHeader('Pragma', 'no-cache');
				
				if(obj.bustCache) {
					var params:URLVariables=new URLVariables()
					params['cache']	= randRange(1000,3000);
					req.data		= params;
				}
				
				req.method		= URLRequestMethod.GET;
				req.requestHeaders[req.requestHeaders.length]	= header;
				
				ldr.id	= obj.id;
				ldr.ioerror(onLoadError);
				ldr.loaded(onLoadComplete);
				ldr.load(req);
			} else {
				_queue.push(obj);
			}
		}
		
		/** Clear data.
		*	@param id (optional) If an id is used as a parameter, it will remove all related data, otherwise all data is cleared.
		**/
		public function clear(id:String=''):void {
			if(id != '') {
				delete _data[id];
			} else {
				_data = null;
			}
		}
		
		/** @private **/
		private function onLoadComplete(e:ElementEvent):void {
			var ldr:FileLoader	= e.target as FileLoader;
			//Remove listeners
			
			var ldrId:String		= ldr.id;
			
			_data[ldrId] 			= LGjson.decode(ldr.data.results);
			
			//Dispatch event
			var event:ModelEvent	= new ModelEvent(ModelEvent.LOADED);
			event.data.id			= ldrId;
			event.data.data		= _data[ldrId];
			dispatchEvent(event);
			
			//Cleanup
			ldr		= null;
			ldrId	= null;
			
			isLoading = false;
			
			if(_queue.length > 0) {
				load(_queue.shift());
			}
		}
		
		/** @private **/
		private function onLoadError(e:ElementEvent):void {
			var ldr:FileLoader	= e.target as FileLoader;
			var ldrId:String	= ldr.id;
			
			//Remove listeners
			ldr.unbind('element_io_error', onLoadError);
			
			trace(e);
			
			//Dispatch event
			var event:ModelEvent	= new ModelEvent(ModelEvent.ERROR);
			event.data.id			= ldrId;
			event.event				= e;
			dispatchEvent(event);
			
			//Cleanup
			ldr	= null;
		}
		
		/** @private **/
		private function randRange(min:Number, max:Number):Number {
		    var randomNum:Number = Math.floor(Math.random() * (max - min + 1)) + min;
		    return randomNum;
		}
	}
}
