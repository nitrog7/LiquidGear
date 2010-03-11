/**
* Flash Class by Giraldo Rosales.
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

package lg.flash.elements {
	import flash.display.AVM1Movie;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import lg.flash.events.ElementEvent;
	
	
	/**
	* Dispatched when a video begins to play.
	* @eventType mx.events.ElementEvent.PLAY
	*/
	[Event(name="element_play", type="lg.flash.events.ElementEvent")]
	
	/**
	* Dispatched when a video stops.
	* @eventType mx.events.ElementEvent.STOP
	*/
	[Event(name="element_stop", type="lg.flash.events.ElementEvent")]
	
	
	/**
	*	<p>Loads external SWF files. Can also be used to wrap around existing
	*	MovieClips, give it all the functionality of the Flash object.</p>
	*	<p>If a SWF that was published using AS2 is loaded, you will not be able
	*	to manipulate or control it directly.</p>
	**/
	public class Flash extends VisualElement {
		//public var alt:String			= '';
		/** Relative path to the SWF file. **/
		public var src:String			= '';
		/** Indicates whether the swf or MovieClip is currently playing. **/
		public var isPlaying:Boolean	= false;
		/** Indicates whether the swf or MovieClip is usiong AS3. **/
		public var isAS3:Boolean		= false;
		/** The ApplicationDomain of the loaded MovieClip. **/
		public var domain:ApplicationDomain;
		
		/** @private **/
		private var _ldr:Loader;
		
		/** 
		*	Constructs a new Flash object
		*	@param obj	Object containing all properties to construct the class.	
		**/
		public function Flash(obj:Object) {
			super();
			
			mouseEnabled	= false;
			mouseChildren	= true;
			
			//Set Defaults
			data.x			= 0;
			data.y			= 0;
			data.stretch	= true;
			
			//Set Attributes
			setAttributes(obj);
			
			if(src != '') {
				load(src);
			}
			
			isSetup = true;
		}
		
		/**
		 * Load an external SWF file.
		 * @param src	URL to the SWF file.
		 */		
		public function load(src:String):void {
			trace('Flash::load');
			this.src	= src;
			var req:URLRequest		= new URLRequest(basePath+src);
			
			var lc:LoaderContext	= new LoaderContext();
			lc.checkPolicyFile		= true;
			
			_ldr = new Loader();
			_ldr.contentLoaderInfo.addEventListener(Event.INIT, onInit);
			_ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded);
			_ldr.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_ldr.load(req, lc);
		}
		
		/** @private **/
		private function onLoadElement(e:ElementEvent):void {
			trigger('element_loaded');
		}
		
		/** @private **/
		private function onInit(e:Event):void {
			trigger('element_init', e);
		}
		
		/** @private **/
		private function onLoaded(e:Event):void {
			var obj:DisplayObject	= _ldr.content as DisplayObject;
			isAS3	= true;
			
			if(obj is MovieClip || obj is Sprite) {
				var info:LoaderInfo	= _ldr.contentLoaderInfo;
				domain	= info.applicationDomain;
			}
			
			if(obj is AVM1Movie) {
				isAS3	= false;
				flash	= _ldr;
			} else {
				flash	= obj;
			}
		}
		
		/** Contains the loaded DisplayObject **/
		public function get flash():DisplayObject {
			var obj:DisplayObject	= data.flash as DisplayObject;
			return obj;
		}
		public function set flash(value:DisplayObject):void {
			clean();
			
			if(!value) {
				return;
			}
			
			data.flash	= value;
			addChild(value);
			
			//Set size to content if not already set
			_layout.width	= 0;
			if(data.width != undefined && data.width > 0) {
				width	= data.width;
			} else {
				width	= value.width;
			}
			
			_layout.height	= 0;
			if(data.height != undefined && data.height > 0) {
				height	= data.height;
			} else {
				height	= value.height;
			}
			
			if(flash is Element) {
				var element:Element	= value as Element;
				element.loaded(onLoadElement);
			}
			else if(value is MovieClip) {
				var mc:MovieClip	= value as MovieClip;
				
				if(data.autoPlay && data.autoPlay == 'true') {
					mc.play();
				} else {
					mc.gotoAndStop(0);
				}
				
				trigger('element_loaded');
			} else {
				trigger('element_loaded');
			}
		}
		
		/** @private **/
		private function onError(e:IOErrorEvent):void {
			trigger('element_io_error', e);
			trace('IO Error: '+e.text);
			
			//Cleanup
			removeLoader();
		}
		
		/** @private **/
		private function removeLoader():void {
			if(_ldr) {
				_ldr.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoaded);
				_ldr.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
				_ldr.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
				
				_ldr.unload();
				
				if(contains(_ldr)) {
					removeChild(_ldr);
				}
			}
			
			_ldr	= null;
		}
		
		/** Plays the MovieClip. **/
		public function play():void {
			var mc:MovieClip	= flash as MovieClip;
			
			if(mc) {
				isPlaying	= true;
				mc.play();
				
				if(!isPlaying) {
					isPlaying = true;
					trigger('element_play');
				}
			}
		}
		
		/** Stops the MovieClip. **/
		public function stop():void {
			var mc:MovieClip	= flash as MovieClip;
			
			if(mc) {
				mc.stop();
				
				if(isPlaying) {
					isPlaying = false;
					trigger('element_stop');
				}
			}
		}
		
		/** Starts playing the MovieClip at the specified frame. **/
		public function gotoAndPlay(frame:Object):void {
			var mc:MovieClip	= flash as MovieClip;
			
			if(mc) {
				isPlaying	= true;
				mc.gotoAndPlay(frame);
				
				if(!isPlaying) {
					isPlaying = true;
					trigger('element_play');
				}
			}
		}
		
		/** Brings the playhead to the specified frame and stops it. **/
		public function gotoAndStop(frame:Object):void {
			var mc:MovieClip	= flash as MovieClip;
			
			if(mc) {
				mc.gotoAndStop(frame);
				
				if(isPlaying) {
					isPlaying = false;
					trigger('element_stop');
				}
			}
		}
		
		/** Clean up element and restore to empty state **/
		public function clean():void {
			if(flash) {
				if(contains(flash)) {
					removeChild(flash);
				}
			}
			
			data.flash	= null;
		}
		
		/** Kill the object and clean from memory. **/
		public override function kill():void {
			clean();
			removeLoader();
			
			src		= null;
			domain	= null;
			
			super.kill();
		}
	}
}