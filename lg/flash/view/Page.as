/**
* Page Class by Giraldo Rosales.
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

package lg.flash.view {
	//Flash Classes
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	import lg.flash.components.Background;
	import lg.flash.components.Preloader;
	import lg.flash.elements.Container;
	import lg.flash.elements.Element;
	import lg.flash.elements.Flash;
	import lg.flash.elements.Image;
	import lg.flash.elements.Shape;
	import lg.flash.elements.Sound;
	import lg.flash.elements.Text;
	import lg.flash.elements.Video;
	import lg.flash.elements.VisualElement;
	import lg.flash.events.ElementEvent;
	import lg.flash.events.ModelEvent;
	import lg.flash.events.PageEvent;
	import lg.flash.model.xmlData;
	import lg.flash.motion.Tween;
	import lg.flash.motion.easing.Quintic;
	import lg.flash.shell.Shell;
	
	public class Page extends Sprite {
		//Public Vars
		public var id:String			= '';
		public var basePath:String		= '';
		public var src:String			= '';
		public var data:Object			= {};
		public var elements:Object		= {};
		public var title:String			= '';
		
		public var designMode:Boolean	= false;
		public var flashVars:Object		= {};
		public var groups:Object		= {};
		public var percent:int			= 0;
		public var isSetup:Boolean		= false;
		public var isOpen:Boolean		= false;
		public var isFocus:Boolean		= false;
		public var isOverlay:Boolean	= false;
		public var shell:Shell;
		public var preloader:Preloader;
		
		/** Open the page when loaded. **/
		public var autoOpen:Boolean		= true;
		/** Close the page when another is opened. **/
		public var autoClose:Boolean	= true;
		public var deepLink:Boolean		= false;
		public var track:Boolean		= false;
		
		private var _pageData:xmlData	= new xmlData();
		private var _mask:Shape;
		private var _listners:Object	= {};
		private var _isLoading:Boolean	= false;
		private var _queue:Vector.<String>		= new Vector.<String>();
		private var _xmlURL:String		= '';
		
		//Elements
		private var _elements:Vector.<Object>	= new Vector.<Object>();
		private var _elementIdx:int		= 0;
		private var _tmpIdx:int			= 0;
		
		/** @private **/
		private var _background:VisualElement;
		
		//Protected;
		protected var _pageBytes:Number	= 0;
		
		public function Page(obj:Object=null) {
			buttonMode		= false;
			mouseEnabled	= false;
			mouseChildren	= true;
			useHandCursor	= false;
			
			if(obj) {
				if(obj.width && obj.height) {
					graphics.clear();
					graphics.beginFill(0x000000, 0);
					graphics.drawRect(0, 0, obj.width, obj.height);
					graphics.endFill();
				}
				
				//Set Defaults
				data.hidden		= false;
				data.autoOpen	= true;
				data.autoSize	= true;
				data.width		= 0;
				data.height		= 0;
				
				//Set Attributes
				setAttributes(obj);
				
				if(data.background != undefined) {
					buildBackground();
				}
				
				shell		= data.shell as Shell;
				preloader	= shell.preloader;
			}
			
			addEventListener('mouseDown', onMouseDown, false, 0, true);
			addEventListener('mouseMove', onMouseMove, false, 0, true);
			addEventListener('mouseOut', onMouseOut, false, 0, true);
			addEventListener('mouseOver', onMouseOver, false, 0, true);
			addEventListener('mouseUp', onMouseUp, false, 0, true);
		}
		
		public function get autoSize():Boolean {
			return data.autoSize;
		}
		public function set autoSize(value:Boolean):void {
			data.autoSize	= value;
			
			if(!value) {//Create mask
				if(!_mask) {
					_mask			= new Shape({id:'pageMask', width:data.width, height:data.height});
					addChild(_mask);
				}
				
				mask	= _mask;
			} else {
				if(_mask) {
					if(contains(_mask)) {
						removeChild(_mask);
					}
					
					_mask	= null;
				}
			}
		}
		
		/** @private **/
		public function setAttributes(obj:Object):void {
			if(!obj) {
				return;
			}
			
			var ignore:Vector.<String>	= new Vector.<String>(1, true);
			ignore[0]		= 'background';
			
			if(obj.id) {
				obj.name	= obj.id;
			}
			
			for(var s:String in obj) {
				data[s] 	= obj[s];
				
				if(ignore.indexOf(s) < 0) {
					if(s in this) {
						if(obj[s] == 'true') {
							obj[s]	= true;
						}
						
						if(obj[s] == 'false') {
							obj[s]	= false;
						}
						
						this[s] = obj[s];
					}
				}
			}
		}
		
		/** Toggles the alpha and visibility of an element. */
		public function get hidden():Boolean {
			return data.hidden;
		}
		public function set hidden(value:Boolean):void {
			data.hidden		= value;
			
			if(data.hidden) {
				alpha	= 0;
				visible	= false;
			} else {
				alpha	= 1;
				visible	= true;
			}
		}
		
		public function set background(bg:VisualElement):void {
			_background	= bg;
		}
		
		public function get background():VisualElement {
			return _background;
		}
		
		/** @private **/
		public function buildBackground():void {
			var obj:Object	= {};
			obj.src			= data.background;
			obj.align		= data.bgAlign;
			obj.basePath	= basePath;
			obj.stage		= stage;
			
			_background		= new Background(obj);
			_background.loaded(onLoadBackground);
			addChildAt(_background, 0);
		}
		
		/** @private **/
		private function onLoadBackground(e:ElementEvent):void {
			//Cleanup
			_background.unbind(ElementEvent.LOADED, onLoadBackground);
			
			//Make sure size is correct
			//onResize(e);
		}
		
		public function loadXML(url:String):void {
			if(_isLoading) {
				_queue.push(url);
			} else {
				_isLoading	= true;
				_pageData.load({id:'elements', url:url, basePath:basePath});
				_pageData.loaded(onLoadXML);
				_pageData.error(onErrorXML);
			}
		}
		
		/** Indicates the width of the display object, in pixels. **/
		public override function get width():Number {
			return data.width;
		}
		public override function set width(value:Number):void {
			data.width		= value;
			resetSize();
		}
		
		/** Indicates the height of the display object, in pixels. **/
		public override function get height():Number {
			return data.height;
		}
		public override function set height(value:Number):void {
			data.height	= value;
			resetSize();
		}
		
		public override function addChild(element:DisplayObject):DisplayObject {
			var el:Element	= element as Element;
			
			if(el && el.id) {
				//If not already in the elements object, add
				if(!elements[el.id]) {
					elements[el.id]	= el;
				}
				
				if(el.addToPage) {
					//Track clicks on element
					if(shell && shell.tracker) {
						if(shell.data && shell.data.trackClicks) {
							el.bind('element_click', onClickElement);
						}
					}
					
					super.addChild(element);
				} else {
					el.addToPage	= true;
				}
			} else {
				super.addChild(element);
			}
			
			return element;
		}
		
		public function update(obj:Object=null):void {
			if(!stage) {
				return;
			}
			
			//Set new dimensions
			if(obj) {
				if(obj.width != undefined) {
					data.width	= obj.width;
				}
				
				if(obj.height != undefined) {
					data.height	= obj.height;
				}
			}
			
			if(stage && data.autoSize) {
				data.width	= stage.stageWidth;
				data.height	= stage.stageHeight;
			}
			
			//Resize width and height
			resetSize();
		}
		
		protected function resetSize():void {
			graphics.clear();
			graphics.beginFill(0x000000, 0);
			graphics.drawRect(0, 0, data.width, data.height);
			graphics.endFill();
		}
		
		/** @private **/
		private function onLoadXML(e:ModelEvent):void {
			//Cleanup
			_pageData.unbind(ModelEvent.LOADED, onLoadXML);
			_pageData.unbind(ModelEvent.ERROR, onErrorXML);
			
			_xmlURL			= e.data.url;
			var obj:Object	= _pageData.getObject('elements', true);
			_elements		= parseNodes(obj, true);
			
			//Create first element
			var elementLen:int	= _elements.length;
			
			if(elementLen > 0) {
				buildNext(_elements[_elementIdx]);
			}
			else if(elementLen == 0 && !isSetup) {
				init();
			}
		}
		
		/** @private **/
		private function onErrorXML(e:ModelEvent):void {
			trace('ERROR: Loading page XML. ', e.data.url);
			
			//Cleanup
			_pageData.removeEventListener(ModelEvent.LOADED, onLoadXML);
			_pageData.removeEventListener(ModelEvent.ERROR, onErrorXML);
			_pageData	= null;
			nextQueue();
		}
		
		/** @private **/
		private function parseNodes(items:Object, topLevel:Boolean=false):Vector.<Object> {
			var ignore:Vector.<String>	= new Vector.<String>(5, true);
			ignore[0]	= 'name';
			ignore[1]	= 'type';
			ignore[2]	= 'attributes';
			ignore[3]	= 'top';
			ignore[4]	= 'value';
			
			var nodes:Vector.<Object>	= new Vector.<Object>();
			var nodeLen:int		= 0;
			var itemName:String;
			
			for(var s:String in items) {
				itemName	= s.toLowerCase();
				
				if(ignore.indexOf(itemName) < 0) {
					if(!(items[s] is String)) {
						items[itemName].type	= itemName;
						items[itemName].top		= topLevel;
					}
					
					if(items[itemName] is Array) {
						var arrItems:Array	= items[itemName];
						var itemLen:int		= arrItems.length;
						var innerItem:Object;
						
						for(var g:int=0; g<itemLen; g++) {
							if(arrItems[g]) {
								innerItem		= arrItems[g];
								innerItem.type	= arrItems[g].type;
								innerItem.top	= topLevel;
								nodeLen			= nodes.length;
								nodes[nodeLen]	= innerItem;
							}
						}
					} else {
						nodeLen			= nodes.length;
						nodes[nodeLen]	= items[itemName];
					}
				}
			}
			
			return nodes;
		}
		
		/** @private **/
		private function parseName(obj:Object):String {
			var str:String;
			
			if(!(obj is String) && obj.attributes && obj.attributes.id != undefined){
				str	= obj.attributes.id;
			} else {
				str	= 'element'+_tmpIdx;
				_tmpIdx++;
			}
			
			return str;
		}
		
		/** @private **/
		private function buildNext(obj:Object):void {
			var attr:Object		= obj.attributes as Object;
			var item:Object		= create(obj) as Object;
			
			if(item is Element) {
				var element:Element	= item as Element;
				element.progress(onProgressElement);
				
				if(element.data.waitLoad) {
					element.loaded(onLoadElement);
				} else {
					element.bind('element_add', onLoadElement);
				}
				
				addChild(element);
			} else {
				onLoadNext();
			}
		}
		
		//Create a new element
		public function create(obj:Object, parentID:String=null):* {
			if(obj is String) {
				return null;
			}
			
			var elementId:String	= parseName(obj);
			var g:int;
			
			//Set Defaults
			if(!obj.attributes) {
				obj.attributes	= {};
			}
			
			obj.attributes.stage		= stage;
			obj.attributes.shell		= shell;
			obj.attributes.basePath		= basePath;
			
			if(parentID) {
				obj.attributes.elementParent	= parentID;
				obj.attributes.parent			= elements[parentID];
			}
			
			if(obj.type != 'object' && obj.type != 'array' && obj.type != 'string') {
				obj.attributes.name		= elementId;
				obj.attributes.parent	= this;
				obj.attributes.waitLoad	= true;
			}
			
			//Get inside nodes
			var innerId:String		= '';
			var innerItems:Vector.<Object>	= parseNodes(obj);
			var numInner:int		= innerItems.length;
			var isTop:Boolean		= obj.top as Boolean;
			var attr:Object			= obj.attributes as Object;
			var dspObj:Element;
			
			//Create the element
			var type:String			= obj.type;
			switch(type.toLowerCase()) {
				case 'img':
				case 'image':
					var newImg:Image	= new Image(attr);
					
					for(g=0; g<numInner; g++) {
						if(!(innerItems[g] is String)) {
							dspObj	= create(innerItems[g], elementId) as Element;
							
							if(dspObj) {
								newImg.addChild(dspObj);
							}
						}
					}
					
					if(isTop && elementId) {
						elements[elementId]	= newImg;
					}
					
					return newImg;
					break;
				case 'flash':
					var newFlash:Flash	= new Flash(attr);
					
					for(g=0; g<numInner; g++) {
						if(!(innerItems[g] is String)) {
							dspObj	= create(innerItems[g], elementId) as Element;
							
							if(dspObj) {
								newFlash.addChild(dspObj);
							}
						}
					}
					
					if(isTop && elementId) {
						elements[elementId]	= newFlash;
					}
					
					return newFlash;
					break;
				case 'text':
					attr.content	= obj.value.toString();
					attr.waitLoad	= false;
					var newTxt:Text	= new Text(attr);
					
					if(isTop && elementId) {
						elements[elementId]	= newTxt;
					}
					
					return newTxt;
					break;
				case 'sound':
					var newSnd:Sound	= new Sound(attr);
					
					if(isTop && elementId) {
						elements[elementId]	= newSnd;
					}
					
					return newSnd;
					break;
				case 'video':
					//if((!attr.src) || attr.src == '') {
						attr.waitLoad	= false;
					//}
					
					newObj	= new Video(attr);
					
					if(isTop && elementId) {
						elements[elementId]	= newObj;
					}
					
					return newObj;
					break;
				case 'shape':
					attr.waitLoad		= false;
					var newShp:Shape	= new Shape(attr);
					
					for(g=0; g<numInner; g++) {
						if(!(innerItems[g] is String)) {
							dspObj	= create(innerItems[g], elementId) as Element;
							
							if(dspObj) {
								newShp.addChild(dspObj);
							}
						}
					}
					
					if(isTop && elementId) {
						elements[elementId]	= newShp;
					}
					
					return newShp;
					break;
				case 'object':
					var newObj:Object	= attr;
					
					for(g=0; g<numInner; g++) {
						innerId			= parseName(innerItems[g]);
						newObj[innerId]	= create(innerItems[g], elementId);
					}
					
					if(isTop && elementId) {
						elements[elementId]	= newObj;
					}
					
					return newObj;
					break;
				case 'array':
					var newArr:Array	= [];
					
					for(g=0; g<numInner; g++) {
						newArr[g]	= create(innerItems[g], elementId);
					}

					if(isTop && elementId) {
						elements[elementId]	= newArr;
					}
					
					return newArr;
					break;
				case 'string':
					var newStr:String	= obj.value.toString();
					
					if(isTop && elementId) {
						elements[elementId]	= newStr;
					}
					
					return newStr;
					break;
				case 'div':
				case 'visualelement':
					//Setup blank VisualElement
					attr.waitLoad				= false;
					var newVisual:VisualElement	= new VisualElement(attr);
							
					for(g=0; g<numInner; g++) {
						if(!(innerItems[g] is String)) {
							dspObj	= create(innerItems[g], elementId) as Element;
							
							if(dspObj) {
								newVisual.addChild(dspObj);
							}
						}
					}
					
					if(isTop && elementId) {
						elements[elementId]	= newVisual;
					}
					
					return newVisual;
					break;
				case 'container':
					attr.waitLoad			= false;
					var newCon:Container	= new Container(attr);
					
					for(g=0; g<numInner; g++) {
						if(!(innerItems[g] is String)) {
							newCon.addChild(create(innerItems[g], elementId));
						}
					}
					
					if(isTop && elementId) {
						elements[elementId]	= newCon;
					}
					
					return newCon;
					break;
			}
			
			return {};
		}
		
		/** @private **/
		private function onLoadElement(e:ElementEvent=null):void {
			var element:Element	= e.target as Element;
			
			if(element) {
				element.unbind('element_progress', onProgressElement);
				element.unbind('element_loaded', onLoadElement);
				element.unbind('element_add', onLoadElement);
			}
			
			onLoadNext();
		}
		
		private function onLoadNext():void {
			//Get next element
			_elementIdx++;
			
			//Create rest of elements
			if(_elementIdx < numElements) {
				buildNext(_elements[_elementIdx]);
			} else if(!isSetup) {
				nextQueue();
				init();
			} else {
				nextQueue();
				trigger('page_xml_loaded', {url:_xmlURL});
			}
		}
		
		private function nextQueue():void {
			_isLoading	= false;
			
			if(_queue.length > 0) {
				var nextURL:String	= _queue.shift();
				loadXML(nextURL);
			}
		}
		
		/** @private **/
		private function onProgressElement(e:ElementEvent):void {
			//e.event.bytesLoaded
			//e.event.bytesTotal
			//trace('onProgressElement', _elementIdx, numElements);
		}
		
		/** @private **/
		private function onClickElement(e:ElementEvent):void {
			var element:Element	= e.target as Element;
			shell.tracker.trackEvent(id, e.type, element.id);
		}
		
		public function get numElements():int {
			return _elements.length;
		}
		
		//Get Elements
		public function $(id:*):* {
			if(id is String) {
				var firstIdx:int = id.indexOf('[');
				
				if(firstIdx >=0) {
					//Search by attribute
					var groupObj:Vector.<Object>	= new Vector.<Object>();
					var g:int, s:String, attr:String, grpLen:int, elLen:int, lastIdx:int, attrIdx:int, element:VisualElement;
					
					lastIdx		= id.indexOf(']');
					attr		= id.substring(firstIdx+1, lastIdx);
					
					//if specific attribute
					attrIdx		= attr.indexOf('=');
					elLen		= _elements.length;
					
					if(attrIdx >= 0) {
						var attrArray:Array, attrName:String, attrValue:String, elID:String, ptrnCommas:RegExp;
						
						ptrnCommas	= /["']/g;
						attrArray	= attr.split('=');
						attrName	= attrArray[0];
						
						attrValue	= attrArray[1].replace(ptrnCommas, '');
						
						//Search for matching elements
						for(s in elements) {
							if(attrName in elements[s] && elements[s][attrName] == attrValue) {
								grpLen				= groupObj.length;
								groupObj[grpLen]	= elements[s];
							}
						}
					} else {
						//Search for matching elements
						for(s in elements) {
							element	= elements[s];
							
							if(attr in element) {
								grpLen				= groupObj.length;
								groupObj[grpLen]	= elements[element.id];
							}
						}
					}
					
					return groupObj;
				}
				if(id.indexOf('#') >= 0) {
					//Search by id
					return elements[id.split('#')[1]];
				}
			} else {
				return id;
			}
		}
		
		/*
		//Dev Functions to drag and drop
		private function onDevMouseDown(e:MouseEvent):void {
			var mc:MovieClip	= e.currentTarget as MovieClip;
			mc.startDrag();
		}
		
		private function onDevMouseUp(e:MouseEvent):void {
			var mc:MovieClip	= e.currentTarget as MovieClip;
			
			mc.stopDrag();
			trace('----Design Mode-----');
			trace('Name: '+mc.name);
			trace('x: '+mc.x);
			trace('y: '+mc.y);
			trace('mc[\''+mc.name+'\'].setPos('+mc.x+', '+mc.y+');');
		}
		private function onDevDblClick(e:MouseEvent):void {
			var mc:MovieClip	= e.currentTarget as MovieClip;
			toggleDesignMode(mc);
		}
		
		private function toggleDesignMode(mc:MovieClip):void {
			if(mc.dev) {
				trace('----Toggle Off-----');
				mc.removeEventListener(MouseEvent.MOUSE_DOWN, onDevMouseDown);
				mc.removeEventListener(MouseEvent.MOUSE_UP, onDevMouseUp);
				mc.dev = false;
				//this.parent.setChildIndex(mc, 1);
			} else {
				trace('----Toggle On-----');
				mc.toFront();
				mc.addEventListener(MouseEvent.MOUSE_DOWN, onDevMouseDown);
				mc.addEventListener(MouseEvent.MOUSE_UP, onDevMouseUp);
				mc.dev = true;
				//this.parent.setChildIndex(mc, numChildren-1);
			}
		}
		*/
		
		public function init():void {
		}
		
		public function start():void {
		}
		
		public function stop():void {
		}
		
		/** Animate element **/
		public function animate(obj:Object):void {
			obj.target	= this;
			new Tween(obj);
		}
		
		/** Open a Page **/
		public function open(pageName:String, params:Object=null, data:Object=null):void {
			if(params) {
				if(params.autoClose) {
					params.closePage	= id;
				}
			} else {
				params = {};
			} 
			
			if(autoClose) {
				params.autoClose	= true;
				params.closePage	= id;
			}
			
			shell.open(pageName, params, data);
		}
		
		public function transitionIn():void {
			trace('Page::transitionIn', id);
			preloader.hide(.3);
			animate({duration:.25, alpha:1, ease:Quintic.easeOut, onComplete:onTransIn});
		}
		
		/** @private **/
		private function onTransIn():void {
			trace('Page::onTransIn', id);
			start();
			trigger('page_open');
		}
		
		/** Close a page. **/
		public function close(pageName:String, params:Object=null):void {
			if(!pageName) {
				pageName = data.id;
			}
			
			shell.close(pageName);
		}
		
		public function transitionOut():void {
			animate({duration:.15, alpha:0, ease:Quintic.easeIn, onComplete:onTransOut});
		}
		
		/** @private **/
		private function onTransOut():void {
			trigger('page_close');
			stop();
		}
		
		/** Call to notify the page is finished loading. **/
		public function finished():void {
			isSetup	= true;
			trigger('page_loaded');
		}
		
		public function setProgress(loaded:Number, total:Number, details:String=''):void {
			var percent:int	= Math.ceil((loaded / total) * 100);
			
			if(preloader) {
				preloader.setPercent(percent);
				preloader.setDetails(details);
			}
		}
		
		//Events
		/** Shortcut for a weak reference addEventListener call. Binds the type 
		*	of event with the function. Also adds the listener to the event 
		*	manager. If the double click event is used, it will automatically
		*	set the doubleClickEnabled property to true.
		*
		*	@param type The type of event to bind. 
		*	@param fn The function to call once the event is triggered. **/
		public function bind(type:String, fn:Function):Page {
			var listenArray:Array = _listners[type];
			if(listenArray == null) {
				listenArray	= [];
			}
			
			if(type == 'page_dblclick') {
				doubleClickEnabled	= true;
			}
			
			var lisLen:int		= listenArray.length;
			listenArray[lisLen]	= fn;
			_listners[type]	= listenArray;
			addEventListener(type, fn, false, 0, true);
			
			//Cleanup
			listenArray	= null;
			type		= null;
			fn			= null;
			return this;
		}
		
		public function unbind(type:String, fn:Function=null):void {
			if(fn != null) {
				//remove a specific listener
				removeEventListener(type, fn);
			} else {
				//else remove all listeners for that type
				var lisLen:int = _listners[type].length;
				for(var g:int=0; g<lisLen; g++) {
					removeEventListener(type, _listners[type][g]);
				}
			}
		}
		
		/** Shortcut to dispatch an event. If any variables are to be sent with 
		*	the event, you can pass them within an Object in the second parameter.
		*	This way you can pull the data from the listener function. You can also 
		*	use the params attribute on the event to grab any of the element 
		*	variables stored in the data attribute.
		*
		*	@param type Type of event to dispatch. 
		*	@param data Additional data to send with the event. **/
		public function trigger(type:String, args:Object=null, event:Object=null):Page {
			var e:PageEvent	= new PageEvent(type);
			e.params		= data;
			e.data			= args;
			e.event			= event;
			dispatchEvent(e);
			
			//Cleanup
			type	= null;
			args	= null;
			event	= null;
			
			return this;
		}
		
		/** Center horizontally with stage. **/
		public function set horizontalCenter(value:*):void {
			if(value is String) {
				data.horizontalCenter = (value == 'true') ? true : false;
			}
			else if(value is Boolean) {
				data.horizontalCenter = value;
			}
			
			update();
		}
		public function get horizontalCenter():Boolean {
			return data.horizontalCenter;
		}
		
		/** Center vertically with stage. **/
		public function set verticalCenter(value:*):void {
			if(value is String) {
				data.verticalCenter = (value == 'true') ? true : false;
			}
			else if(value is Boolean) {
				data.verticalCenter = value;
			}
			
			update();
		}
		public function get verticalCenter():Boolean {
			return data.verticalCenter;
		}
		
		/** Stage object. May be be set externally. Otherwise, if added to the stage, will use the default stage property. **/
		public function set stage(container:Stage):void {
			data.stage	= container;
		}
		public override function get stage():Stage {
			if(super.stage) {
				return super.stage;
			} else {
				return data.stage;
			}
		}
		
		//Positioning
		/** Pulls the element in the front of the existing children. **/
		public function toFront():void {
			shell.setChildIndex(this, parent.numChildren-1);
		}
		/** Pushes the element to the back, behind all the elements within the parent **/
		public function toBack():void {
			shell.setChildIndex(this, 1);
		}
		
		/** @private **/
		private function onMouseDown(e:MouseEvent):void {
			trigger('page_mousedown', null, e);
		}
		/** @private **/
		private function onMouseMove(e:MouseEvent):void {
			trigger('page_mousemove', null, e);
		}
		/** @private **/
		protected function onMouseOut(e:MouseEvent):void {
			trigger('page_mouseout', null, e);
		}
		/** @private **/
		protected function onMouseOver(e:MouseEvent):void {
			trigger('page_mouseover', null, e);
		}
		/** @private **/
		private function onMouseUp(e:MouseEvent):void {
			trigger('page_mouseup', null, e);
		}
		
		/** Kill the object and clean from memory. **/
		public function kill():void {
			//Delete all elements
			for(var s:String in elements) {
				elements[s].removeEventListener('element_progress', onProgressElement);
				elements[s].removeEventListener('element_loaded', onLoadElement);
				elements[s].removeEventListener('element_add', onLoadElement);
				
				elements[s].kill();
				removeChild(elements[s]);
			}
			
			//Remove all listeners
			_pageData.removeEventListener(ModelEvent.LOADED, onLoadXML);
			_pageData.removeEventListener(ModelEvent.ERROR, onErrorXML);
			
			//Nullify all values
			id			= null;
			basePath	= null;
			data		= null;
			elements	= null;
			groups		= null;
			_pageData	= null;
			_listners	= null;
			_elements	= null;
			if(mask) {
				removeChild(mask);
				mask	= null;
			}
			
		}
	}
}
