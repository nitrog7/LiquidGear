/**
* Controls Class by Giraldo Rosales.
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
	
	public class Controls extends VisualElement {
		public var video:Video;
		
		
		private var _enabled:Boolean	= true;
		private var _volume:Number		= 1;
		private var _buttonArray:Array	= [];
		private var _pausePlay:Boolean	= false;
		
		//Elements
		private var _play:VisualElement;
		private var _pause:VisualElement;
		private var _fullscreen:VisualElement;
		
		private var _mute:VisualElement;
		private var _current:Text;
		private var _duration:Text;
		private var _progressBar:VisualElement;
		private var _progressBg:VisualElement;
		private var _progressLoad:VisualElement;
		private var _scrubBar:ScrubberBar;
		private var _playScrubber:VisualElement;
		private var _scrubberPlay:Scrubber;
		
		private var _volumeCurrent:VisualElement;
		private var _volumeBg:VisualElement;
		private var _volumeBar:ScrubberBar;
		private var _volumeScrubber:VisualElement;
		private var _scrubberVolume:Scrubber;
		
		
		public function Controls (video:Video) {
			this.video	= video;
			
			video.bind('element_loaded', onVideoLoad);
			video.bind('element_play', onVideoPlay);
			video.bind('element_stop', onVideoStop);
			video.bind('element_pause', onVideoPaused);
			video.bind('element_update', onVideoUpdate);
			video.bind('element_change', onVideoChange);
			video.bind('element_progress', onVideoProgress);
		}
		
		public function set progressBar(element:VisualElement):void {
			trace('removeButton::_progressBar');
			removeButton(_progressBar);
			
			_progressBar	= element;
			_scrubBar		= createProgress();
		}
		public function get progressBar():VisualElement {
			return _progressBar;
		}
		
		public function set progressBg(element:VisualElement):void {
			_progressBg	= element;
			_scrubBar	= createProgress();
		}
		public function get progressBg():VisualElement {
			return _progressBg;
		}
		
		public function set playScrubber(element:VisualElement):void {
			trace('removeButton::_playScrubber');
			removeButton(_playScrubber);
			
			_playScrubber	= element;
			
			var offsetX:Number = (data.scrubOffsetX) ? data.scrubOffsetX : 0;
			var offsetY:Number = (data.scrubOffsetY) ? data.scrubOffsetY : 0;
			_scrubberPlay = new Scrubber({id:'volScrub', scrubber:_playScrubber, offsetX:offsetX, offsetY:offsetY});
			_scrubberPlay.mouseup(onUpScrub);
		}
		public function get playScrubber():VisualElement {
			return _playScrubber;
		}
		
		public function set scrubOffsetX(value:Number):void {
			data.scrubOffsetX	= value;
			
			if(_playScrubber) {
				_scrubberPlay = new Scrubber({id:'volScrub', scrubber:_playScrubber, offsetX:scrubOffsetX, offsetY:scrubOffsetY});
				_scrubberPlay.mouseup(onUpScrub);
			}
		}
		public function get scrubOffsetX():Number {
			var offset:Number	= (data.scrubOffsetX) ? data.scrubOffsetX : 0;
			return offset;
		}
		
		public function set scrubOffsetY(value:Number):void {
			data.scrubOffsetY	= value;
			
			if(_playScrubber) {
				_scrubberPlay = new Scrubber({id:'volScrub', scrubber:_playScrubber, offsetX:scrubOffsetX, offsetY:scrubOffsetY});
				_scrubberPlay.mouseup(onUpScrub);
			}
		}
		public function get scrubOffsetY():Number {
			var offset:Number	= (data.scrubOffsetY) ? data.scrubOffsetY : 0;
			return offset;
		}
		
		
		public function set volumeCurrent(element:VisualElement):void {
			trace('removeButton::_volumeCurrent');
			removeButton(_volumeCurrent);
			
			_volumeCurrent	= element;
			_volumeCurrent.ghost();
			
			_volumeBar		= createVolume();
		}
		public function get volumeCurrent():VisualElement {
			return _volumeCurrent;
		}
		
		public function set volumeBg(element:VisualElement):void {
			trace('removeButton::_volumeBg');
			removeButton(_volumeBg);
			
			_volumeBg	= element;
			_volumeBg.ghost();
			
			_volumeBar		= createVolume();
		}
		public function get volumeBg():VisualElement {
			return _volumeBg;
		}
		
		public function set volumeScrubber(element:VisualElement):void {
			trace('removeButton::_volumeScrubber');
			removeButton(_volumeScrubber);
			
			_volumeScrubber	= element;
			_volumeScrubber.ghost();
			
			_volumeBar		= createVolume();
		}
		public function get volumeScrubber():VisualElement {
			return _volumeScrubber;
		}
		
		public function set volOffsetX(value:Number):void {
			data.scrubOffsetX	= value;
			
			if(_volumeScrubber) {
				_scrubberVolume = createScrubber(_volumeScrubber, onUpVolume);
			}
		}
		public function get volOffsetX():Number {
			var offset:Number	= (data.scrubOffsetX) ? data.scrubOffsetX : 0;
			return offset;
		}
		
		public function set volOffsetY(value:Number):void {
			data.volOffsetY	= value;
			
			if(_volumeScrubber) {
				_scrubberVolume = createScrubber(_volumeScrubber, onUpVolume);
			}
		}
		public function get volOffsetY():Number {
			var offset:Number	= (data.scrubOffsetY) ? data.scrubOffsetY : 0;
			return offset;
		}
		
		
		private function createProgress():ScrubberBar {
			if(!_progressBg) {
				var bgShape:Shape	= new Shape({id:'bgShape', width:_progressBar.width, height:_progressBar.height});
				_progressBg	= new VisualElement();
				_progressBg.addChild(bgShape);
			}
			
			var scrub	= new ScrubberBar({stage:data.stage, progressBar:_progressBar, backgroundBar:_progressBg, loadedBar:_progressLoad, scrubber:_scrubberPlay});
			scrub.backgroundBar.click(onClickSeek);
			addChild(scrub);
			_buttonArray.push(scrub);
			
			return scrub;
		}
		
		private function createVolume():ScrubberBar {
			if(_volumeCurrent && _volumeBg && _scrubberVolume) {
				var scrub	= new ScrubberBar({stage:data.stage, progressBar:_volumeCurrent, backgroundBar:_volumeBg, scrubber:_scrubberVolume});
				scrub.backgroundBar.click(onClickVolume);
				scrub.adjustScale(_volume);
				scrub.enabled	= true;
				addChild(scrub);
			}
			
			return scrub;
		}
		
		private function createScrubber(element:VisualElement, fnc:Function):Scrubber {
			var scrub	= new Scrubber({id:'scrubber', scrubber:element, offsetX:volOffsetX, offsetY:volOffsetY});
			scrub.mouseup(fnc);
			
			return scrub;
		}
		
		public function set fs(element:VisualElement):void {
			trace('removeButton::_fullscreen');
			removeButton(_fullscreen, onFullScreen);
			
			_fullscreen	= element;
			_fullscreen.button();
			_fullscreen.click(onFullScreen);
			_buttonArray.push(_fullscreen);
		}
		public function get fs():VisualElement {
			return _fullscreen;
		}
		
		
		public function set play(element:VisualElement):void {
			trace('removeButton::_play');
			removeButton(_play, onClickPlay);
			
			_play	= element;
			_play.button();
			_play.click(onClickPlay);
			_buttonArray.push(_play);
		}
		public function get play():VisualElement {
			return _play;
		}
		
		public function set pause(element:VisualElement):void {
			trace('removeButton::_pause');
			removeButton(_pause, onClickPause);
			
			_pause	= element;
			_pause.button();
			_pause.click(onClickPause);
			_buttonArray.push(_pause);
			
			if(pausePlay) {
				pause.hidden	= true;
			}
		}
		public function get pause():VisualElement {
			return _pause;
		}
		
		public function set pausePlay(value:Boolean):void {
			_pausePlay	= value;
			
			if(play && pause) {
				if(_pausePlay) {
					play.hidden		= false;
					pause.hidden	= true;
				} else {
					play.hidden		= false;
					pause.hidden	= false;
				}
			}
		}
		public function get pausePlay():Boolean {
			return _pausePlay;
		}
		
		public function set mute(element:VisualElement):void {
			trace('removeButton::_mute');
			removeButton(_mute);
			
			_mute	= element;
			_mute.toggle(onClickMute, onClickUnmute);
			_mute.button();
			_buttonArray.push(_mute);
		}
		
		
		public function set current(element:Text):void {
			trace('removeButton::_current');
			removeButton(_current);
			
			_current	= element;
			_current.ghost();
		}
		public function get current():Text {
			return _current;
		}
		
		public function set duration(element:Text):void {
			trace('removeButton::_duration');
			removeButton(_duration);
			
			_duration	= element;
			_duration.ghost();
		}
		public function get duration():Text {
			return _duration;
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
			if(_volumeBar.enabled && _volumeBar.value) {
				video.volume	= _volumeBar.value;
			}
		}
		
		private function onUpVolume(e:ElementEvent):void {
			if(_volumeBar.enabled && _volumeBar.value) {
				video.volume = _volumeBar.value;
			}
		}
		
		private function onClickSeek(e:ElementEvent):void {
			if(_scrubBar.enabled) {
				var seekTime:Number = video.duration * _scrubBar.value;
				video.seek(seekTime);
			}
		}
		
		private function onDownScrub(e:ElementEvent):void {
			video.pause();
		}
		
		private function onUpScrub(e:ElementEvent):void {
			var seekTime:Number = video.duration * _scrubBar.value;
			video.seek(seekTime);
		}
		
		public override function set enabled(value:Boolean):void {
			if (value){
				enable();
			} else {
				disable();
			}
		}
		public override function get enabled():Boolean {
			return _enabled;
		}
		
		private function enable():void{
			var count:int = _buttonArray.length;
			
			for(var i:int=0; i<count; i++) {
				var b:VisualElement = _buttonArray[i];
				b.enabled = true;
			}
			
			_enabled = true;
		}
		
		private function disable():void{
			var count:int = _buttonArray.length;
			
			for(var i:int=0;i<count; i++) {
				var b:VisualElement = _buttonArray[i];
				b.enabled = false;
			}
			
			_enabled = false;
		}
		
		public function removeButton(element:VisualElement, fnc:Function=null):void{
			if(element) {
				if(fnc != null) {
					element.unbind('element_click', fnc);
				}
				
				var count:int = _buttonArray.length;
			
				for(var g:int=0; g<count; g++) {
					var b:VisualElement = _buttonArray[g];
					
					if(element	== b) {
						_buttonArray.splice(g, 1);
					}
				}
				
				if(element && contains(element)) {
					removeChild(element);
				}
				
				element	= null;
			}
		}
		
		public function onFullScreen(e:ElementEvent):void {
			if(!fs.enabled) return;
			
			if(data.stage.displayState == StageDisplayState.NORMAL) {
				try {
					data.stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullscreen);
					data.stage.displayState = StageDisplayState.FULL_SCREEN;
				}
				catch (e:SecurityError){
					//if you don't complete STEP TWO below, you will get this SecurityError
					trace("an error has occured. please modify the html file to allow fullscreen mode");
				}
			} else {
				data.stage.displayState = StageDisplayState.NORMAL;
			}
		}
		public function onFullscreen(e:FullScreenEvent):void {     
			if(e.fullScreen) {
				//Save current settings
				retainData(video, 'video');
				
				//Set new settings
				var newW:int	= Capabilities.screenResolutionX;
				var newH:int	= Capabilities.screenResolutionY;
				var newX:int	= (data.stage.stageWidth - newW) >> 1;
				var newY:int	= (data.stage.stageHeight - newH) >> 1;
				
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
			_scrubBar.enabled	= true;
		}
		
		private function onVideoStop(e:ElementEvent):void {
			_scrubBar.adjust(0);
			
			if(_current) {
				current.text	= convertTime(0);
			}
			
			if(video.duration > 0) {
				duration.text	= convertTime(video.duration);
			} else {
				duration.text	= convertTime(0);
			}
			_scrubBar.enabled	= false;
			
			togglePausePlay();
		}
		
		private function onVideoPaused(e:ElementEvent):void {
			togglePausePlay();
		}
		
		private function onVideoUpdate(e:ElementEvent):void {
			trace('onVideoUpdate');
			if(_current) {
				current.text	= convertTime(video.current);
			}
			
			duration.text	= convertTime(video.duration);
			
			if(_scrubBar && !_scrubBar.isScrubbing) {
				_scrubBar.update({current:video.current, duration:video.duration});
			}
		}
		
		private function onVideoChange(e:ElementEvent):void {
			enabled	= (video.data.state < 0) ? false : true;
		}
		
		private function onVideoProgress(e:ElementEvent):void {
			if(_scrubBar) {
				var amtLoad:int	= (video.bytesLoaded/video.bytesTotal) * video.duration;
				_scrubBar.adjustLoad(amtLoad);
			}
		}
		
		private function togglePausePlay():void {
			if(pausePlay) {
				if(video.isPlaying) {
					play.hidden		= true;
					pause.hidden	= false;
				} else {
					play.hidden		= false;
					pause.hidden	= true;
				}
			}
		}
		
		private function convertTime(number:Number):String {
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