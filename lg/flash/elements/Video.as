/**
* Video Class by Giraldo Rosales.
* Visit www.liquidgear.net for documentation and updates.
*
*
* Copyright (c) 2011 Nitrogen Labs, Inc. All rights reserved.
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
	import flash.net.NetStreamPlayOptions;
	import flash.utils.Timer;
	
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
			cacheAsBitmap			= false;
			
			//Default Attributes
			data.type				= 'video';
			data.x					= 0;
			data.y					= 0;
			data._isInit			= false;
			data._isPaused			= false;
			data._isFinished		= false;
			data._isLoaded			= false;
			data.volume				= 1;
			data.loop				= false;
			data.muted				= false;
			data.backgroundAlpha	= 1;
			data.backgroundColor	= 0x000000;
			data.transparent		= false;
			data.lastVol			= 1;
			data.rtmp				= null;
			
			//Set Attributes
			setAttributes(obj);
			
			data._isPlaying		= false;
			data._bytesLoaded	= 0;
			data._bytesTotal	= 0;
			data._duration		= 0;
			data._buffer		= 0;
			data._current		= -1;
			data._startVideo	= false;
			data._isStopped		= false;
			
			//Client
            _client				= {};
			_client.onCuePoint	= onCuePoint;
			_client.onMetaData	= onMetaData;
			_client.onBWDone	= onBWDone;
			_client.close		= onStreamClose;
			
			//Update Timer
			_updateTimer = new Timer(300, 0);
			_updateTimer.addEventListener(TimerEvent.TIMER, onUpdateVideo, false, 0, true);
			
			if(data.type == 'video') {
				//Video Buffer Timer
				_videoTimer = new Timer(300, 0);
				
				if(!data.rtmp) {
					_videoTimer.addEventListener(TimerEvent.TIMER, onWaitVideo, false, 0, true);
				} else {
					_videoTimer.addEventListener(TimerEvent.TIMER, onBufferVideo, false, 0, true);
				}
				
				if(src != '') {
					load(src);
				}
			}
			
			isSetup = true;
		}
		
		/** 
		*	Add a video to the video object. This method is also called automatically
		*	when initialized. 
		*	@param src The relative path to the video source.	
		**/
		public function load(src:String, seconds:Number=0, rtmp:String=null):void {
			if(isPlaying) {
				stop();
			}
			
			removeScreen();
			
			if(rtmp) data.rtmp	= rtmp;
			this.src			= src;
			onResetVideo();
			
			if(autoPlay) {
				data._isStopped	= false;
			}
			
			initConnection();
			if(!data.rtmp) _videoTimer.start();
		}
		
		private function initConnection():void {
			try {
				//NetConnection
				_connection	= new NetConnection();
				_connection.client = _client;
				_connection.addEventListener(NetStatusEvent.NET_STATUS, onStatusVideo);
				_connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorSecurity, false, 0, true);
				_connection.addEventListener(IOErrorEvent.IO_ERROR, onErrorLoad, false, 0, true);
				_connection.connect(rtmp);
			} catch (e:Error) {
				trace("An error has occured with the flv stream:" + e.message);
			}
		}
		
		/** URL path to the RTMP server, if streaming video using a Flash Media Server such as Red5. **/
		public function set rtmp(value:String):void {
			data.rtmp		= value;
		}
		
		public function get rtmp():String {
			return data.rtmp;
		}
        
		private function playStream():void {
			data._isInit			= false;
			
			if(!video) {
				//Netstream
				video						= new NetStream(_connection);
				video.checkPolicyFile		= true;
				video.client				= _client;
				video.bufferTime			= 5;
				video.maxPauseBufferTime	= 10;
				
				video.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onErrorAsync, false, 0, true);
				video.addEventListener(NetStatusEvent.NET_STATUS, onStatusVideo, false, 0, true);
				video.addEventListener(IOErrorEvent.IO_ERROR,onErrorLoad,false,0,true);
				
				if(videoClip == null){
					videoClip				= new flash.media.Video();
					videoClip.deblocking	= 1;
					videoClip.smoothing		= true;
					videoClip.visible		= false;
					videoClip.name			= 'video';
					videoClip.addEventListener(Event.ADDED_TO_STAGE, onStageVideo, false, 0, true);
					addChild(videoClip);
				}
				
				videoClip.attachNetStream(video);
			}
			
			if(autoPlay || data._startVideo) {
				play();
			}
			
			data._startVideo	= false;
        }
        
		/** @private **/
		private function onLoaded():void {
			data._isLoaded	= true;
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
			//trace(e.info.code);
			switch(e.info.code) {
                case 'NetConnection.Connect.Success':
					if(!data._isStopped) {
						playStream();
					}
					
					if(data.rtmp) {
						onLoaded();
						
						//data._isLoaded		= true;
						//data._isPlaying		= true;
						videoClip.visible	= true;
						_updateTimer.start();
					}
					
					trigger('element_video_connect');
					break;
				case 'NetStream.Play.Start':
					onPlayVideo();
					
					if(!data.rtmp) {
						videoClip.visible	= true;
						_updateTimer.start();
					}
					break;
				case 'NetStream.Play.Stop':
					if(!data.rtmp) {
						onFinishVideo();
					} else {
						_videoTimer.start();
					}
					
					break;
				
				case 'NetStream.Buffer.Empty':
					onFinishVideo();
					break;
				case "NetStream.Pause.Notify":
					if(!isPaused && !isFinished) {
						if(video.bufferLength.toFixed(2) == 0) {
							onFinishVideo();
						} else {
							onPauseVideo();
						}
					}
					break;
				case "NetStream.Seek.Notify":
					trigger('element_video_seek');
					break;
				case "NetStream.Buffer.Empty":
					video.bufferTime	= 2;
					break;
				case "NetStream.Buffer.Flush":
					trigger('element_video_buffer_flush');
					break;
				case "NetStream.Buffer.Full":
					video.bufferTime	= 15;
					trigger('element_video_buffer_full');
					break;
				case 'NetStream.Play.StreamNotFound':
                    trace("Unable to locate video: " + src);
					trigger('element_video_error');
                    break;
                case 'NetStream.Seek.InvalidTime':
                    trace("InvalidTime: ", e.info.details);
					trigger('element_video_error');
					video.seek(e.info.details); 
                	break;
			}
		}
		
		/** @private **/
		private function onCuePoint(info:Object):void {
			
		}
		
		/** @private **/
		private function onMetaData(info:Object):void {
			if(data._isInit) return;
			
			data._current	= 0;
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
			
			if(duration < info.duration) {
				data._duration	= info.duration.toFixed(2);
			}
			
			data._isInit	= true;
		}
		
		private function onBWDone():void {
			//Must be present to prevent errors for RTMP, but won't do anything
		}
	    private function onStreamClose():void {
			 trace("The stream was closed. Incorrect URL?");
		}
		
		/** @private **/
		private function onResetVideo():void {
			data._isPlaying		= false;
			data._isPaused		= false;
			data._isStopped		= false;
			data._isFinished	= false;
			data._isLoaded		= false;
		}
		
		/** @private **/
		private function onPlayVideo():void {
			data._isPlaying		= true;
			data._isPaused		= false;
			data._isStopped		= false;
			data._isFinished	= false;
			data._isLoaded		= false;
			
			trigger('element_play');
		}
		
		/** @private **/
		private function onStopVideo():void {
			data._isPlaying		= false;
			data._isPaused		= false;
			data._isStopped		= true;
			data._isFinished	= false;
			data._isLoaded		= false;
			
			trigger('element_stop');
		}
		
		/** @private **/
		private function onPauseVideo():void {
			data._isPlaying		= false;
			data._isPaused		= true;
			data._isStopped		= false;
			data._isFinished	= false;
			data._isLoaded		= false;
			
			trigger('element_pause');
		}
		
		/** @private **/
		private function onFinishVideo(e:ElementEvent=null):void {
			if(data._isFinished) return;
			
			data._isPlaying		= false;
			data._isFinished	= true;
			data._isLoaded		= false;
			data._isPaused		= false;
			
			data._current		= duration;
			
			if(loop && !data._isStopped) {
				data._isFinished	= false;
				rewind();
				play();
				return;
			}
			
			if(autoClean) {
				removeScreen();
				
				var lastScreen:BitmapData	= new BitmapData(width, height, true, 0x000000);
				lastScreen.draw(this);
				_screenshot					= new Bitmap(lastScreen, 'auto', true);
				addChild(_screenshot);
				
				stop();
			} else {
				pause();
			}
			
			trigger('element_finish');
		}
		
		private function removeScreen():void {
			if(_screenshot && contains(_screenshot)) {
				removeChild(_screenshot);
			}
			
			_screenshot	= null;
		}
		
		/** @private **/
		private function onWaitVideo(e:TimerEvent):void {
			if(!video) return;
			
			if(video.bytesTotal > 0 && (video.bytesLoaded/video.bytesTotal) >= buffer && !data._isLoaded) {
				if(!data.rtmp) {
					onLoaded();
				}
			}
			
			if((video.bytesLoaded/video.bytesTotal) == 1) {
				_videoTimer.stop();
			}
			
			data._bytesLoaded	= video.bytesLoaded;
			data._bytesTotal	= video.bytesTotal;
			
			trigger('element_progress', e);
		}
		
		/** @private **/
		private function onBufferVideo(e:TimerEvent):void {
			if(video.bufferLength.toFixed(2) == 0) {
				_videoTimer.stop();
				onFinishVideo();
			}
		}
		
		/** @private **/
		protected function onUpdateVideo(e:TimerEvent=null):void {
			fps	= video.currentFPS;
			
			if(data) {
				data._current		= (data._isFinished) ? 0 : video.time;
				data._bytesLoaded	= video.bytesLoaded;
				data._bytesTotal	= video.bytesTotal;
				data._buffer		= current + video.bufferLength;
			}
			
			trigger('element_update');
		}
		
		/** Indicates whether the video is currently playing. **/
		public function get isPlaying():Boolean {
			return data._isPlaying;
		}
		
		/** Indicates whether the video is currently paused. **/
		public function get isPaused():Boolean {
			return data._isPaused;
		}
		
		/** Indicates whether the video has finished playing. **/
		public function get isFinished():Boolean {
			return data._isFinished;
		}
		
		/** Bytes loaded **/
		public function get bytesLoaded():Number {
			return data._bytesLoaded;
		}
		
		/** Bytes total **/
		public function get bytesTotal():Number {
			return data._bytesTotal;
		}
		
		/** Length of video in seconds **/
		public function get duration():Number {
			return data._duration;
		}
		/** Current position of playhead, in seconds. **/
		public function get current():Number {
			return data._current;
		}
		
		/** Time for that the buffer has loaded (seconds)**/
		public function get bufferTime():Number {
			return data._buffer;
		}
		
		/** Length the buffer has loaded (seconds) **/
		public function get bufferLength():Number {
			return video.bufferLength;
		}
		
		/** Play the video stream **/
		public function play():void {
			if(data._isPlaying) return;
			
			if(current == duration) {
				rewind();
			}
			
			if(data._isPaused) {
				video.resume();
			} else {
				var opt:NetStreamPlayOptions	= new NetStreamPlayOptions();
				opt.streamName					= src;
				video.play2(opt);
			}
			
			onPlayVideo();
			onUpdateVideo();
			_updateTimer.start();
		}
		
		/** Stop the video, remove from stage, and clean from memory. **/
		public function stop():void {
			
			if(video && videoClip) {
				videoClip.visible	= false;
				video.pause();
				video.close();
				_updateTimer.stop();
			}
			
			if(autoClean) {
				clean(false);
			}
			
			onStopVideo();
		}
		
		/** Pause the video. **/
		public function pause():void {
			if(data._isPaused) return;
			
			if(video) {
				video.pause();
				_updateTimer.stop();
			}
			
			onPauseVideo();
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
				//data._current		= seconds;
				data._wasPlaying	= isPlaying;
				
				if(!data.rtmp) {
					video.pause();
				}
				
				var sec:int	= Math.floor(seconds);
				video.seek(sec);
				
				if(!data.rtmp) {
					if(data._wasPlaying) {
						video.resume();
					}
				}
			}
			
			onUpdateVideo();
		}
		
		/** Mute the volume of the video. 
		*	@default false **/
		public function set mute(value:Boolean):void {
			data.muted	= value;
			
			if(value) {
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
			
			trigger('element_change');
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
			
			animate({duration:duration, delay:delay, alpha:0, ease:Quint.easeInOut, onComplete:callback, onCompleteParams:params});
			
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
			if(video) {
				video.removeEventListener(NetStatusEvent.NET_STATUS, onStatusVideo);
				video.client	= {};
				video.pause();
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
		
		/** Clone the Image element.
		 * @return Cloned Image element.
		 */		
		public function clone():lg.flash.elements.Video {
			var element:lg.flash.elements.Video	= new lg.flash.elements.Video(data);
			return element;
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