/**
* Video Class by Giraldo Rosales.
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
	//Flash Classes
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	import lg.flash.events.ElementEvent;
	import lg.flash.motion.Tween;
	import lg.flash.motion.easing.Quintic;
	import lg.flash.motion.tweens.ITween;
	
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
	* Dispatched when a video is paused.
	* @eventType mx.events.ElementEvent.PAUSE
	*/
	[Event(name="element_pause", type="lg.flash.events.ElementEvent")]
	
	/**
	* Dispatched when a video has completed.
	* @eventType mx.events.ElementEvent.FINISH
	*/
	[Event(name="element_finish", type="lg.flash.events.ElementEvent")]
	
	/**
	* Dispatched while a video is playing.
	* @eventType mx.events.ElementEvent.UPDATE
	*/
	[Event(name="element_update", type="lg.flash.events.ElementEvent")]
	
	/**
	*	<p>The Video class streams in a video file.</p>
	*	<p>Supports files derived from the standard MPEG-4 container format including: 
	*	FLV, F4V, MP4, M4A, MOV, MP4V, 3GP, and 3G2 if they contain H.264 video.</p>
	*	<p>When video object is created, it adds a new stream and begins playing. If autoPlay
	*	is set to false, it will hold on pause. When play() is called, the stream begins to
	*	play, pause will hold the video at the current position, and stop() will kill the
	*	connection and clear the video from memory. Once a video is completed, it will either
	*	loop or clear the video from memory and remove it. If the play() method is called
	*	again, it will create a new stream and play again.</p>
	*	<p><em>Note: Does not work with MPG and WMV files.</em></p>
	*/
	public class Video extends VisualElement {
		//Public Vars
		/** Relative path the the video file. **/
		public var src:String				= '';
		/** Play video automatically after loaded.
		*	@default false **/
		public var autoPlay:Boolean			= false;
		/** Remove and clean video after finished playing **/
		public var autoClean:Boolean		= false;
		/** Current frames per second being displayed. **/
		public var fps:Number				= 0;
		/** Video buffer. If 1, wait till video is fully buffered before playing. If .5, wait till half the video is loaded before playing.
		*	@default 1 **/
		public var buffer:Number			= 0;
		
		//Components
		/** Netstream object used to load video stream. **/
		public var video:NetStream;
		/** Video object used to display video. **/
		public var videoClip:flash.media.Video;
		
		/** @private **/
		private var _connection:NetConnection;
		/** @private **/
		public var overlay:Image;
		/** @private **/
		public var thumbnail:Image;
		/** @private **/
		private var _client:Object;
		/** @private **/
		private var _videoTimer:Timer;
		/** @private **/
		protected var _updateTimer:Timer;
		
		private var _screenshot:Bitmap;
		
		/** 
		*	Constructs a new Video object
		*	@param obj Object containing all properties to construct the Video class	
		**/
		public function Video(obj:Object) {
			super();
			
			//Default Attributes
			data.type				= 'video';
			data.x					= 0;
			data.y					= 0;
			data.isInit				= false;
			data.isPaused			= false;
			data.isFinished			= false;
			data.isLoaded			= false;
			data.volume				= 1;
			data.loop				= false;
			data.muted				= false;
			data.backgroundAlpha	= 1;
			data.backgroundColor	= 0x000000;
			data.transparent		= false;
			data.lastVol			= 1;
			
			//Set Attributes
			setAttributes(obj);
			
			data.isPlaying		= false;
			data.bytesLoaded	= 0;
			data.bytesTotal		= 0;
			data.duration		= 0;
			data.current		= -1;
			data.startVideo		= false;
			data.stopVideo		= false;
			
			//Client
            _client				= {};
			_client.onCuePoint	= onMetaData;
			_client.onMetaData	= onMetaData;
			_client.onBWDone	= onBWDone;
			_client.close		= onStreamClose;
			
			//Update Timer
			_updateTimer = new Timer(1000, 0);
			_updateTimer.addEventListener(TimerEvent.TIMER, onUpdateVideo, false, 0, true);
			
			if(data.type == 'video') {
				//Video Buffer Timer
				_videoTimer = new Timer(500, 0);
				_videoTimer.addEventListener(TimerEvent.TIMER, onWaitVideo, false, 0, true);
			
				if(src != '') {
					load(src);
				}
			
				if(data.thumbnailSrc != undefined) {
					thumbnail	= new Image({id:'thumbnail', src:data.thumbnailSrc, basePath:basePath, width:width, height:height});
					addChild(thumbnail);
				}
			}
			
			if(data.overlaySrc != undefined) {
				var overlayHide:Boolean	= ((data.overlayHide != undefined && data.overlayHide == 'true') || data.overlayHide) ? true : false;
				overlay					= new Image({id:'overlay', src:data.overlaySrc, basePath:basePath, width:width, height:height, hidden:overlayHide});
				addChild(overlay);
			}
			
			isSetup = true;
		}
		
		/** 
		*	Add a video to the video object. This method is also called automatically
		*	when initialized. 
		*	@param src The relative path to the video source.	
		**/
		public function load(src:String, seconds:Number=0, quality:String='default', forceLoad:Boolean=false):void {
			//Clean
			//clean();
			removeScreen();
			
			this.src		= src;
			data.isFinished = false;
			data.isLoaded	= false;
			data.stopVideo	= false;
			
			trace('Video::load', autoPlay);
			if(autoPlay) {
				data.stopVideo	= false;
			}
			
			initStream();
			
			if(buffer > 0) {
				_videoTimer.start();
			} else {
				data.isLoaded	= true;
			}
		}
		
		private function initStream():void {
			trace('Video::initStream', id);
			try {
				//NetConnection
				_connection	= new NetConnection();
				_connection.client = _client;
				_connection.addEventListener(NetStatusEvent.NET_STATUS, onStatusVideo);
				_connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorSecurity, false, 0, true);
				_connection.connect(null);
			} catch (e:Error) {
				trace("An error has occured with the flv stream:" + e.message);
			}
        }
        
		private function playStream():void {
			trace('Video::playStream', id, data.startVideo);
			data.isInit				= false;
			
			//Netstream
			video					= new NetStream(_connection);
			video.checkPolicyFile	= true;
			video.client			= _client;
			video.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onErrorAsync, false, 0, true);
			video.addEventListener(NetStatusEvent.NET_STATUS, onStatusVideo, false, 0, true);
			video.addEventListener(IOErrorEvent.IO_ERROR,onErrorLoad,false,0,true);
			
			if(videoClip == null){
				videoClip			= new flash.media.Video();
				videoClip.smoothing	= true;
				videoClip.visible	= false;
				videoClip.name		= 'video';
				videoClip.addEventListener(Event.ADDED_TO_STAGE, onStageVideo, false, 0, true);
				addChild(videoClip);
			}
			
			videoClip.attachNetStream(video);
			
			if(autoPlay || data.startVideo) {
				play();
				//} else {
				//	pause();
			}
			data.startVideo	= false;
			
			trigger('element_loaded');
        }
        
		/** @private **/
		private function onLoaded():void {
			data.isLoaded	= true;
			trigger('element_loaded');
		}
		
		/** @private **/
		private function onErrorAsync(e:AsyncErrorEvent):void {
			trace('onErrorAsync', e.text);
		}
		
		/** @private **/
		private function onErrorLoad(e:IOErrorEvent):void {
			trace('Video::IOErrorEvent', e.toString());
		}
		
		/** @private **/
		private function onErrorSecurity(e:SecurityErrorEvent):void {
			trace("A security error occured: "+e.text+" Remember that the FLV must be in the same security sandbox as your SWF.");
		}
		
		/** @private **/
		private function onStageVideo(e:Event):void {
			videoClip.x	= 0;
			videoClip.y	= 0;
		}
		
		/** @private **/
		private function onStatusVideo(e:NetStatusEvent):void {
			switch(e.info.code) {
                case 'NetConnection.Connect.Success':
					trace('NetConnection.Connect.Success', data.stopVideo);
					if(!data.stopVideo) {
						playStream();
					}
					break;
				case 'NetStream.Play.Start':
					trace('NetStream.Play.Start', id);
                	data.isLoaded	= true;
					break;
				case 'NetStream.Play.Stop':
                	if(isPlaying) {
						onFinishVideo();
					}
					break;
				case 'NetStream.Play.StreamNotFound':
                    trace("Unable to locate video: " + src);
                    break;
                case 'NetStream.Seek.InvalidTime':
                    trace("InvalidTime: ", e.info.details);
					video.seek(e.info.details); 
                	break;
			}
		}
		
		/** @private **/
		private function onMetaData(info:Object):void {
			if(data.isInit) {
				return;
			}
			
			data.current	= 0;
			fps				= 0;
			
			//Resize Video
			if(isNaN(data.width)) {
				data.width	= info.width;
			}
			if(isNaN(data.height)) {
				data.height	= info.height;
			}
			
			resetSize();
				
			if(aspectRatio) {
				var xscale:Number	= data.width/data.width;
	   			var yscale:Number	= data.height/data.height;
				var scale:Number	= (xscale < yscale ? xscale : yscale);
				
				scaleX = scale;
		      	scaleY = scale;
			}
			
			volume				= data.volume;
			if(videoClip) {
				videoClip.visible	= true;
			}
			
			if(video) {
				video.bufferTime	= buffer * info.duration;
			}
			
			if(duration < info.duration) {
				data.duration	= info.duration.toFixed(2);
			}
			
			data.isInit	= true;
		}
		
		private function onBWDone():void {
			//Must be present to prevent errors for RTMP, but won't do anything
		}
	    private function onStreamClose():void {
			 trace("The stream was closed. Incorrect URL?");
		}
		
		/** @private **/
		private function onFinishVideo(e:ElementEvent=null):void {
			if(data.isFinished) {
				return;
			}
			
			data.isFinished = true;
			
			removeScreen();
			
			if(loop) {
				data.isFinished	= false;
				rewind();
				play();
				return;
			}
			
			var lastScreen:BitmapData	= new BitmapData(width, height, true, 0x000000);
			lastScreen.draw(this);
			_screenshot					= new Bitmap(lastScreen, 'auto', true);
			addChild(_screenshot);
			
			
			if(autoClean) {
				clean();
			} else {
				trigger('element_finish');
				stop();
				//pause();
			}
		}
		
		private function removeScreen():void {
			if(_screenshot && contains(_screenshot)) {
				removeChild(_screenshot);
			}
			
			_screenshot	= null;
		}
		
		/** @private **/
		private function onWaitVideo(e:TimerEvent):void {
			if(video.bytesTotal > 0 && (video.bytesLoaded/video.bytesTotal) >= buffer && !data.isLoaded) {
				onLoaded();
			}
			
			if((video.bytesLoaded/video.bytesTotal) == 1) {
				_videoTimer.stop();
			}
			
			data.bytesLoaded	= video.bytesLoaded;
			data.bytesTotal		= video.bytesTotal;
			
			trigger('element_progress', e);
		}
		
		/** @private **/
		protected function onUpdateVideo(e:TimerEvent):void {
			fps				= video.currentFPS;
			data.current	= video.time;
			trigger('element_update');
		}
		
		/** Indicates whether the video is currently playing. **/
		public function get isPlaying():Boolean {
			return data.isPlaying;
		}
		
		/** Bytes loaded **/
		public function get bytesLoaded():Number {
			return data.bytesLoaded;
		}
		
		/** Bytes total **/
		public function get bytesTotal():Number {
			return data.bytesTotal;
		}
		
		/** Length of video in seconds **/
		public function get duration():Number {
			return data.duration;
		}
		/** Current position of playhead, in seconds. **/
		public function get current():Number {
			return data.current;
		}
		
		/** Play the video stream **/
		public function play():void {
			trace('Video::play', id, data.isLoaded, data.isPlaying);
			//if(video) {
				if(data.isLoaded && !data.isPlaying) {
					data.isPlaying	= true;
					trace('video load');
					//data.isLoaded	= true;
					//video.play(src);
					data.startVideo	= true;
					data.stopVideo	= false;
					load(src);
				} else if(data.isPaused) {
					trace('video resume');
					video.resume();
				} else {
					trace('video play');
					video.play(src);
				}
				
				data.isPaused	= false;
				data.isFinished	= false;
				cacheAsBitmap	= false;
				
				//_updateTimer.start();
				trigger('element_play');
			//}
		}
		
		/** Stop the video, remove from stage, and clean from memory. **/
		public function stop():void {
			trace('Video::stop', id, data);
			if(data) {
				data.isPlaying	= false;
				data.stopVideo	= true;
			}
			
			if(video && videoClip) {
				videoClip.visible	= false;
				video.pause();
				video.close();
				videoClip.visible	= true;
			}
			
			trace('Video::data.autoClean', autoClean);
			if(autoClean) {
				clean(false);
			}
			trigger('element_stop');
		}
		
		/** Pause the video. **/
		public function pause():void {
			if(video) {
				//data.isPlaying	= false;
				data.isPaused	= true;
				
				video.pause();
				_updateTimer.stop();
				trigger('element_pause');
			}
		}
		
		/** Rewind the video to the beginning. **/
		public function rewind():void {
			seek(0);
		}
		
		/** Seek the video the keyframe closest to the time specified.
		*	@param seconds A number, in seconds, indicating the position of the playhead to jump to.
		**/
		public function seek(seconds:Number):void {
			if(video) {
				data.current	= seconds;
				
				video.pause();
				video.seek(seconds);
				
				if(loop) {
					video.resume();
				}
			}
			
			trigger('element_update');
		}
		
		/** Mute the volume of the video. 
		*	@default false **/
		public function set mute(value:Boolean):void {
			data.muted	= value;
			
			if(data.muted) {
				data.lastVol	= volume;
				volume			= 0;
			} else {
				volume			= data.lastVol;
			}
		}
		public function get mute():Boolean {
			return data.muted;
		}
		
		/** Loop the video infinitely. 
		*	@default false **/
		public function set loop(value:Boolean):void {
			data.loop	= value;
		}
		public function get loop():Boolean {
			return data.loop;
		}
		
		/** sets the volume control setting from no volume (0) to max volume (1).  **/
		public function set volume(vol:Number):void {
			data.volume	= vol;
			
			if(video) {
				var sound:SoundTransform	= video.soundTransform;
				sound.volume				= data.volume;
				video.soundTransform		= sound;
			}
		}
		public function get volume():Number {
			return data.volume;
		}
		
		/** @private **/
		private function resetSize():void {
			if(!isSetup) {
				return;
			}
			
			if(isNaN(width) || isNaN(height)) {
				return;
			}
			
			graphics.clear();
			graphics.beginFill(backgroundColor, backgroundAlpha);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
			
			if(videoClip) {
				videoClip.width		= width;
				videoClip.height	= height;
			}
		}
		
		/** Background color of the video player.
		*	@default 0x000000 **/
		public function get backgroundColor():uint {
			return data.backgroundColor;
		}
		public function set backgroundColor(value:uint):void {
			data.backgroundColor = value;
			resetSize();
		}
		
		/** Background alpha of the video player.
		*	@default 1 **/
		public function get backgroundAlpha():Number {
			return data.backgroundAlpha;
		}
		public function set backgroundAlpha(value:Number):void {
			data.backgroundAlpha = value;
			resetSize();
		}
		
		/** Toggles background alpha between 0 (true) and 1 (false).
		*	@default false **/
		public function get transparent():Boolean {
			return data.transparent;
		}
		public function set transparent(value:Boolean):void {
			data.transparent	= value;
			
			if(value) {
				data.backgroundAlpha = 0;
			} else {
				data.backgroundAlpha = 1;
			}
			
			resetSize();
		}
		
		/** Indicates the width in pixels. **/
		public override function get width():Number {
			if (data.width != undefined) {
				return data.width;
			} else {
				return super.width;
			}
		}
		public override function set width(value:Number):void {
			data.width	= value;
			resetSize();
		}
		
		/** Indicates the height in pixels. **/
		public override function get height():Number {
			if (data.height != undefined) {
				return data.height;
			} else {
				return super.height;
			}
		}
		public override function set height(value:Number):void {
			data.height = value;
			resetSize();
		}
		
		public override function hide(duration:Number=0, delay:Number=0, callback:Function=null, params:Array=null):VisualElement {
			if(callback == null) {
				callback	= onHide;
				params		= null;
			}
			
			animate({duration:duration, delay:delay, alpha:0, ease:Quintic.easeInOut, onComplete:callback, onCompleteParams:params});
			
			return this;
		}
		
		private function onHide():void {
			if(autoClean) {
				clean();
			}
		}
		
		/** @private **/
		public function clean(reset:Boolean=true):void {
			//Stop Timers
			if(_videoTimer) {
				_videoTimer.stop();
			}
			if(_updateTimer) {
				_updateTimer.stop();
			}
			
			//Close connections
			trace('Video::clean', video);
			if(video) {
				video.removeEventListener(NetStatusEvent.NET_STATUS, onStatusVideo);
				video.client	= {};
				video.pause();
				//video.play(null);
				video.close();
				video	= null;
			}
			
			if(_connection) {
				_connection.connect(null);
				_connection.close();
				_connection	= null;
			}
			
			if(videoClip != null) {				
				videoClip.removeEventListener(Event.ADDED_TO_STAGE, onStageVideo);
				videoClip.attachNetStream(null);
				
				if(contains(videoClip)) {
					removeChild(videoClip);
				}
				
				videoClip	= null;
			}
			
			if(reset) {
				isSetup		= false;
			}
		}
		
		/** Kill the object and clean from memory. **/
		public override function kill():void {
			clean();
			
			//unbind('element_video_meta', onMetaVideo);
			//unbind('element_video_status', onFinishVideo);
			
			//Nullify values
			src				= null;
			
			if(_videoTimer) {
				_videoTimer.stop();
				_videoTimer.removeEventListener(TimerEvent.TIMER, onWaitVideo);
				_videoTimer		= null;
			}
			
			if(_updateTimer) {
				_updateTimer.stop();
				_updateTimer.removeEventListener(TimerEvent.TIMER, onUpdateVideo);
				_updateTimer	= null;
			}
			
			super.kill();
		}
	}
}