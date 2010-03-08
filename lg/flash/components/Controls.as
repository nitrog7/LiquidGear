/**
* Controls Class by Giraldo Rosales.
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
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.system.Capabilities;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	
	//LG
	import lg.flash.elements.VisualElement;
	import lg.flash.elements.Video;
	import lg.flash.elements.Text;
	import lg.flash.elements.Shape;
	import lg.flash.events.ElementEvent;
	
	import lg.flash.components.Scrubber;
	import lg.flash.components.ScrubberBar;
	
	public class Controls {
		/** Allows you to associate arbitrary data with the element. **/
		public var data:Object			= {};
		
		public var pausePlay:Boolean	= false;
		
		public var video:Video;
		public var play:VisualElement;
		public var pause:VisualElement;
		public var current:Text;
		public var duration:Text;
		public var controller:Sprite;
		public var progressBar:VisualElement;
		public var progressBg:VisualElement;
		public var progressLoad:VisualElement;
		public var scrubBar:ScrubberBar;
		public var playScrubber:VisualElement;
		public var scrubberPlay:Scrubber;
		
		public var mute:VisualElement;
		public var volumeCurrent:VisualElement;
		public var volumeBg:VisualElement;
		public var volumeBar:ScrubberBar;
		public var volumeScrubber:VisualElement;
		public var scrubberVolume:Scrubber;
		
		public var fullscreen:VisualElement;
		
		private var _enabled:Boolean	= true;
		private var _volume:Number		= 1;
		private var _buttonArray:Array	= [];
		
		
		public function Controls (obj:Object) {
			//Set Attributes
			for(var s:String in obj) {
				data[s] = obj[s];
				
				if(s in this) {
					this[s] = obj[s];
				}
			}
			
			video.bind('element_loaded', onVideoLoad);
			video.bind('element_play', onVideoPlay);
			video.bind('element_stop', onVideoStop);
			video.bind('element_pause', onVideoPaused);
			video.bind('element_update', onVideoUpdate);
			video.bind('element_change', onVideoChange);
			video.bind('element_progress', onVideoProgress);
			
			if(pausePlay) {
				createPlayPause();
			} else {
				if(play) {
					createPlay();
				}
				if(pause) {
					createPause();
				}
			}
			
			if(progressBar && progressBg && controller) {
				if(playScrubber) {
					createScrubber();
				}
				
				createScrubberBar();
			}
			
			if(mute) {
				createMute();
			}
			
			if(volumeCurrent && volumeBg && volumeScrubber) {
				if(volumeScrubber) {
					createVolume();
				}
				
				createVolumeBar();
			}
			
			if(fullscreen) {
				createFullscreen();
			}
		}
		
		private function createPlayPause() {
			play.hidden		= true;
			pause.hidden	= false;
			play.button();
			pause.button();
			
			play.click(onClickPlay);
			pause.click(onClickPause);
			
			_buttonArray.push(play);
			_buttonArray.push(pause);
		}
		
		private function createPlay() {
			play.click(onClickPlay);
			_buttonArray.push(play);
		}
		
		private function createPause() {
			pause.click(onClickPause);
			_buttonArray.push(pause);
		}
		
		private function createMute() {
			mute.toggle(onClickMute, onClickUnmute);
			mute.button();
			_buttonArray.push(mute);
		}
		
		private function createFullscreen() {
			fullscreen.click(onFullScreen);
			fullscreen.button();
			_buttonArray.push(fullscreen);
		}
		
		
		private function createVolume() {
			var offsetX:Number = (data.volOffsetX) ? data.volOffsetX : 0;
			var offsetY:Number = (data.volOffsetY) ? data.volOffsetY : 0;
			
			scrubberVolume = new Scrubber({id:'scrubber', scrubber:volumeScrubber, offsetX:offsetX, offsetY:offsetY});
			scrubberVolume.mouseup(onUpVolume);
		}
		
		private function createVolumeBar() {
			volumeBar	= new ScrubberBar({stage:controller.stage, progressBar:volumeCurrent, backgroundBar:volumeBg, scrubber:scrubberVolume});
			volumeBar.backgroundBar.click(onClickVolume);
			volumeBar.adjustScale(_volume);
			volumeBar.enabled	= true;
			controller.addChild(volumeBar);
		}
		
		private function createScrubber() {
			var offsetX:Number = (data.scrubOffsetX) ? data.scrubOffsetX : 0;
			var offsetY:Number = (data.scrubOffsetY) ? data.scrubOffsetY : 0;
			
			scrubberPlay = new Scrubber({id:'volScrub', scrubber:playScrubber, offsetX:offsetX, offsetY:offsetY});
			scrubberPlay.mouseup(onUpScrub);
		}
		
		private function createScrubberBar() {
			scrubBar	= new ScrubberBar({stage:controller.stage, progressBar:progressBar, backgroundBar:progressBg, loadedBar:progressLoad, scrubber:scrubberPlay});
			scrubBar.backgroundBar.click(onClickSeek);
			controller.addChild(scrubBar);
			_buttonArray.push(scrubBar);
		}
		
		
		private function onClickPlay(e:ElementEvent):void {
			video.play();
		}
		
		private function onClickPause(e:ElementEvent):void {
			video.pause();
		}
		
		private function onClickMute(e:ElementEvent):void {
			video.mute	= true;
		}
		private function onClickUnmute(e:ElementEvent):void {
			video.mute	= false;
		}
		
		private function onClickVolume(e:ElementEvent):void {
			if(volumeBar.enabled && volumeBar.value) {
				video.volume	= volumeBar.value;
			}
		}
		
		private function onUpVolume(e:ElementEvent):void {
			if(volumeBar.enabled && volumeBar.value) {
				video.volume = volumeBar.value;
			}
		}
		
		private function onClickSeek(e:ElementEvent):void {
			if(scrubBar.enabled) {
				var seekTime:Number = video.duration * scrubBar.value;
				video.seek(seekTime);
			}
		}
		
		private function onDownScrub(e:ElementEvent):void {
			video.pause();
		}
		
		private function onUpScrub(e:ElementEvent):void {
			var seekTime:Number = video.duration * scrubBar.value;
			video.seek(seekTime);
		}
		
		public function set enabled(arg:Boolean):void {
			if (arg){
				enable();
			} else {
				disable();
			}
		}
		public function get enabled():Boolean {
			return _enabled;
		}
		
		private function enable():void{
			var count:int = _buttonArray.length;
			
			for(var i:int=0; i<count; i++) {
				var b:VisualElement = _buttonArray[i];
				b.enabled = true;
			}
			
			_enabled = true;
		};
		
		private function disable():void{
			var count:int = _buttonArray.length;
			
			for(var i:int=0;i<count; i++) {
				var b:VisualElement = _buttonArray[i];
				b.enabled = false;
			}
			
			_enabled = false;
		}
		
		public function onFullScreen(e:ElementEvent):void {
			if(!fullscreen.enabled) return;
			
			if(controller.stage.displayState == StageDisplayState.NORMAL) {
				try {
					controller.stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullscreen);
					controller.stage.displayState = StageDisplayState.FULL_SCREEN;
				}
				catch (e:SecurityError){
					//if you don't complete STEP TWO below, you will get this SecurityError
					trace("an error has occured. please modify the html file to allow fullscreen mode");
				}
			} else {
				controller.stage.displayState = StageDisplayState.NORMAL;
			}
		}
		public function onFullscreen(e:FullScreenEvent):void {     
			if(e.fullScreen) {
				//Save current settings
				retainData(video, 'video');
				
				//Set new settings
				var newW:int	= Capabilities.screenResolutionX;
				var newH:int	= Capabilities.screenResolutionY;
				var newX:int	= (controller.stage.stageWidth - newW) >> 1;
				var newY:int	= (controller.stage.stageHeight - newH) >> 1;
				
				video.setSize(newW, newH);
				video.setPos(newX, newY);
			} else {
				revertData(video, 'video');
			}
		}
		
		private function revertData(item:VisualElement, dataName:String):void {
			item.width	= data[dataName+'W'];
			item.height	= data[dataName+'H'];
			item.x		= data[dataName+'X'];
			item.y		= data[dataName+'Y'];
		}
		
		private function retainData(item:VisualElement, dataName:String):void {
			data[dataName+'W']	= item.width;
			data[dataName+'H']	= item.height;
			data[dataName+'X']	= item.x;
			data[dataName+'Y']	= item.y;
		}
		
			
		private function onVideoLoad(e:ElementEvent):void {
			//Time
			if(duration) {
				if(video.duration > 0) {
					duration.text	= convertTime(video.duration);
				} else {
					duration.text	= convertTime(0);
				}
			}
		}
		
		private function onVideoPlay(e:ElementEvent):void {
			togglePausePlay();
			scrubBar.enabled	= true;
		}
		
		private function onVideoStop(e:ElementEvent):void {
			scrubBar.adjust(0);
			current.text	= convertTime(0);
			
			if(video.duration > 0) {
				duration.text	= convertTime(video.duration);
			} else {
				duration.text	= convertTime(0);
			}
			scrubBar.enabled	= false;
			
			togglePausePlay();
		}
		
		private function onVideoPaused(e:ElementEvent):void {
			togglePausePlay();
		}
		
		private function onVideoUpdate(e:ElementEvent):void {
			current.text	= convertTime(video.current);
			duration.text	= convertTime(video.duration);
			
			if(scrubBar && !scrubBar.isScrubbing) {
				scrubBar.update({current:video.current, duration:video.duration});
			}
		}
		
		private function onVideoChange(e:ElementEvent):void {
			enabled	= (video.data.state < 0) ? false : true;
		}
		
		private function onVideoProgress(e:ElementEvent):void {
			if(scrubBar) {
				var amtLoad:int	= (video.bytesLoaded/video.bytesTotal) * video.duration;
				scrubBar.adjustLoad(amtLoad);
			}
		}
		
		private function togglePausePlay():void {
			if(video.isPlaying) {
				play.hidden		= true;
				pause.hidden	= false;
			} else {
				play.hidden		= false;
				pause.hidden	= true;
			}
		}
		
		private function convertTime(number:Number):String {
			//if(number == NaN) {
			//	number = 0;
			//}
			
			number			= Math.abs(number);  
			var val:Array	= new Array(5);  
			
			val[0] = Math.floor( number / 86400 / 7); //weeks  
			val[1] = Math.floor( number / 86400 % 7);//days  
			val[2] = Math.floor( number / 3600 % 24);//hours  
			val[3] = Math.floor( number / 60 % 60);//mins  
			val[4] = Math.floor( number % 60);//secs
			
			var stopage:Boolean	= false;
			var cutIndex:Number	= -1;
			
			for(var i:Number=0; i<val.length; i++) {
				if(val[i] < 10 && i>3) {
					val[i] = "0" + val[i];
				}
				
				if(val[i] == "00" && i<(val.length - 2) && !stopage) {
					cutIndex = i;  
				} else {  
					stopage = true;  
				}  
			}
			
			val.splice(0, cutIndex + 1);
			return val.join(':');
		}
	}
}