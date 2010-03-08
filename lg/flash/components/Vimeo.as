/**
* Vimeo Class by Giraldo Rosales.
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

package {
	
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.system.Security;
	
	//LG
	import lg.flash.elements.Video;
	
	public class VimeoPlayer extends Video {
		private var _ldr:Loader			= new Loader();
		private var _container:Sprite	= new Sprite(); // sprite that holds the player
		private var _moogaloop:Object; // the player
		private var _maskPlayer:Sprite	= new Sprite(); // some sprites inside moogaloop go outside the bounds of the player. we use a mask to hide it
		private var _loadTimer:Timer	= new Timer(200);
		
		public function VimeoPlayer(obj:Object) {
			Security.allowDomain("http://bitcast.vimeo.com");
			
			data.videoID	= 0;
			data.width		= 400;
			data.height		= 300;
			
			//Set Attributes
			setAttributes(obj);
			
			isSetup = true;
			
			var req:URLRequest	= new URLRequest("http://bitcast.vimeo.com/vimeo/swf/moogaloop.swf?clip_id=" + data.videoID + "&width=" + data.width + "&height=" + data.height + '&fullscreen=0');
			_ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			_ldr.load(req); 
		}
		
		/** @private **/
		private function onComplete(e:Event) {
			_moogaloop		= _ldr.content;
			
			// Finished loading moogaloop
			addChild(_container);
			_container.addChild(_moogaloop);
				
			// Create the mask for moogaloop
			addChild(_maskPlayer);
			_container.mask	= _maskPlayer;
			
			redrawMask();
			 
			_loadTimer.addEventListener(TimerEvent.TIMER, playerLoadedCheck);
			_loadTimer.start();
			
			//Clean up
			_ldr.removeEventListener(Event.COMPLETE, onComplete);
			_ldr	= null;
		}
		
		/** @private **/
		private function playerLoadedCheck(e:TimerEvent):void {
			if(_moogaloop.player_loaded) {
				// Moogaloop is finished configuring
				_loadTimer.stop();
				_loadTimer.removeEventListener(TimerEvent.TIMER, playerLoadedCheck);

				// remove moogaloop's mouse listeners listener
				_moogaloop.disableMouseMove(); 
				stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				
				trigger('element_loaded');
			}
		}
		
		/** @private **/
		private function mouseMove(e:MouseEvent):void {
			if(e.stageX >= this.x && e.stageX <= this.x + data.width && e.stageY >= this.y && e.stageY <= this.y + data.height) {
				_moogaloop.mouseMove(e);
			} else {
				_moogaloop.mouseOut();
			}
		}
		
		private function redrawMask():void {
			with(_maskPlayer.graphics) {
				beginFill(0x000000, 1);
				drawRect(_container.x, _container.y, data.width, data.height);
				endFill();
			}
		}
		
		public override function play():void {
			_moogaloop.api_play();
			trigger('element_play');
		}
		
		public override function pause():void {
			_moogaloop.api_pause();
			trigger('element_pause');
		}
		
		/** Returns duration of video in seconds */
		public override function get duration():Number {
			return _moogaloop.api_getDuration();
		}
		
		/** Seek to specific loaded time in video (in seconds) */
		public override function seek(seconds:Number):void {
			_moogaloop.api_seekTo(seconds);
		}
		
		/** Change the primary color (i.e. 0xffffff) */
		public override function get backgroundColor():uint {
			return data.backgroundColor;
		}
		public override function set backgroundColor(value:uint):void {
			data.backgroundColor	= value;
			var hex:String			= value.toString(16);
			_moogaloop.api_changeColor(hex);
		}
		
		/** Load in a different video */
		public override function addVideo(videoID:String):void {
			data.videoID	= videoID;
			_moogaloop.api_loadVideo(videoID);
		}
		
		public override function setSize(w:Number, h:Number):void {
			super.setSize(w, h);
			_moogaloop.api_setSize(w, h);
			redrawMask();
		}
	}
}