/**
* Background Class by Giraldo Rosales.
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


package lg.flash.components {
	//LG Classes
	import lg.flash.elements.VisualElement;
	import lg.flash.elements.Image;
	import lg.flash.elements.Flash;
	import lg.flash.elements.Video;
	import lg.flash.events.ElementEvent;
	
	public class Background extends VisualElement {
		private var _bg:VisualElement;
		
		public function Background(obj:Object) {
			super(obj);
			
			data.previousWidth	= stage.stageWidth;
			data.previousHeight	= stage.stageHeight;
			
			var bgSrc:String	= data.src;
			var srcLen:int		= bgSrc.length;
			var ext:String		= bgSrc.substring(srcLen - 3, srcLen);
			
			switch(ext) {
				case 'jpg':
				case 'gif':
				case 'png':
					_bg	= new Image({id:'background', basePath:basePath, src:data.src, stage:stage});
					break;
				
				case 'swf':
					_bg	= new Flash({id:'background', basePath:basePath, src:data.src, stage:stage, loop:true, autoPlay:true});
					break;
				
				case 'flv':
				case 'mov':
				case 'mp4':
					data.video	= new Video({id:'background', basePath:basePath, src:data.src, stage:stage, loop:true, autoPlay:true});
					_bg		= data.video as VisualElement;
					break;
			}
			switch(obj.align) {
				case 'top':
					break;
				case 'bottom':
					break;
				case 'left':
					break;
				case 'right':
					break;
				case 'center':
					//_bg.horizontalCenter	= true;
					break;
				default:
					//_bg.horizontalCenter	= true;
					//_bg.verticalCenter	= true;
					break;
			}
			
			_bg.loaded(onLoadedImage);
			_bg.error(onError);
			addChild(_bg);
		}
		
		/** @private **/
		private function onLoadedImage(e:ElementEvent):void {
			isSetup = true;
			trigger(ElementEvent.LOADED);
		}
		
		public override function get width():Number {
			return stage.stageWidth;
		}
		
		public override function get height():Number {
			return stage.stageHeight;
		}
		
		public function stretchIt():void {
			var ratioX:int			= stage.stageWidth / data.previousWidth;
			var ratioY:int			= stage.stageHeight / data.previousHeight;
			var alignType:String	= data.align.toLowerCase();
			
			if(alignType	== 'horizontalstretch')
			_bg.setPos(0,0);
			
			_bg.width	= stage.stageWidth;
			_bg.height	= stage.stageHeight;
			/*
			if (ratioX == 1) {
				if (ratioY != 1) {
					//sizer.y = (stage.stageHeight - sizer.height) / 2;
					//_bg.y = sizer.y;
					_bg.y = (stage.stageHeight - _bg.height) / 2;
				}
			} else {
				_bg.width	= _bg.width * ratioX;
				_bg.height	= _bg.height * ratioX;
				//sizer.width		= sizer.width * ratioX;
				//sizer.height	= sizer.height * ratioX;
				//sizer.y			= (stage.stageHeight - sizer.height) / 2;
				_bg.y = (stage.stageHeight - _bg.height) / 2;
				//_bg.y		= sizer.y;
			}
			
			if (_bg.y < 0) {
				_bg.y	= 0;
			}
			
			if (sizer.height > stage.stageHeight) {
				_bg.y = (stage.stageHeight - sizer.height) / 10 * 7;
			}
			*/
			data.previousWidth	= stage.stageWidth;
			data.previousHeight	= stage.stageHeight;
		}
		
		/** Update the elements properties. **/
		public override function update(obj:Object=null):void {
			graphics.clear();
			graphics.beginFill(0x000000, 0);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
			
			if(_bg) {
				var alignType:String	= data.align.toLowerCase();
				
				switch(alignType) {
					case 'horizontalstretch':
						var ratioX:int		= stage.stageWidth / data.previousWidth;
						
						_bg.setPos(0,0);
						_bg.width		= stage.stageWidth;
						_bg.height		= stage.stageHeight * ratioX;
						break;
					case 'verticalstretch':
						var ratioY:int		= stage.stageHeight / data.previousHeight;
						
						_bg.setPos(0,0);
						_bg.width		= stage.stageWidth * ratioY;
						_bg.height		= stage.stageHeight;
						break;
					case 'stretch':
						_bg.setPos(0,0);
						_bg.width		= stage.stageWidth;
						_bg.height		= stage.stageHeight;
						break;
					default:
						_bg.update();
						break;
				}
			}
			
			data.previousWidth	= stage.stageWidth;
			data.previousHeight	= stage.stageHeight;
			setPos(0, 0);
		}
		
		/** @private **/
		private function onError(e:ElementEvent):void {
			trigger(ElementEvent.ERROR, e);
		}
	}
}