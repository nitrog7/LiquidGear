/**
* VideoPaper Class by Giraldo Rosales.
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

package lg.flash.space {
	//Flash
	import flash.geom.Rectangle;
	
	//LG Classes
	import lg.flash.elements.Video;
	import lg.flash.events.ElementEvent;
	import lg.flash.components.google.YouTube
	
	/**
	*	<p>Loads external video files, giving it all the functionality of the Video object within a 3D space.</p>
	**/
	public class VideoPaper extends Paper {
		/** 
		*	Constructs a new VideoPaper object
		*	@param obj Object containing all properties to construct the VideoPaper class. You can use a 
		*	compination of both Video properties and Papervision's Plane properties.	
		**/
		public var video:Video;
		
		public function VideoPaper(obj:Object):void {
			super(obj);
			
			obj.x	= 0;
			obj.y	= 0;
			
			if(data.type == undefined || data.type == 'video') {
				video	= new Video(obj);
			}
			else if(data.type == 'youtube') {
				video	= new YouTube(obj) as Video;
			}
			
			if(video) {
				video.loaded(onLoadElement);
			}
		}
		
		/** @private **/
		private function onLoadElement(e:ElementEvent):void {
			var element:Video	= e.target as Video;
			
			if(element) {
				element.unbind('element_loaded', onLoadElement);
				
				if(data.width == undefined || data.width < 0) {
					data.width	= element.width;
				}
				
				if(data.height == undefined || data.height < 0) {
					data.height	= element.height;
				}
				
				if(data.bounds == undefined) {
					var bounds:Rectangle	= new Rectangle(0, 0, element.width, element.height);
					data.bounds	= bounds;
				}
				
				loaded(onLoadedVideo);
				super.addElement(element);
			}
		}
		
		private function onLoadedVideo(e:ElementEvent):void {
			//trace('VideoPaper::onLoadedVideo');
			unbind('element_loaded', onLoadedVideo);
			material.animated	= true;
		}
		
		private function onPlayVideo(e:ElementEvent):void {
			//trace('VideoPaper::onPlayVideo');
			material.animated	= true;
			trigger('element_play', null, e);
		}
	}
}