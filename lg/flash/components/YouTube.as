﻿/**
* YouTube Class by Giraldo Rosales.
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

package lg.flash.components {
	//Flash
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;
	
	import lg.flash.elements.Image;
	import lg.flash.elements.Shape;
	import lg.flash.elements.Video;
	import lg.flash.events.ElementEvent;
	import lg.flash.events.ModelEvent;
	import lg.flash.model.google.YouTubeData;
		
	/**
	 * Dispatched when there is a player error.
	 * @eventType lg.flash.events.ElementEvent.ERROR
	 */
	[Event(name="onError", type="lg.flash.events.ElementEvent")]
	
	/**
	 * Dispatched when the player state changes
	 * @eventType lg.flash.events.ElementEvent.UPDATE
	 */
	[Event(name="onStateChange", type="lg.flash.events.ElementEvent")]
	
	/**
	 * Dispatched when the movie content changes as a result from loading a new movie
	 * @eventType lg.flash.events.ElementEvent.UPDATE
	 */
	[Event(name="onMovieStateUpdate", type="lg.flash.events.ElementEvent")]
	
	/**
	 * Dispatched as movie playback makes progress, can get updates of current playback time
	 * @eventType lg.flash.events.ElementEvent.PROGRESS
	 */
	[Event(name="onMovieProgress", type="lg.flash.events.ElementEvent")]
	
	/**
	 * Dispatched when the player is ready to load videos and receive commands.
	 * @eventType lg.flash.events.ElementEvent.COMPLETE
	 */
	[Event(name="onPlayerReady", type="lg.flash.events.ElementEvent")]
	
	/**
	 * Dispatched when the player is unloaded, and safe to remove from stage.
	 * @eventType lg.flash.events.ElementEvent.UNLOAD
	 */
	[Event(name="onPlayerUnload", type="lg.flash.events.ElementEvent")]
	
	public class YouTube extends Video {
		/** YouTube API Player */
		public var player:Object;
		public var info:Object	= {};
		
		/** @private **/
		private var _ytLoader:Loader;
		/** @private **/
		private var _playerURL:String	= 'http://www.youtube.com/apiplayer?version=3';
		
		public function YouTube(obj:Object):void {
			obj.type		= 'youtube';
			obj.ytID		= (obj.ytID != undefined) ? obj.ytID : '';
			
			obj.src			= (obj.src != undefined) ? obj.src : '';
			obj.start		= (obj.start != undefined) ? obj.start : 0;
			obj.trim		= (obj.trim != undefined) ? obj.trim : 0;
			obj.quality		= (obj.quality != undefined) ? obj.quality : 'default';
			
			super(obj);
			holder();
			
			data.state		= -2;
			data._isReady	= false;
			data._isPaused	= false;
			
			var req:URLRequest	= new URLRequest(_playerURL);
			
			if(Capabilities.playerType != 'Desktop') {
				Security.allowDomain('www.youtube.com');
			}	
				_ytLoader	= new Loader();
				_ytLoader.contentLoaderInfo.addEventListener(Event.INIT, onInitLoader);
				_ytLoader.load(req);
			/*} else {
				var ldr:URLLoader	= new URLLoader();
				ldr.addEventListener(Event.COMPLETE, onLoadSWF);
				ldr.load(req);
			}
			*/
			resetSize();
		}
		/*
		private function onLoadSWF(e:Event):void {
			var ldr:URLLoader			= e.target as URLLoader;
			var bytes:ByteArray			= ldr.data;
			var context:LoaderContext	= new LoaderContext(false, this.loaderInfo.applicationDomain);
			context.allowLoadBytesCodeExecution	= true;
			context.applicationDomain	= this.loaderInfo.applicationDomain;
			
			_ytLoader	= new Loader();
			_ytLoader.contentLoaderInfo.addEventListener(Event.INIT, onInitLoader);
			_ytLoader.loadBytes(bytes, context);
		}
		*/
		private function onInitLoader(e:Event):void {
			trace('YouTube::onInitLoader');
			addChild(_ytLoader);
			
			_ytLoader.content.addEventListener('onReady', onPlayerReady);
			_ytLoader.content.addEventListener('onError', onPlayerError);
			_ytLoader.content.addEventListener('onStateChange', onPlayerStateChange);
			_ytLoader.content.addEventListener('onPlaybackQualityChange', onVideoPlaybackQualityChange);
		}

		private function onPlayerReady(e:Event):void {
			if(_ytLoader) {
				player 	= _ytLoader.content;
			}
			
			if(data.src != '') {
				data._isReady	= true;
				load(data.src, data.start, data.quality);
			}
			else if(data.ytID != '') {
				data._isReady	= false;
				loadID(data.ytID, data.start, data.quality);
			}
		}
		
		private function onLoadedData(e:ModelEvent):void {
			data._isReady	= true;
			
			var results:Object	= e.data as Object;
			info				= results.video as Object;
			
			var thumbs:Array	= info.thumbnail as Array;
			var thumbLen:int	= thumbs.length;
			
			if(thumbLen > 0) {
				var thumbObj:Object	= thumbs[thumbLen-1] as Object;
				data.thumbnailSrc	= thumbObj.url;
			}
			
			if(data.thumbnailSrc != '') {
				if(thumbnail) {
					thumbnail.load(data.thumbnailSrc);
				} else {
					thumbnail	= new Image({id:'thumbnail', src:data.thumbnailSrc, basePath:basePath, width:width, height:height});
					thumbnail.loaded(onLoadThumb);
					addChild(thumbnail);
				}
			} else {
				trigger('element_loaded');
			}
		}
		private function onLoadThumb(e:ElementEvent):void {
			thumbnail.unbind('element_loaded', onLoadThumb);
			
			if(overlay) {
				overlay.toFront();
			}
			
			trigger('element_loaded');
		}
		
		private function onPlayerError(e:Event):void {
			var playerObj:Object	= e as Object;
			
			trace("YouTube Error:", playerObj.data);
			trigger('element_error', playerObj.data);
		}

		private function onPlayerStateChange(e:Event):void {
			var playerObj:Object	= e as Object;
			data.state				= playerObj.data;
			
			trace('YouTube::onPlayerStateChange', data.state);
			switch(data.state) {
				case -1:
					data.stateDesc	= "Unstarted";
					data._isPlaying	= false;
					data._isStopped	= true;
					data._isPaused	= true;
					player.setSize(width, height);
					
					trigger('element_loaded');
					break;
				case 0:
					data.stateDesc	= "Stopped";
					data._isPlaying	= false;
					data._isStopped	= true;
					_updateTimer.stop();
					trigger('element_stop');
					break;
				case 1:
					data.stateDesc	= "Playing";
					
					if(!data._isPlaying) {
						data._isPlaying	= true;
						data._isPaused	= false;
						data._isStopped	= false;
						
						_updateTimer.start();
						trigger('element_play');
					}
					break;
				case 2:
					if(!data._isPaused) {
						data.stateDesc = "Paused";
						data._isPlaying	= false;
						data._isPaused	= true;
						_updateTimer.stop();
						trigger('element_pause');
					}
					break;
				case 3:
					data.stateDesc = "Buffering";
					trigger('video_buffering');
					break;
				case 5:
					data.stateDesc = "Queued";
					data._isPlaying	= false;
					data._isStopped	= true;
					data._isPaused	= true;
					trigger('video_queued');
					break;
				default:
					data.stateDesc = "No state reported yet";
					break;
			}
			
			trigger('element_change', {stateCode:data.state, description:data.stateDesc});
		}
		
		private function onVideoPlaybackQualityChange(event:Event):void {
			trace("video quality:", Object(event).data);
		}

		/**
		 * Loads a particular video by url
		 *
		 * @param	id:		ID of an existing youtube movie
		 * @param	seconds	Seconds in to start playing
		 */
		public override function load(url:String, seconds:Number=0, quality:String='default', forceLoad:Boolean=false):void {
			if(player) {
				if (autoPlay || forceLoad) {
					player.loadVideoByUrl(data.src, data.start, data.quality);
				} else {
					player.cueVideoByUrl(data.src, data.start, data.quality);
				}
			}
		}

		/**
		 * Loads a particular video by id
		 *
		 * @param	id:		ID of an existing youtube movie
		 * @param	seconds	Seconds in to start playing
		 */
		public function loadID(id:String, seconds:Number=0, quality:String='default', forceLoad:Boolean=false):void {
			if(player) {
				if(autoPlay || forceLoad) {
					player.loadVideoById(id, seconds, data.quality);
				} else {
					player.cueVideoById(data.ytID, seconds, data.quality);
				}
			}
		}
		
		public override function set width(value:Number):void {
			data.width	= value;
			resetSize();
		}
		public override function get width():Number {
			return data.width;
		}
		
		public override function set height(value:Number):void {
			data.height	= value;
			resetSize();
		}
		public override function get height():Number {
			return data.height;
		}
		
		public function set quality(value:String):void {
			data.quality	= value;
			
			if(player) {
				player.setPlaybackQuality(value);
			}
		}
		public function get quality():String {
			if(player) {
				data.quality	= player.getPlaybackQuality();
			}
			
			return data.quality;
		}
		
		/** Bytes loaded **/
		public override function get bytesLoaded():Number {
			var value:Number	= 0;
			
			if(player) {
				value	= player.getVideoBytesLoaded();
			}
			
			return value;
		}
		
		/** Bytes total **/
		public override function get bytesTotal():Number {
			var value:Number	= 0;
			
			if(player) {
				value	= player.getVideoBytesTotal();
			}
			
			return value;
		}
		
		/** Current position of playhead, in seconds. **/
		public override function get current():Number {
			var value:Number	= 0;
			
			if(player) {
				value	= player.getCurrentTime();
			}
			
			return value;
		}
		
		/** Length of video in seconds **/
		public override function get duration():Number {
			var value:Number	= 0;
			
			if(player) {
				value	= player.getDuration();
			}
			
			return value;
		}
		
		/** YouTube.com URL for the currently loaded/playing video **/
		public function get url():String {
			var value:String	= '';
			
			if(player) {
				value	= player.getVideoUrl();
			}
			
			return value;
		}
		
		/** Embed code for the currently loaded/playing video **/
		public function get embedCode():String {
			var value:String	= '';
			
			if(player) {
				value	= player.getVideoEmbedCode();
			}
			
			return value;
		}
		
		/** Video is ready to receive commands. **/
		public function get isReady():Number {
			return data._isReady;
		}
		
		/** @private */
		protected override function onUpdateVideo(e:TimerEvent):void {
			var updateObj:Object	= {};
			
			if(player) {
				updateObj.bytesLoaded	= player.getVideoBytesLoaded();
				updateObj.bytesTotal	= player.getVideoBytesTotal();
				updateObj.bytesStart	= player.getVideoStartBytes();
				updateObj.volume		= player.getVolume() / 100;
				updateObj.playerState	= player.getPlayerState();
				updateObj.currentTime	= player.getCurrentTime();
				updateObj.duration		= player.getDuration();
				updateObj.muted			= player.isMuted();
				updateObj.state			= player.getPlayerState();
			}
			
			trigger('element_update', updateObj);
		}
		
		/**
		 * sizes the youtube movie
		 */
		public override function setSize(w:Number, h:Number):void {
			data.width	= w;
			data.height	= h;
			
			resetSize();
		}
		public function resetSize():void {
			if(!isSetup) {
				return;
			}
			
			graphics.clear();
			graphics.beginFill(backgroundColor, backgroundAlpha);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
			
			if(player && data.state >= -1) {
				player.setSize(width, height);
			}
		}
		
		/** Stops the video */
		public override function play():void {
			if(player) {
				player.playVideo();
			}
		}
		
		/** Stops the video */
		public override function stop():void {
			if(player) {
				rewind();
				player.pauseVideo();
			}
		}

		/** Rewinds the video to the beginning */
		public override function rewind():void {
			if(player) {
				player.seekTo(0, true);
			}
		}

		/** Plays the video */
		public override function seek(time:Number):void {
			if(player) {
				player.seekTo(time, true);
			}
		}

		/** Pauses the video */
		public override function pause():void {
			if(player) {
				player.pauseVideo();
			}
		}
		
		/** Sets the volume control setting from no volume (0) to max volume (1).  **/
		public override function set volume(vol:Number):void {
			if(player) {
				player.setVolume(vol);
			}
		}
		public override function get volume():Number {
			var value:Number	= 0;
			
			if(player) {
				player.getVolume();
			}
			
			return value;
		}
		
		/** Mutes the movie */
		public override function set mute(value:Boolean):void {
			if(player) {
				if(value) {
					player.mute();
				} else {
					player.unMute();
				}
			}
		}
		public override function get mute():Boolean {
			return player.isMuted();
		}
		
		public override function kill():void {
			clean();
			super.kill();
		}
	}
}