/**
* xmlData Class by Giraldo Rosales.
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

 package lg.flash.model {
	//Flash Classes
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import lg.flash.events.ElementEvent;
	import lg.flash.net.FileLoader;
	
	public class xmlData extends LGData {
		public var isLoading:Boolean		= false;
		private var _queue:Vector.<String>	= new Vector.<String>();
		private var _xml:Object				= {};
		private var _object:Object			= {};
		
		/** Load data from an XML file. **/
		public function xmlData() {
		}
		
		/** Get data. 
		*	@param name Returns all data associated with an id.
		**/
		public override function getData(name:String):Object {
			return _data[name];
		}
		
		/** Get XML data. 
		*	@param name Returns all data associated with an id in XML format.
		**/
		public function getXML(name:String):XML {
			return _xml[name];
		}
		
		/** Get Object data. 
		*	@param name Returns all data associated with an id in an AS3 object.
		**/
		public function getObject(name:String, parse:Boolean=false):Object {
			var obj:Object	= {};
			
			if(_object[name] == undefined) {
				if(parse) {
					obj	= toElement(_xml[name]);
				} else {
					obj	= toObject(_xml[name]);
				}
			} else {
				obj	= _object[name];
			}
			
			return obj;
		}
		
		/** Load data. 
		*	@param obj Object containing all the properties to load data from an XML.
		*	<ul>
		*		<li><b>id</b> - <i>(required)</i>Unique id to reference data.</li>
		*		<li><b>url</b> - <i>(required)</i>Relative path to xml data.</li>
		*		<li><b>basePath</b> - <i>(optional)</i> BasePath for url.</li>
		*	</ul>
		**/
		public override function load(obj:Object):void {
			if(obj is String) {
				return;
			}
			
			if(!isLoading) {
				isLoading = true;
				
				var req:URLRequest;
				var url:String			= obj.url;
				var params:URLVariables	= new URLVariables();
				/*
				if(url && url.indexOf('?') >= 0) {
					var urlParams:Object	= getParams(url);
					params					= new URLVariables();
					url						= cleanURL;
					
					for(var s:String in urlParams) {
						params[s]	= urlParams[s];
					}
				}
				*/
				obj.basePath	= ('basePath' in obj) ? obj.basePath : '';
				
				req				= new URLRequest(obj.basePath+url);
				
				if(obj.bustCache) {
					params['cache']	= randRange(1000,3000);
				}
				
				req.data			= params;
				req.method			= URLRequestMethod.GET;
				req.contentType 	= "text/xml"; 
				
				var ldr:FileLoader	= new FileLoader();
				ldr.id				= obj.id;
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
			
			try {
				var results:XML		= new XML(ldr.data.results);
			}
			catch(error:Error) {
				trace('ERROR: XML is malformed.', ldr.data.url);
				return;
			}
			
			var ldrId:String	= ldr.id;
			_data[ldrId] 		= ldr.data.results;
			_xml[ldrId] 		= results;
			
			isLoading = false;
			
			if(_queue.length > 0) {
				load(_queue.shift());
			}
			
			//Dispatch event
			trigger('data_loaded', {id:ldrId, data:results, url:ldr.data.url});
		}
		
		/** @private **/
		private function onLoadError(e:ElementEvent):void {
			var ldr:FileLoader	= e.target as FileLoader;
			var ldrId:String	= ldr.id;
			
			trace('ERROR: XML data from "'+ldr.id+'" was not found. Please make sure the file exists at: ', ldr.data.url);
			
			//Dispatch event
			trigger('data_io_error', {id:ldrId}, e);
			
			//Cleanup
			ldr	= null;
		}
		
		/** @private **/
		private function randRange(min:Number, max:Number):Number {
		    var randomNum:Number = Math.floor(Math.random() * (max - min + 1)) + min;
		    return randomNum;
		}
		
		/** @private **/
		private function toElement(xml:XML):Object {
			if(xml == null) {
				return {};
			}
			
			var obj:Object			= {};
			var tmp:Object			= {};
			var items:XMLList		= xml.children();
			var itemName:String		= xml.localName();
			var itemLen:int			= items.length();
			var item:XML, itemID:String, inner:XMLList, objLen:int, attrLen:int, attr:XMLList, attrObj:Object, attrName:String, attrVal:String, xmlName:String;
			
			for(var g:int=0; g<itemLen; g++) {
				item	= items[g] as XML;
				itemID	= item.attribute('id');
				inner	= item.children();
				
				if(item.nodeKind() == 'text') {
					xmlName		= itemName;
					obj.value	= item.toString();
					
					if(obj == 'true') {
						obj	= true;
					}
					else if(obj == 'false') {
						obj	= false;
					}
					else if(!isNaN(Number(obj))) {
						obj	= Number(obj);
					}
					
					tmp			= obj;
				} else {
					xmlName		= item.localName();
					
					if (item != null && inner.length() == 0) {
						var str:String	= item.toString();
						
						if (obj[xmlName] == undefined) {
							obj[xmlName]		= {};
							obj[xmlName].value	= str;
							tmp					= obj[xmlName];
						} else {
							if (obj[xmlName][0] == undefined) {
								tmp				= obj[xmlName];
								obj[xmlName]	= [];
								obj[xmlName][0]	= tmp;
							}
							
							objLen		= obj[xmlName].length;
							obj[xmlName][objLen]		= {};
							obj[xmlName][objLen].value	= str;
							tmp							= obj[xmlName][objLen];
						}
					} else {
						if (obj[xmlName] == null) {
							obj[xmlName]	= toElement(item);
							tmp				= obj[xmlName];
						} else {
							if (obj[xmlName][0] == null) {
								tmp				= obj[xmlName];
								obj[xmlName]	= [];
								obj[xmlName][0]	= tmp;
							}
							
							objLen					= obj[xmlName].length;
							obj[xmlName][objLen]	= toElement(item);
							tmp						= obj[xmlName][objLen];
						}
					}
				}
				
				if(tmp is Object) {
					tmp.type		= xmlName;
					tmp.attributes	= {};
					attr			= item.attributes();
					attrLen			= attr.length();
					
					if(attrLen == 0) {
						tmp.attributes	= null;
					} else {
						for(var h:int=0; h<attrLen; h++) {
							attrObj		= attr[h].name();
							attrName	= attrObj.localName;
							attrVal		= attr[h].toString();
							tmp.attributes[attrName]	= attrVal;
						}
					}
				}
			}
			
			return obj;
		}
		
		/** @private **/
		private function toObject(xml:XML):Object {
			var obj:Object			= {};
			
			if(xml == null) {
				return obj;
			}
			
			var xmlObj:Object		= parseNode(xml);
			var children:XMLList	= xmlObj.value;
			var childLen:int		= children.length();
			
			for(var g:int=0; g<childLen; g++) {
				var child:XML			= children[g] as XML;
				
				if(!child) {
					continue;
				}
				
				if(child.nodeKind() == 'text') {
					obj	= child.toString();
					
					if(obj == 'true') {
						obj	= true;
					}
					else if(obj == 'false') {
						obj	= false;
					}
					else if(!isNaN(Number(obj))) {
						obj	= Number(obj);
					}
					
					return obj;
				}
				
				if(xmlObj.type == 'array') {
					if(!(obj is Array)) {
						obj	= [];
					}
					
					obj[g]	= toObject(XML(child));
				} else {
					var childObj:Object	= parseNode(child, xmlObj.type);
					
					if(!obj) {
						obj	= {};
					}
					
					obj[childObj.id]	= toObject(XML(child));
				}
			}
			
			return obj;
		}
			
		private function createObject(type:String):Object {
			switch(type) {
				case 'object':
					return {};
				case 'array':
					return [];
				case 'string':
				default:
					return '';
			}
		}
		
		private function parseNode(xml:XML, parentType:String=''):Object {
			var itemID:String	= xml.attribute('id');
			var inner:XMLList	= xml.children();
			var itemType:String	= xml.localName();
			
			var obj:Object		= {};
			obj.id				= (itemID != '') ? itemID : itemType;
			obj.type			= itemType;
			obj.kind			= xml.nodeKind();
			obj.value			= xml.children();
			obj.parent			= parentType;
			return obj;
		}
	}
}
