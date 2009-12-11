/**
* FileLoader Class by Giraldo Rosales.
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
	//Flash Classes
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	
	//LG Classes
	import lg.flash.elements.Element;
	
	public class FileLoader extends Element {
		private var _ldr:URLLoader	= new URLLoader();
		
		public function FileLoader(req:URLRequest=null) {
			_ldr = new URLLoader(req);
			_ldr.addEventListener('activate', onInit, false, 0, true);
			_ldr.addEventListener('complete', onLoaded, false, 0, false);
			_ldr.addEventListener('deactivate', onDeactivate, false, 0, true);
			_ldr.addEventListener('httpStatus', onHttpStatus, false, 0, true);
			_ldr.addEventListener('ioError', onIOError, false, 0, true);
			_ldr.addEventListener('open', onOpen, false, 0, true);
			_ldr.addEventListener('progress', onProgress, false, 0, true);
			_ldr.addEventListener('securityError', onSecurityError, false, 0, true);
		}
		
		
		/** Load an external data file.
		*	@param req URLRequest variable. **/ 
		public function load(req:URLRequest):void {
			data.url	= req.url;
			_ldr.load(req);
		}
		
		/** @private **/
		private function onInit(e:Event):void {
			trigger('element_init', e);
		}
		
		/** @private **/
		private function onOpen(e:Event):void {
			trigger('element_open', e);
		}
		/** Add an= file open error event listener 
		*	@param fn Function to call. **/ 
		public function open(fn:Function):Element {
			bind('element_open', fn);
			return this;
		}
		
		/** @private **/
		private function onLoaded(e:Event):void {
			data.results = _ldr.data;
			trigger('element_loaded', e);
		}
		
		/** @private **/
		private function onDeactivate(e:Event):void {
			trigger('element_unload', e);
		}
		
		/** @private **/
		private function onHttpStatus(e:HTTPStatusEvent):void {
			trigger('element_update', e);
		}
		
		/** @private **/
		private function onIOError(e:IOErrorEvent):void {
			trigger('element_io_error', e);
		}
		/** Add a input/output error event listener 
		*	@param fn Function to call. **/ 
		public function ioerror(fn:Function):Element {
			bind('element_io_error', fn);
			return this;
		}
		
		/** @private **/
		private function onSecurityError(e:SecurityErrorEvent):void {
			trigger('element_security_error', e);
		}
		/** Add a security error event listener 
		*	@param fn Function to call. **/ 
		public function securityerror(fn:Function):Element {
			bind('element_security_error', fn);
			return this;
		}
	}
}