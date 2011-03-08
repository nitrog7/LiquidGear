/**
* Shell Class by Giraldo Rosales.
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

package lg.flash.shell {
	//Flash Classes
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	import flash.utils.getDefinitionByName;
	import flash.system.Security;
	
	import lg.flash.components.Preloader;
	import lg.flash.events.ModelEvent;
	import lg.flash.events.PageEvent;
	import lg.flash.model.xmlData;
	import lg.flash.track.Analytics;
	import lg.flash.utils.LGDebug;
	import lg.flash.utils.LGString;
	import lg.flash.utils.SWFAddress;
	import lg.flash.events.SWFAddressEvent;
	import lg.flash.view.Page;
	
	public class Shell extends Page {
		/** XML file describing all pages to be loaded. */
		public var control:String			= 'XML/control.xml';
		/** Indicates if site is running indevelopment mode (Debugging in the Flash IDE). */
		public var development:Boolean		= false;
		/** Contains the pages in the shell with the id as the key. **/
		public var pages:Object				= {};
		/** @private **/
		public var pageInfo:Vector.<String>	= new Vector.<String>();
		/** Number of pages in the site */
		public var numPages:int				= 0;
		/** Number of pages in the site */
		public var tracker:Analytics;
		
		/** Debugger. Use console.on() to turn on the debugger, console.off() to turn it off.
		* Once on, you can use trace commands to the <a href="http://demonsterdebugger.com/">De Monster Debugger</a> client with
		* the commands, console.log(), console.warn(), and console.error(). **/
		public var console:LGDebug;
		public var numOpen:int				= 0;
		
		/** @private **/
		private var _siteXML:XML;
		/** @private **/
		private var _pageData:xmlData		= new xmlData();
		/** @private **/
		private var _pagesLoaded:int		= 0;
		/** @private **/
		private var _pagesExt:String		= 'Page';
		/** @private **/
		private var _id:Vector.<String>				= new Vector.<String>();
		/** @private **/
		private var _readyToBuild:Vector.<String>	= new Vector.<String>();
		/** @private **/
		private var _designMode:Boolean		= false;
		/** @private **/
		private var _completePercent:Number	= 0;
		/** @private **/
		private var _pageIdx:int			= 0;
		/** @private **/
		private var _loadIdx:int			= 0;
		/** @private **/
		private var _firstID:String;
		/** @private **/
		private var _pages:Object			= {};
		/** @private **/
		private var _overlays:Array			= [];
		/** @private **/
		private var _openedPages:Array		= [];
		/** @private **/
		private var _currentPage:String		= '';
		
		public function Shell() {
			super();
		}
		
		protected function load(url:String):void {
			control = url;
			
			//Setup
			setup();
			
			//Load XML
			_pageData.addEventListener(ModelEvent.LOADED, onLoadControl);
			_pageData.addEventListener(ModelEvent.ERROR, onErrorControl);
			_pageData.load({id:'control', url:control, basePath:basePath});
			
			stage.addEventListener(Event.RESIZE, onResize);
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullscreen);
		}
		
		/** Indicates the width of the display object, in pixels. **/
		public override function get width():Number {
			return stage.stageWidth;
		}
		
		/** Indicates the height of the display object, in pixels. **/
		public override function get height():Number {
			return stage.stageHeight;
		}
		
		/** @private **/
		public function setup():void {
			//Setting Environment Type
			envCheck();
			
			//Stage Setup
			stage.frameRate		= 30;
			stage.scaleMode		= 'noScale';
			stage.align			= 'TL';
			
			//Security
			Security.allowDomain('*');
			
			//Set Attributes
			data.needOpen		= 1;
			
			//Setup SWFAddress listener
			if(!development) {
				if(!SWFAddress.hasEventListener(SWFAddressEvent.EXTERNAL_CHANGE)) {
					SWFAddress.addEventListener(SWFAddressEvent.EXTERNAL_CHANGE, onSWFAddress);
				}
			}
		}
		
		/** @private **/
		private function envCheck():void {
			//Set Environment Type
			switch(Capabilities.playerType) {
				case 'External':
				case 'StandAlone':
					development	= true;
					break;
				default :
					development	= false;
					break;
			}
			
			//Check for development environment set defaults 
			if(!development) {
				basePath	= (this.loaderInfo.parameters.basePath) ? this.loaderInfo.parameters.basePath : 'flash/';
				control		= (this.loaderInfo.parameters.control) ? this.loaderInfo.parameters.control : 'XML/control.xml';
				flashVars	= this.loaderInfo.parameters;
			}
		}
		
		/** @private **/
		private function onLoadControl(e:ModelEvent):void {
			var ctrlData:Object	= e.data;
			
			_siteXML 	= new XML(ctrlData.data);
			
			var sWidth:int	= int(_siteXML.attribute('width')) == 0 ? stage.stageWidth : int(_siteXML.attribute('width'));
			var sHeight:int	= int(_siteXML.attribute('height')) == 0 ? stage.stageHeight : int(_siteXML.attribute('height'));
			title			= (_siteXML.attribute('title') == undefined) ? 'Untitled' : _siteXML.attribute('title');
			
			if(sWidth > 0 && sHeight > 0) {
				//Set Stage size
				graphics.clear();
				graphics.beginFill(0x000000, 0);
				graphics.drawRect(0, 0, sWidth, sHeight);
				graphics.endFill();
			}
			
			data.width	= sWidth;
			data.height	= sHeight;
			
			//Cleanup
			_pageData.removeEventListener(ModelEvent.LOADED, onLoadControl);
			_pageData.removeEventListener(ModelEvent.ERROR, onErrorControl);
			_pageData	= null;
			ctrlData	= null;
			
			//Build Site
			buildSite();
		}
		
		/** @private **/
		private function onErrorControl(e:ModelEvent):void {
			trace('ERROR: Loading control XML. ', e.data.url);
			
			_siteXML 	= null;
			
			//Cleanup
			_pageData.removeEventListener(ModelEvent.LOADED, onLoadControl);
			_pageData.removeEventListener(ModelEvent.ERROR, onErrorControl);
			_pageData	= null;
		}
		
		//Load site
		public function buildSite():void {
			//Add attributes
			var attr:XMLList		= _siteXML.attributes();
			var attrObj:Object;
			var attrName:String;
			var attLen:int			= attr.length();
			var ignore:Vector.<String>	= new Vector.<String>();
			var g:int;
			
			if(development) {
				ignore.push('basePath');
			}
			
			ignore.push('background');
			
			for(g=0; g<attLen; g++) {
				attrObj		= attr[g].name();
				attrName	= attrObj.localName;
				
				if(ignore.indexOf(attrName) < 0) {
					if(attrName in this) {
						this[attrName] = String(attr[g]);
					}
				}
				
				data[attrName] = String(attr[g]);
				
				attrObj		= null;
				attrName	= null;
			}
			
			//Set defaults
			data.preload	= ('preload' in data && data.preload == 'true') ? true : false;
			data.load		= ('load' in data) ? data.load : 'all';
			data.xmlPath	= ('xmlPath' in data) ? data.xmlPath : 'XML/Pages/';
			
			if(data.background != undefined) {
				buildBackground();
			}
			
			//Get languages for localization
			if(data.languages != undefined) {
				var lang:Array	= data.languages.split(',');
				var langLen:int	= lang.length;
				
				for(g=0; g<langLen; g++) {
					lang[g]	= LGString.trim(lang[g]);
				}
				
				data.languages	= lang;
			}
			
			//Build Throbber
			if(_siteXML.throbber) {
				var throbObj:Object	= {};
				
				throbObj.color		= (_siteXML.throbber.attribute('color').toString() != '') ? _siteXML.throbber.attribute('color').toString() : 0x808080;
				throbObj.speed		= (_siteXML.throbber.attribute('speed').toString() != '') ? Number(_siteXML.throbber.attribute('speed').toString()) : 1000;
				throbObj.leafSize	= (_siteXML.throbber.attribute('leafSize').toString() != '') ? Number(_siteXML.throbber.attribute('leafSize').toString()) : 4;
				throbObj.leafCount	= (_siteXML.throbber.attribute('leafCount').toString() != '') ? Number(_siteXML.throbber.attribute('leafCount').toString()) : 12;
				throbObj.leafRadius	= (_siteXML.throbber.attribute('leafRadius').toString() != '') ? Number(_siteXML.throbber.attribute('leafRadius').toString()) : 10;
				
				buildThrobber(throbObj);
			}
			
			//Google Analytics
			if(data.analytics) {
				data.visualTracker	= (data.visualTracker || data.visualTracker == 'true') ? true : false;
				tracker = new Analytics({view:this, id:data.analytics, visual:data.visualTracker});
			}
			
			//Pages
			_pagesLoaded	= 0;
			numPages 		= _siteXML.elements('page').length();
			
			//Start loading page nodes
			loadPage();
		}
		
		/** @private **/
		protected function buildThrobber(obj:Object=null):void {
			//Throbber
			preloader	= new Preloader({id:'preloader', position:'center'});
			addChild(preloader);
			preload(true, 0);
		}
		
		public function preload(show:Boolean, percent:Number=0):void {
			if(preloader) {
				if(show) {
					preloader.start();
					preloader.show(.3);
				} else {
					preloader.hide(.3);
					preloader.stop();
				}
			}	
		}
		
		/** @private **/
		private function loadPage():void {
			var children:XMLList	= _siteXML.elements('page');
			var item:XML			= children[_loadIdx];
			
			if(!item) {
				return;
			}
			
			var pageObj:Object	= {};
			
			//Set defaults
			pageObj.basePath	= basePath;
			pageObj.packagePath	= 'com.view';
			pageObj.ext			= 'Page';
			pageObj.flashVars	= {};
			pageObj.hidden		= true;
			pageObj.src			= '';
			
			//Load page attributes
			var attr:XMLList	= item.attributes();
			var attLen:int		= attr.length();
			var attrObject:Object;
			var attrName:String;
			
			//Set flashVars
			if(!development) {
				pageObj.flashVars	= this.loaderInfo.parameters;
			}
			
			//Set xml attributes
			for(var g:int=0; g<attLen; g++) {
				attrObject			= attr[g].name();
				attrName			= attrObject.localName;
				var value:String	= String(attr[g]);
				
				if(value == 'true') {
					pageObj[attrName]	= true;
				}
				else if(value == 'false') {
					pageObj[attrName]	= false;
				}
				else if(!isNaN(Number(value))) {
					pageObj[attrName]	= Number(value);
				} else {
					pageObj[attrName]	= value;
				}
			}
			
			if(pageObj.packagePath != '') {
				pageObj.packagePath += '.';
			}
			
			attrObject		= null;
			attrName		= null;
			_pagesExt		= pageObj.ext;
			pageObj.name	= pageObj.id + pageObj.ext;
			pageObj.shell	= this;
			pageObj.stage	= stage;
			
			_pages[pageObj.id]		= pageObj;
			
			pageInfo.push(pageObj.id);
			_readyToBuild.push(pageObj.id);
			
			//Save the first page id
			if(_loadIdx == 0) {
				_firstID			= pageObj.id;
			}
			
			_loadIdx++;
			
			//Load the rest of the page nodes
			if(_loadIdx < numPages) {
				loadPage();
			}
			//When done, start building the first page
			else if(_loadIdx == numPages) {
				open(_firstID);
				_firstID	= null;
			}
		}
		
		/** @private **/
		private function buildPage(id:String):Page {
			var pageObj:Object		= _pages[id] as Object;
			
			if(!pageObj) {
				return null;
			}
			if(pageObj.autoSize == undefined) {
				pageObj.autoSize	= true;
			}
			
			if(pageObj.autoSize) {
				if(pageObj.width == undefined) {
					pageObj.width		= data.width;
				}
				
				if(pageObj.height == undefined) {
					pageObj.height		= data.height;
				}
			}
			
			preload(true, 0);
			
			//Create page
			var className:String	= pageObj.packagePath + pageObj.id + pageObj.ext;
			var controller:Class;
			
			try {
				controller	= getDefinitionByName(className) as Class;
			}
			catch(e:Error) {
				trace('ERROR: Cannot find ' + className + ' . Make sure it is defined in the Shell.');
				return null;
			}
			
			var page:Page			= new controller(pageObj) as Page;
			
			//Create name for page
			page.id					= pageObj.id;
			page.name				= pageObj.id + pageObj.ext;
			
			//Listen for a setup complete call
			page.addEventListener('page_loaded', onPageLoad);
			
			//Use specific language is using language support
			var langPath:String		= '';
			
			if(data.languages != undefined && data.languages.length > 0) {
				var langLen:int			= data.languages.length;
				var useDefault:Boolean	= false;
				
				if(langLen > 1) {
					var langIdx:int	= data.languages.indexOf(language);
					
					if(langIdx < 0) {
						langPath	= data.languages[langIdx];
					} else  {
						useDefault	= true;
					}
				} else  {
					useDefault	= true;
				}
				
				if(useDefault) {
					langPath	= data.languages[0];
				}
				
				langPath += '/';
			}
			
			//Load XML
			if(pageObj.src != '') {
				page.loadXML(pageObj.src);
			} else {
				page.loadXML(data.xmlPath + langPath + pageObj.id + 'Page.xml');
			}
			
			//Set design mode
			if(_designMode) {
				page.designMode	= true;
			}
			
			
			//Keep track of overlays
			if(pageObj.overlay) {
				page.isOverlay	= true;
			}
			
			//Add page to stage
			addChild(page);
			
			pages[pageObj.id]	= page;
			_id[_pageIdx]		= pageObj.id;
			_pageIdx++;
			
			return page;
		}
		
		/** @private **/
		private function onPageLoad(e:PageEvent):void {
			var page:Page = e.target as Page;
			
			//Cleanup
			page.removeEventListener('page_loaded', onPageLoad);
			
			//Adjust alignment
			if(page.isSetup && page.autoSize) {
				page.update({width:stage.stageWidth, height:stage.stageHeight});
			}
			else if(page.isSetup) {
				page.update();
			}
			
			//Break here if already completed initial load
			if(isSetup) {
				return;
			}
			
			//Build rest of pages
			var finishLoad:Boolean	= false;
			
			if(data.load == 'all') {
				if(_pageIdx < numPages) {
					var pageID:String	= _readyToBuild[_pageIdx];
					open(pageID);
				}
				else if(_pageIdx == numPages) {
					_readyToBuild	= null;
					finishLoad		= true;
				}
			} else {
				finishLoad	= true;
			}
			
			//If finished building, show first page
			if(finishLoad) {
				isSetup	= true;
				preload(false);
				trigger('page_loaded');
			}
		}
		
		/** @private **/
		public function getPage(pageName:String):Page {
			var page:Page = getChildByName(pageName + _pagesExt) as Page;
			
			if(!page) {
				page = buildPage(pageName);
			}
			
			return page;
		}
		
		//Page Order
		public function pageToFront(pageName:String):void {
			var page:Page = getPage(pageName);
			
			if(page && contains(page)) {
				setChildIndex(page, numChildren-1);
			}
			
			//Cleanup
			page = null;
		}
		public function pageToBack(pageName:String):void {
			var page:Page = getPage(pageName);
			
			if(contains(page)) {
				setChildIndex(page, 0);
			}
			
			//Cleanup
			page = null;
		}
		
		/** @private **/
		private function onResize(e:Event=null):void {
			var page:Page;
			var pageLen:int	= _id.length;
			
			for(var g:int=0; g<pageLen; g++) {
				page = getPage(_id[g]);
				
				if(page.isSetup && page.autoSize) {
					page.update({width:stage.stageWidth, height:stage.stageHeight});
				}
				else if(page.isSetup) {
					page.update();
				}
			}
			
			if(background) {
				background.update();
			}
		}
		
		/** @private **/
		private function onFullscreen(e:FullScreenEvent=null):void {
			var page:Page;
			var pageLen:int	= _id.length;
			
			for(var g:int=0; g<pageLen; g++) {
				page = getPage(_id[g]);
				
				if(page.isSetup) {
					page.update({width:Capabilities.screenResolutionX, height:Capabilities.screenResolutionY, verticalCenter:false, horizontalCenter:false});
				}
			}
			
		}
		
		public override function open(pageName:String, params:Object=null, pageData:Object=null):void {
			var page:Page = getPage(pageName);
			
			if(!page) {
				return;
			}
			
			//If page is already open, just bring to front
			_currentPage	= pageName;
			var openLen:int	= _openedPages.length;
			
			if(_openedPages.indexOf(pageName) >= 0) {
				page.toFront();
				return;
			}
			
			//Set Attributes
			if(pageData) {
				page.setAttributes(pageData);
			}
			
			//Make sure the shell knows this page is the current page
			_openedPages.push(pageName);
			
			if(!development) {
				//Track
				if(tracker && page.track) {
					tracker.trackPage(pageName);
				}
				
				if(page.deepLink) {
					//Set new title
					var pageTitle:String	= title + ' :: ' + page.title;
					SWFAddress.setTitle(pageTitle);
					
					//SWFAddress
					var pageID:String		= page.id;
					var depth:int			= 0;
					var path:String			= '';
					
					if (pageID != SWFAddress.getPathNames()[depth]) {
						var parts:Array	= [];
						
						if (path != '') {
							parts.push(path);
						}
						
						if (pageID != '') {
							parts.push(pageID);
						}
						
						SWFAddress.setValue('/' + parts.join('/'));
					}
				}
			}
			
			if(!page.autoClose) {
				data.needOpen++;
			}
			
			if(page.isOverlay) {
				_overlays.push(page.id);
			}
			
			numOpen++;
			
			if(page.isSetup) {
				page.isOpen	= true;
				page.transitionIn();
			} else {
				page.bind('page_loaded', onPageXMLLoad);
			}
			
			//Cleanup site
			cleanUp();
		}
		
		private function onPageXMLLoad(e:PageEvent):void {
			var page:Page	= e.target as Page;
			page.unbind('page_loaded', onPageXMLLoad);
			page.isOpen	= true;
			page.transitionIn();
		}
		
		public override function close(pageName:String, params:Object=null):void {
			var page:Page = getPage(pageName);
			
			if(!page) {
				return;
			}
			
			var openIdx:int	= _openedPages.indexOf(pageName);
			
			if(openIdx >= 0) {
				_openedPages.splice(openIdx, 1);
			}
			
			if(params && params.autoClose) {
				page.data.openPage	= params.openPage;
				page.data.openData	= params;
				page.bind('page_close', onPageAutoClose);
			} else {
				page.bind('page_close', onPageClose);
			}
			
			
			if(!page.autoClose) {
				data.needOpen--;
			}
			
			if(page.isOverlay) {
				var idx:int	= _overlays.indexOf(page.id);
				
				if(idx >= 0) {
					_overlays.splice(idx, 1);
				}
			}
			
			numOpen--;
			page.isOpen	= false;
			page.transitionOut();
		}
		
		/** @private **/
		private function onPageAutoClose(e:PageEvent):void {
			var page:Page		= e.target as Page;
			//onOpenPage(page.data.openPage, page.data.openData);
		}
		
		/** @private **/
		private function onPageClose(e:PageEvent):void {
			var page:Page		= e.target as Page;
			
			if(data.load == 'single' && contains(page)) {
				removeChild(page);
			}
		}
		
		/** @private **/
		private function cleanUp():void {
			//Close any unused pages
			if(numOpen > data.needOpen) {
				var closing:int	= numOpen - data.needOpen;
				var loaded:int	= _id.length;
				var page:Page;
				//var currentPage:String	= (_openedPages.length > 0) ? _openedPages[_openedPages.length-1] : '';
				
				while(closing) {
					loaded--;
					
					if(loaded >= 0) {
						page	= pages[_id[loaded]];
						
						if(page.isOpen && page.autoClose) {
							if(page.id != _currentPage) {
								close(page.id);
							}
							
							closing--;
						}
					} else {
						closing	= 0;
					}
				}
			}
			
			var overlayLen:int	= _overlays.length;
			
			//Keep all overlays to top
			for(var g:int=overlayLen-1; g>=0; g--) {
				var overlay:Page	= getPage(_overlays[g]);
				overlay.toFront();
			}
		}
		
		/** @private **/
		private function onSWFAddress(e:SWFAddressEvent):void {
			var pageName:String	= parsePageURL(e.value);
			
			if(pageName != '') {
				open(pageName);
			}
		}
		
		/** @private **/
		private function parsePageURL(pageURL:String):String {
			var pageArr:Array	= pageURL.split('/');
			var pageLen:int		= pageArr.length;
			var pageName:String	= '';
			
			if(pageLen) {
				pageName	= pageArr[pageLen-1];
			}
			
			return pageName;
		}
		
		public function get queryParams():Object {
			var fullurl:String	= ExternalInterface.call('window.location.href.toString');
			var query:Array		= [];
			var params:Object	= {};
			
			if(fullurl){
				query	= fullurl.split('?');
				
				if(query.length > 1) {		
					var varStr:String	= query[1];
					var varsArray:Array	= varStr.split('&');
					var qryLen:int		= varsArray.length;
					
					for (var g:int=0; g<qryLen; g++){
						var index:int		= 0;
						var kvPair:String	= varsArray[g];
						
						if((index = kvPair.indexOf('=')) > 0){
							var key:String		= kvPair.substring(0,index);
							var value:String	= kvPair.substring(index + 1);
							params[key] = value;
						}
					}
				}
			}
			
			return params;
		}
		
		public function set language(value:String):void {
			data.language	= value;
		}
		public function get language():String {
			if(data.language == undefined) {
				return Capabilities.language;
			} else {
				return data.language;
			}
		}
	}
}
