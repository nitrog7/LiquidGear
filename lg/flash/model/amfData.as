/**
* amfData by Giraldo Rosales.
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

package lg.flash.model {
	//Flash Classes
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.utils.Dictionary;
	import flash.system.System;
	
	//LG Classes
	import lg.flash.model.LGData;
	import lg.flash.events.ModelEvent;
	import lg.flash.net.Responder;

	public class amfData extends LGData {
		/** @private **/
		private var _connection:NetConnection;
		/** @private **/
		private var _responder:Responder;
		
		/** Load data from an AMF source. **/
		public function amfData() {
		}
		
		/** Get data. 
		*	@param name Returns all data associated with an id.
		**/
		public override function getData(id:String):Object {
			return _data[id];
		}
		
		/** Load data. 
		*	@param obj Object containing all the properties to load data from AMF.
		**/
		public override function load(obj:Object):void {
			var refresh:Boolean		= ('refresh' in obj) ? obj.refresh : false;
			var callback:Function	= ('callback' in obj) ? obj.callback : null;
			
			if(refresh || !(obj.id in _data)) {
				_responder	= new Responder(onLoaded, onFault, {id:obj.id, callback:callback});
				_connection	= new NetConnection();
				_connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
				_connection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				_connection.connect(obj.url);
				_connection.call(obj.call, _responder, obj.params);
			} else {
				onResult(obj.id);
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
		
		/** Kill the object and clean from memory. **/
		public override function kill():void {
			if(_connection.connected) {
				_connection.close();
			}
			
			_connection	= null;
			_responder	= null;
			
			super.kill();
		}
		
		/** @private **/
		private function onLoaded(result:Object, params:Object=null):void {
			var key:String	= params.id;
			params.data		= result;
			_data[key]		= params;
			
			if(_connection.connected) {
				_connection.close();
			}
			
			_connection	= null;
			_responder	= null;
			
			onResult(key);
		}
		
		/** @private **/
		private function onResult(key:String):void {
			var params:Object	= _data[key];
			params.type			= 'AMF';
			
			if(('callback' in params) && params.callback) {
				var callback:Function = params.callback;
				callback.apply(this, [params]);
			}
			
			var event:ModelEvent	= new ModelEvent(ModelEvent.LOADED);
			event.params			= params;
			event.params.data		= params.data;
			dispatchEvent(event);
		}
		
		/** @private **/
		private function onFault(fault:Object, params:Object=null):void {
			var event:ModelEvent	= new ModelEvent(ModelEvent.ERROR);
			event.params.type		= 'Fault';
			event.params.desc		= fault.description;
			dispatchEvent(event);
		}
		
		/** @private **/
		private function onSecurityError(e:SecurityErrorEvent):void {
			var event:ModelEvent	= new ModelEvent(ModelEvent.ERROR);
			event.params.type		= 'SecurityErrorEvent';
			event.event				= e;
			dispatchEvent(event);
		}
		
		/** @private **/
		private function onNetStatus(e:NetStatusEvent):void {
			trace('Net Status:', e.info.code);
		}
	}
}