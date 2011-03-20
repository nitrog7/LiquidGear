/*** VisualElement Class by Giraldo Rosales.* Visit www.liquidgear.net for documentation and updates.*** Copyright (c) 2011 Nitrogen Labs, Inc. All rights reserved.* * Permission is hereby granted, free of charge, to any person* obtaining a copy of this software and associated documentation* files (the "Software"), to deal in the Software without* restriction, including without limitation the rights to use,* copy, modify, merge, publish, distribute, sublicense, and/or sell* copies of the Software, and to permit persons to whom the* Software is furnished to do so, subject to the following* conditions:* * The above copyright notice and this permission notice shall be* included in all copies or substantial portions of the Software.* * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR* OTHER DEALINGS IN THE SOFTWARE.**/package lg.flash.elements {	//Flash	import flash.display.BitmapData;	import flash.display.Sprite;	import flash.display.Stage;	import flash.events.Event;	import flash.filters.BitmapFilter;	import flash.filters.BlurFilter;	import flash.filters.DropShadowFilter;	import flash.filters.GlowFilter;	import flash.geom.Matrix;	import flash.geom.Rectangle;	import flash.utils.Dictionary;		import lg.flash.effects.Reflect;	import lg.flash.events.ElementEvent;	import lg.flash.motion.Tween;	import lg.flash.motion.easing.Quint;	import lg.flash.motion.plugins.AutoHidePlugin;	import lg.flash.motion.plugins.MotionBlurPlugin;	import lg.flash.utils.FilterManager;
		/**	* Dispatched when an animation begins.	* @eventType mx.events.ElementEvent.TWEENSTART	*/	[Event(name="element_tween_start", type="lg.flash.events.ElementEvent")]		/**	* Dispatched while an animation is in progress.	* @eventType mx.events.ElementEvent.TWEENUPDATE	*/	[Event(name="element_tween_update", type="lg.flash.events.ElementEvent")]		/**	* Dispatched when an animation completes.	* @eventType mx.events.ElementEvent.TWEENEND	*/	[Event(name="element_tween_end", type="lg.flash.events.ElementEvent")]			public class VisualElement extends Element {		/** Maintain aspect ratio when resizing. **/		public var aspectRatio:Boolean	= true;				/** @private **/		private var _hitArea:Sprite		= new Sprite();		/** @private **/		private var _tween:Tween;		/** @private **/		private var _isResize:Boolean	= false;		/** @private **/		private var _filters:Dictionary	= new Dictionary();				/** @private **/		protected var _layout:Object	= {};				/** Constructs a new VisualElement object **/		public function VisualElement(obj:Object=null) {			super();						//Be sure to update element when added to stage.			addEventListener('addedToStage', onInitAdd, false, 0, true);						//Set defaults			data.enabled			= false;			data.x					= 0;			data.y					= 0;			data.width				= NaN;			data.height				= NaN;						//Layout			_layout.x				= 0;			_layout.y				= 0;			_layout.top				= NaN;			_layout.bottom			= NaN;			_layout.left			= NaN;			_layout.right			= NaN;			_layout.width			= NaN;			_layout.height			= NaN;			_layout.scaleX			= 1;			_layout.scaleY			= 1;			_layout.position		= 'default';						data.position			= 'default';			data.bottom				= NaN;			data.right				= NaN;			data.minWidth			= NaN;			data.minHeight			= NaN;			data.maxWidth			= NaN;			data.maxHeight			= NaN;			data.minX				= NaN;			data.minY				= NaN;			data.maxX				= NaN;			data.maxY				= NaN;			data.percentTop			= NaN;			data.percentBottom		= NaN;			data.percentLeft		= NaN;			data.percentRight		= NaN;			data.horizontalCenter	= false;			data.verticalCenter		= false;			data.paddingTop			= 0;			data.paddingBottom		= 0;			data.paddingLeft		= 0;			data.paddingRight		= 0;						//data.percentWidth		= NaN;			//data.percentHeight	= NaN;						data.minBottom			= NaN;			data.minRight			= NaN;			data.maxBottom			= NaN;			data.maxRight			= NaN;			data.percentHCenter		= NaN;			data.percentVCenter		= NaN;			data.minHCenter			= NaN;			data.minVCenter			= NaN;			data.aspectRatio		= false;			data.aspectRatioPolicy	= 'smallest';						data._shadow			= null;			data._glow				= null;			data._blur				= null;			data._stroke			= null;			data._hoverGlow			= null;						//Set listeners			bind('element_add', onAddToStage);						//Set defined attributes			if(obj) {				setAttributes(obj);				isSetup	= true;			}		}						/** @private **/		protected override function setAttributes(obj:Object, ignore:Array=null):void {			if(!obj) {				return;			}						if(obj.stage) {				stage		= obj.stage;			}						if(obj.parent) {				parent		= obj.parent;			}						super.setAttributes(obj, ignore);		}				/** @private **/		private function onInitAdd(e:Event):void {			removeEventListener('addedToStage', onInitAdd);			update();		}				/*=========================		 * EFFECTS		 *=========================*/				/** Fade in element 		*	@param duration (optional) The duration of the animation. if set to 0, the element visibility is promptly set to true and alpha to 1.		*	@param delay (optional) Amount of time to wait before starting the aniamtion.		*	@param callback (optional) Function to call on completion.		*	@param params (optional) Parameters to send with function on complete.		*/		public function show(duration:Number=0, delay:Number=0, callback:Function=null, params:Array=null):VisualElement {			toFront();						if(duration) {				animate({duration:duration, delay:delay, alpha:1, ease:Quint.easeInOut, onComplete:callback, data:params});			} else {				hidden	= false;			}						return this;		}				/** Fade out element 		*	@param duration (optional) The duration of the animation. if set to 0, the element visibility is promptly set to false and alpha to 0.		*	@param delay (optional) Amount of time to wait before starting the aniamtion.		*	@param callback (optional) Function to call on completion.		*	@param params (optional) Parameters to send with function on complete.		*/		public function hide(duration:Number=0, delay:Number=0, callback:Function=null, params:Array=null):VisualElement {			if(duration) {				animate({duration:duration, delay:delay, alpha:0, ease:Quint.easeInOut, onComplete:callback, data:params});			} else {				hidden	= true;			}						return this;		}				/** Pulls the element in the front of the existing children. **/		public function toFront():void {			if(parent) {				parent.setChildIndex(this, parent.numChildren-1);			}		}		/** Pushes the element to the back, behind all the elements within the parent **/		public function toBack():void {			if(parent) {				parent.setChildIndex(this, 0);			}		}				/** Toggles the alpha and visibility of an element. 		*	@default false */		public function get hidden():Boolean {			var isHidden:Boolean	= (alpha == 0 && !visible) ? true : false;			return isHidden;		}		public function set hidden(value:Boolean):void {			data.hidden	= value;						if(value) {				alpha	= 0;				visible	= false;			} else {				alpha	= 1;				visible	= true;			}		}				/** Animate element **/		public function animate(obj:Object):void {			var duration:Number	= 0;			var ease:Function	= Quint.easeInOut;			var tweenProp:Array	= [				'autoPlay',				'data',				'delay',				'ease',				'nextTween',				'onChange',				'onComplete',				'onInit',				'paused',				'pluginData',				'position',				'reflect',				'repeatCount',				'supressEvents',				'timeScale',				'useFrames',			];			var tweenObj:Object	= {};						for(var s:String in obj) {				if(s == 'duration') {					duration	= obj[s];					delete(obj[s]);				}				else if(s == 'alpha') {					AutoHidePlugin.install();				}				else if(s == 'x' || s == 'y' || s == 'z') {					MotionBlurPlugin.install();				}				else if(tweenProp.indexOf(s) >= 0) {					tweenObj[s]	= obj[s];					delete(obj[s]);				}			}						if(_tween) _tween.stop();			_tween	= new Tween(this, duration, obj, tweenObj);		}				/** Play a paused animation */		public function playAnimation():void {			if(_tween) _tween.paused	= false;		}				/** Stop/Pause an animation */		public function stopAnimation():void {			if(_tween) _tween.paused	= true;		}				/** @private **/		public function slideDown(duration:Number=0, callback:Function=null):VisualElement {			return this;		}				/** @private **/		public function slideUp(duration:Number=0, callback:Function=null):VisualElement {			return this;		}				/** @private **/		public function slideToggle(duration:Number=0, callback:Function=null):VisualElement {			return this;		}				/** Fade element to specific alpha value.		*	@param opacity (optional) Opacity of element. (default: 1)		*	@param duration (optional) The duration of the animation. if set to 0, the element visibility is promptly set to true and alpha to 1. (default: 0)		*	@param callback (optional) Function to call on completion.		*	@param params (optional) Parameters to send with function on complete.		*/		public function fadeTo(opacity:Number=1, duration:Number=0, callback:Function=null, params:Array=null):VisualElement {			animate({duration:duration, alpha:opacity, ease:Quint.easeOut, onComplete:callback, data:params});			return this;		}				/** Flip the element horizontally **/		public function flipX():void {			scaleX = -1;		}				/** Flip the element vertically **/		public function flipY():void {			scaleY = -1;		}				/** 		*	Creates a custom hitArea for the element.		*	@param width (optional) Width of the hitArea. (default: 0)		*	@param height (optional) Height of the hitArea. (default: 0)		**/		public function hitBox(width:Number=0, height:Number=0):void {			if(width == 0) {				width	= data.width;			}						if(height == 0) {				height	= data.height;			}						_hitArea.graphics.clear();			_hitArea.graphics.beginFill(0x000000, 0);			_hitArea.graphics.drawRect(0, 0, width, height);			_hitArea.graphics.endFill();						hitArea	= _hitArea;		}				/** 		*	Creates a custom hitArea  in the shape of a circle for the element.		*	@param width (optional) Width of the hitArea. (default: 0)		*	@param height (optional) Height of the hitArea. (default: 0)		**/		public function hitSpot(width:Number=0, height:Number=0):void {			if(width == 0) {				width	= data.width *.8;			}			if(height == 0) {				height	= data.height *.8;			}						_hitArea.graphics.clear();			_hitArea.graphics.beginFill(0x000000, 0);			_hitArea.graphics.drawEllipse((data.width-width)*.5, (data.height-height)*.5, width, height);			_hitArea.graphics.endFill();						hitArea	= _hitArea;		}				/**		*	Add a drop shadow to the element.		*	@param prop Properties of the dropShadowFilter.		*	<ul>		*		<li><strong>alpha</strong>:<em>Number</em> - Alpha transparency value for the color. (default: 1)</li>		*		<li><strong>distance</strong>:<em>Number</em> - Offset distance for the shadow, in pixels. (default: 0)</li>		*		<li><strong>angle</strong>:<em>Number</em> - Angle of the shadow. (default: 45)</li>		*		<li><strong>blurX</strong>:<em>Number</em> - Amount of horizontal blur. (default: 15)</li>		*		<li><strong>blurY</strong>:<em>Number</em> - Amount of vertical blur. (default: 15)</li>		*		<li><strong>color</strong>:<em>uint</em> - Color of the shadow. (default: 0x000000)</li>		*		<li><strong>strength</strong>:<em>Number</em> - The strength of the imprint or spread. (default: 1)</li>		*		<li><strong>inner</strong>:<em>Boolean</em> - Specifies whether the shadow is an inner shadow. (default: false)</li>		*		<li><strong>knockout</strong>:<em>Boolean</em> - Specifies whether the object has a knockout effect. (default: false)</li>		*		<li><strong>quality</strong>:<em>Number</em> - The number of times to apply the filter. 1 - Low, 2 - Medium, 3 - High. (default: 3)</li>		*		<li><strong>knockout</strong>:<em>Boolean</em> - Make element invisible but keep filter. (default: false)</li>		*	</ul>		**/		public function shadow(prop:Object=null):Element {			var obj:Object	= {};						//Set defaults			obj.distance	= 0;			obj.angle		= 45;			obj.alpha		= 1;			obj.blurX		= 15;			obj.blurY		= 15;			obj.color		= 0x000000;			obj.strength	= 1;			obj.quality		= 3;			obj.inner		= false;			obj.knockout	= false;						var manager:FilterManager	= FilterManager.getInstance();						if(!prop) {				prop	= {};			}						//Set custom properties			for(var s:String in prop) {				obj[s]	= prop[s];			}						//If shadow already exists, remove it			if(data._shadow) {				manager.remove(this, data._shadow);				data._shadow	= null;			}						//Add shadow is blur is more than 0			if(obj.blurX != 0 || obj.blurY != 0) {				data._shadow	= new DropShadowFilter(obj.distance, obj.angle, obj.color, obj.alpha, obj.blurX, obj.blurY, obj.strength, obj.quality, obj.inner, obj.knockout, obj.hideObject);				manager.add(this, data._shadow);			}						return this;		}				/**		*	Add a glow filter to the element.		*	@param prop Properties of the glowFilter.		*	<ul>		*		<li><strong>alpha</strong>:<em>Number</em> - Alpha transparency value for the color. (default: 1)</li>		*		<li><strong>blurX</strong>:<em>Number</em> - Amount of horizontal blur. (default: 15)</li>		*		<li><strong>blurY</strong>:<em>Number</em> - Amount of vertical blur. (default: 15)</li>		*		<li><strong>color</strong>:<em>uint</em> - Color of the glow. (default: 0xffffff)</li>		*		<li><strong>strength</strong>:<em>Number</em> - The strength of the imprint or spread. (default: 1)</li>		*		<li><strong>inner</strong>:<em>Boolean</em> - Specifies whether the glow is an inner glow. (default: false)</li>		*		<li><strong>knockout</strong>:<em>Boolean</em> - Specifies whether the object has a knockout effect. (default: false)</li>		*		<li><strong>quality</strong>:<em>Number</em> - The number of times to apply the filter. 1 - Low, 2 - Medium, 3 - High. (default: 3)</li>		*		<li><strong>remove</strong>:<em>Boolean</em> - Remove the filter. (default: false)</li>		*	</ul>		**/		public function glow(prop:Object=null):VisualElement {			var obj:Object	= {};			var time:Number	= .25;						//Set defaults			obj.alpha		= 1;			obj.blurX		= 15;			obj.blurY		= 15;			obj.color		= 0xffffff;			obj.strength	= 1;			obj.quality		= 3;			obj.knockout	= false;			obj.remove		= false;						if(!prop) {				prop	= {};			}						//Set custom properties			for(var s:String in prop) {				obj[s]	= prop[s];			}						var manager:FilterManager	= FilterManager.getInstance();						if(obj.remove) {				if(data._glow) {					manager.remove(this, data._glow);				}				return this;			}						//If glow already exists, update it			if(data._glow) {				//Add shadow is blur is more than 0				if(obj.blurX != 0 || obj.blurY != 0) {					data._glow	= new GlowFilter(obj.color, obj.alpha, obj.blurX, obj.blurY, obj.strength, obj.quality, obj.inner, obj.knockout);					manager.add(this, data._glow);				} else {					manager.remove(this, data._glow);				}			} else {				data._glow	= new GlowFilter(obj.color, obj.alpha, obj.blurX, obj.blurY, obj.strength, obj.quality, obj.inner, obj.knockout);				manager.add(this, data._glow);			}						return this;		}				/**		*	Creates a glow around the element when the mouse is over and removes it when mouse moves out.		*	@param size (optional) Size of the glow. (default: 10).		*	@param color (optional) Color of the glow. (default: 0xffffff).		**/		public function hoverGlow(size:Number=10, color:uint=0xffffff):void {			var manager:FilterManager	= FilterManager.getInstance();						if(size > 0) {				data._hoverGlowSize	= size;				data._hoverGlow		= new GlowFilter(color, 0, size, size);				manager.add(this, data._hoverGlow);				hover(onGlowOn, onGlowOff);			} else {				unbind(ElementEvent.MOUSEOVER, onGlowOn);				unbind(ElementEvent.MOUSEOUT, onGlowOff);				manager.remove(this, data._hoverGlow);			}		}				/** @private **/		private function onGlowOn(e:ElementEvent):void {			var glow:GlowFilter	= data._hoverGlow as GlowFilter;			new Tween(glow, .25, {alpha:1, blurX:data._hoverGlowSize, blurY:data._hoverGlowSize}, {ease:Quint.easeInOut});		}				/** @private **/		private function onGlowOff(e:ElementEvent):void {			var glow:GlowFilter	= data._hoverGlow as GlowFilter;			new Tween(glow, .25, {alpha:0, blurX:0, blurY:0}, {ease:Quint.easeInOut});		}				/**		*	Creates a stroke around an element.		*	@param size (optional) Size of the stroke. (default: 1).		*	@param color (optional) Color of the stroke. (default: 0x000000).		**/		public function stroke(size:Number=2, color:uint=0x000000):Element {			var manager:FilterManager	= FilterManager.getInstance();						//If stroke already exists, remove it			if(data._stroke) {				manager.remove(this, data._stroke);				data._stroke	= null;			}						//Add stroke size is more than 0			if(size != 0) {				data._stroke	= new GlowFilter(color, 1, size, size, 1000, 1, false, false);				manager.add(this, data._stroke);			}						return this;		}				/**		*	Blur an object. 		*	@param prop Variables used to blur.		*	<ul>		*		<li><strong>blurX</strong>:<em>Number</em> - (optional) The amount of horizontal blur. (default: .15)</li>		*		<li><strong>blurY</strong>:<em>Number</em> - (optional) The amount of vertical blur. (default: .15)</li>		*		<li><strong>quality</strong>:<em>Number</em> - (optional) The quality of the blur. (default: 1)</li>		*		<li><strong>duration</strong>:<em>Number</em> - (optional) If animating, duration of time to blur from previous values. (default: 0)</li>		*	</ul>		**/		public function blur(prop:Object=null):VisualElement {			var obj:Object				= {};			var filterArr:Array;			var manager:FilterManager	= FilterManager.getInstance();						obj.blurX		= .15;			obj.blurY		= .15;			obj.quality		= 1;			obj.duration	= 0;						if(prop) {				//Set custom properties				for(var s:String in prop) {					obj[s]	= prop[s];				}			}						if(obj.remove) {				if(data._blur) {					manager.remove(this, data._blur);				}				return this;			}						//If blur already exists, remove it			if(data._blur) {				manager.remove(this, data._blur);				data._blur	= null;			}						//Add blur size is more than 0			if(obj.blurX != 0 || obj.blurY != 0) {				data._blur	= new BlurFilter(obj.blurX, obj.blurY, obj.quality);				manager.add(this, data._blur);			}						if(obj.duration > 0) {				var blur:BlurFilter	= data._blur as BlurFilter;				blur.blurX			= 0;				blur.blurY			= 0;								new Tween(data._blur, obj.duration, {blurX:obj.blurX, blurY:obj.blurY}, {ease:Quint.easeInOut});			}						return this;		}				/**		*	Create a reflection. 		*	@param prop Variables used to create reflection.		*	<ul>		*		<li><strong>alpha</strong>:<em>Number</em> - (optional) Opacity of the reflection. (default: .25)</li>		*		<li><strong>ratio</strong>:<em>Number</em> - (optional) Ratio of the glare. (default: 100)</li>		*		<li><strong>distance</strong>:<em>Number</em> - (optional) Distance from original element. (default: 0)</li>		*		<li><strong>updateTime</strong>:<em>Number</em> - (optional) Time persiod to update reflection. Use when animating element. To save on performance, set to -1 to turn off if not animating the element. (default: -1)</li>		*		<li><strong>reflectionDropoff</strong>:<em>Number</em> - (optional) Rate at which to fade. (default: 0)</li>		*	</ul>		**/		public function reflect(prop:Object=null):void {			var reflect:Reflect, obj:Object={};						obj.target				= this;			obj.alpha				= .25;			obj.ratio				= 100;			obj.distance			= 0;			obj.updateTime			= -1;			obj.reflectionDropoff	= 0;						for(var s:String in prop) {				obj[s] = prop[s];			}						reflect = new Reflect(obj);		}				/**		*	Set the size of the element		*	@param Set width.		*	@param Set height.		**/		public function setSize(width:Number, height:Number):void {			this.width	= width;			this.height	= height;		}				/**		*	Set the position of the element		*	@param Set x position.		*	@param Set y position.		**/		public function getSize():Rectangle {			var rect:Rectangle = new Rectangle(x, y, width, height);			return rect;		}				/**		*	Set the position of the element		*	@param Set x position.		*	@param Set y position.		**/		public function setPos(x:Number, y:Number, z:Number=0):void {			_layout.top		= NaN;			_layout.left	= NaN;						this.x	= x;			this.y	= y;		}				/** Get the bounds of the element **/		public function elementBounds():Rectangle {			var bounds:Rectangle	= new Rectangle(0, 0, width, height);			return bounds;		}				/** 		*	Scale element.		*	@param xScale Amount to scale along the x-axis.		*	@param yScale (optional) Amount to scale along the y-axis. If not set, yScale is set equal to xScale.		**/		public function scale(xScale:Number, yScale:Number=-1):void {			if(yScale < 0) {				scaleX	= scaleY = data._scaleX = data._scaleY = xScale;			} else {				scaleX	= data._scaleX = xScale;				scaleY	= data._scaleY = yScale;			}						_layout.scaleX	= scaleX;			_layout.scaleY	= scaleY;		}				/** Makes the element visible to the eye but invisible to the mouse. **/		public function ghost():void {			buttonMode		= false;			useHandCursor	= false;			mouseEnabled	= false;			mouseChildren	= false;		}				/** Gives the element button attributes. **/		public function button():void {			buttonMode		= true;			useHandCursor	= true;			mouseEnabled	= true;			mouseChildren	= false;		}				/** Toggles enable value. **/		public function set enabled(value:Boolean):void {			data.enabled	= value;		}		public function get enabled():Boolean {			return data.enabled;		}				/** References the Stage. Can add the stage if element has not yet been added. **/		public function set stage(container:Stage):void {			data.stage	= container;		}		public override function get stage():Stage {			if(super.stage) {				return super.stage;			} else if(data) {				return data.stage;			} else {				return null;			}		}				/** Indicates the width of the display object, in pixels. **/		public override function get width():Number {			if(data && data.width != undefined && data.width > 0) {				return data.width;			} else {				return super.width;			}		}		public override function set width(value:Number):void {			data.width	= value;			super.width	= value;		}				/** Indicates the height of the display object, in pixels. **/		public override function get height():Number {			if(data && data.height != undefined && data.height > 0) {				return data.height;			} else {				return super.height;			}		}				public override function set height(value:Number):void {			data.height		= value;			super.height	= value;		}				public override function get x():Number {			return data.x;		}				public override function set x(value:Number):void {			data.x	= value;			super.x	= value;		}				public override function get y():Number {			return data.y;		}				public override function set y(value:Number):void {			data.y	= value;			super.y	= value;		}				private function onAddToStage(e:ElementEvent):void {			isSetup	= true;		}				public function getBitmapData():BitmapData {			var bData:BitmapData = new BitmapData(width, height, true, 0x000000);			bData.draw(this);						return bData;		}				/** Kill the object and clean from memory. **/		public override function kill():void {			super.kill();		}	}}