/**
* Sound by Giraldo Rosales.
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

package lg.flash.elements {
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import lg.flash.events.ElementEvent;
	
	
	/**
	* Dispatched when the sound begins to play.
	* @eventType mx.events.ElementEvent.PLAY
	*/
	[Event(name="element_play", type="lg.flash.events.ElementEvent")]
	
	/**
	* Dispatched when the sound stops.
	* @eventType mx.events.ElementEvent.STOP
	*/
	[Event(name="element_stop", type="lg.flash.events.ElementEvent")]
	
	/**
	* Dispatched when the sound has completed.
	* @eventType mx.events.ElementEvent.FINISH
	*/
	[Event(name="element_finish", type="lg.flash.events.ElementEvent")]
	
	/**
	* Dispatched while a sound file is playing.
	* @eventType mx.events.ElementEvent.UPDATE
	*/
	[Event(name="element_update", type="lg.flash.events.ElementEvent")]
	
	
	public class Sound extends Element {
		//Public Vars
		/** Relative path to the sound file. **/
		public var src:String			= '';
		/** Start playing once loaded. **/
		public var autoPlay:Boolean		= false;
		/** Determine if the sound is playing. **/
		public var isPlaying:Boolean	= false;
		
		//Components
		/** Reference to the Sound file. **/
		public var sound:flash.media.Sound;
		/** Reference to the SoundChannel. **/
		public var channel:SoundChannel;
		
		/** @private **/
		private var _isPaused:Boolean	= false;
		/** @private **/
		private var _stopSound:Boolean	= false;
		/** @private **/
		private var _pause:Number		= 0;
		/** 
		*	Constructs a new Sound object.
		*	@param obj Object containing all properties to construct the class	
		**/
		public function Sound(obj:Object) {
			super();
			
			//Set Defaults
			data.volume	= 1;
			data.loop	= false;
			
			//Set Attributes
			var ignore:Vector.<String>	= new Vector.<String>(2, true);
			ignore[0]	= 'stage';
			ignore[1]	= 'parent';
			
			for(var s:String in obj) {
				data[s] = obj[s];
				
				if(ignore.indexOf(s) < 0) {
					if(s in this) {
						this[s] = obj[s];
					}
				}
			}
			
			if(src != '') {
				load(src);
			}
			
			isSetup = true;
		}
		
		/** Load new sound. Any existing sound will be replaced.
		*
		*	@param src Relative path of sound file. **/
		public function load(src:String):void {
			this.src	= src;
			var req:URLRequest	= new URLRequest(basePath+src);
			sound				= new flash.media.Sound();
			sound.addEventListener(Event.COMPLETE, onLoaded);
			sound.addEventListener(ProgressEvent.PROGRESS, onProgress);
			sound.addEventListener(IOErrorEvent.IO_ERROR, onError);
			sound.load(req);
		}
		
		/** @private **/
		private function onLoaded(e:Event):void {
			//Cleanup
			sound.removeEventListener(Event.COMPLETE, onLoaded);
			sound.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			sound.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			
			trigger('element_loaded');
			
			if(autoPlay) {
				play();
			}
		}
		
		/** @private **/
		private function onError(e:IOErrorEvent):void {
			trigger('element_io_error', e);
			trace('IO Error: '+e.text);
			
			sound.removeEventListener(Event.COMPLETE, onLoaded);
			sound.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			sound.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			sound	= null;
		}
		
		/** Play the sound. **/
		public function play():SoundChannel {
			isPlaying	= true;
			_isPaused	= false;
			if(sound) {
				if(channel) {
					channel.stop();
				}
				
				_stopSound	= false;
				channel		= sound.play(_pause);
				volume		= data.volume;
				channel.addEventListener(Event.SOUND_COMPLETE, onFinishSound);
				
				onPlaySound();
			} else {
				channel		= new SoundChannel();
			}
			
			return channel;
		}
		
		/** Stop playing. **/
		public function stop():void {
			if(channel) {
				_stopSound	= true;
				_pause		= 0;
				channel.stop();
				onStopSound();
			}
		}
		
		/** Pause sound. **/
		public function pause():void {
			if(channel) {
				_stopSound	= true;
				_pause		= channel.position;
				channel.stop();
				onStopSound();
			}
		}
		
		/** Loop the sound continuously. 
		*	@default false **/
		public function set loop(toggle:Boolean):void {
			data.loop	= toggle;
		}
		public function get loop():Boolean {
			return data.loop;
		}
		
		/** Set audio volume.
		*	@param value A range of 0 (no volume) to 1 (max volume).
		*	@default 1 **/
		public function set volume(value:Number):void {
			data.volume	= value;
			
			if(channel) {
				channel.soundTransform	= new SoundTransform(data.volume, 0);
			}
		}
		public function get volume():Number {
			return data.volume;
		}
		
		/** @private **/
		private function onFinishSound(e:*):void {
			trigger('element_finish');
			
			if(data.loop && !_stopSound) {
				play();
			} else {
				onStopSound();
			}
		}
		
		/** @private **/
		private function onPlaySound():void {
			if(!isPlaying) {
				trigger('element_play');
				isPlaying	= true;
			}
		}
		
		/** @private **/
		private function onStopSound():void {
			if(isPlaying) {
				trigger('element_stop');
				isPlaying	= false;
			}
		}
		
		/** Kill the object and clean from memory. **/
		public override function kill():void {
			//Cleanup
			sound.removeEventListener(Event.COMPLETE, onLoaded);
			sound.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			sound.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			channel.removeEventListener(Event.SOUND_COMPLETE, onFinishSound);
				
			src		= null;
			sound	= null;
			channel	= null;
		}
	}
}