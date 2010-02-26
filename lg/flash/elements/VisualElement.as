/*** VisualElement Class by Giraldo Rosales.* Visit www.liquidgear.net for documentation and updates.*** Copyright (c) 2010 Nitrogen Labs, Inc. All rights reserved.* * Permission is hereby granted, free of charge, to any person* obtaining a copy of this software and associated documentation* files (the "Software"), to deal in the Software without* restriction, including without limitation the rights to use,* copy, modify, merge, publish, distribute, sublicense, and/or sell* copies of the Software, and to permit persons to whom the* Software is furnished to do so, subject to the following* conditions:* * The above copyright notice and this permission notice shall be* included in all copies or substantial portions of the Software.* * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR* OTHER DEALINGS IN THE SOFTWARE.**/package lg.flash.elements {	//Flash	import flash.display.BitmapData;	import flash.display.Sprite;	import flash.display.Stage;	import flash.events.Event;	import flash.filters.*;	import flash.geom.Matrix;	import flash.geom.Rectangle;		import lg.flash.effects.Reflect;	import lg.flash.events.ElementEvent;	import lg.flash.motion.GTween;	import lg.flash.motion.Tween;	import lg.flash.motion.easing.Back;	import lg.flash.motion.easing.Elastic;	import lg.flash.motion.easing.Quintic;	import lg.flash.motion.plugins.AutoHidePlugin;		/**	* Dispatched when an animation begins.	* @eventType mx.events.ElementEvent.TWEENSTART	*/	[Event(name="element_tween_start", type="lg.flash.events.ElementEvent")]		/**	* Dispatched while an animation is in progress.	* @eventType mx.events.ElementEvent.TWEENUPDATE	*/	[Event(name="element_tween_update", type="lg.flash.events.ElementEvent")]		/**	* Dispatched when an animation completes.	* @eventType mx.events.ElementEvent.TWEENEND	*/	[Event(name="element_tween_end", type="lg.flash.events.ElementEvent")]			public class VisualElement extends Element {		/** @private **/		private var _hitArea:Sprite		= new Sprite();		/** @private **/		private var _layout:Object		= {};		private var _tween:Tween;		private var _isResize:Boolean	= false;				/** Constructs a new VisualElement object **/		public function VisualElement(obj:Object=null) {			super();						AutoHidePlugin.install();						//Be sure to update element when added to stage.			addEventListener('addedToStage', onInitAdd, false, 0, true);						//Set defaults			data.enabled			= false;			data.x					= 0;			data.y					= 0;			data.width				= NaN;			data.height				= NaN;						//Layout			_layout.x				= 0;			_layout.y				= 0;			_layout.top				= NaN;			_layout.bottom			= NaN;			_layout.left			= NaN;			_layout.right			= NaN;			_layout.width			= NaN;			_layout.height			= NaN;			_layout.position		= 'default';						data.position			= 'default';			data.bottom				= NaN;			data.right				= NaN;			data.minWidth			= NaN;			data.minHeight			= NaN;			data.maxWidth			= NaN;			data.maxHeight			= NaN;			data.minX				= NaN;			data.minY				= NaN;			data.maxX				= NaN;			data.maxY				= NaN;			data.percentTop			= NaN;			data.percentBottom		= NaN;			data.percentLeft		= NaN;			data.percentRight		= NaN;			data.horizontalCenter	= false;			data.verticalCenter		= false;						//data.percentWidth		= NaN;			//data.percentHeight	= NaN;						data.minBottom			= NaN;			data.minRight			= NaN;			data.maxBottom			= NaN;			data.maxRight			= NaN;			data.percentHCenter		= NaN;			data.percentVCenter		= NaN;			data.minHCenter			= NaN;			data.minVCenter			= NaN;			data.aspectRatio		= false;			data.aspectRatioPolicy	= 'smallest';						//Set listeners			bind('element_add', onAddToStage);						//Set defined attributes			if(obj) {				setAttributes(obj);				isSetup	= true;			}		}						/** @private **/		protected override function setAttributes(obj:Object, ignore:Array=null):void {			if(!obj) {				return;			}						if(obj.stage) {				stage		= obj.stage;			}						if(obj.parent) {				parent		= obj.parent;			}						super.setAttributes(obj, ignore);		}				/** @private **/		private function onInitAdd(e:Event):void {			removeEventListener('addedToStage', onInitAdd);			update();		}				/*=========================		 * EFFECTS		 *=========================*/				/** Fade in element 		*	@param duration (optional) The duration of the animation. if set to 0, the element visibility is promptly set to true and alpha to 1.		*	@param delay (optional) Amount of time to wait before starting the aniamtion.		*	@param callback (optional) Function to call on completion.		*	@param params (optional) Parameters to send with function on complete.		*/		public function show(duration:Number=0, delay:Number=0, callback:Function=null, params:Array=null):VisualElement {			toFront();						if(callback != null) {				data.onShowComplete	= callback;				data.onShowParams	= params;				new GTween(this, duration, {alpha:1}, {delay:delay}, {ease:Quintic.easeInOut, onComplete:onShowComplete});			} else {				new GTween(this, duration, {alpha:1}, {delay:delay}, {ease:Quintic.easeInOut});			}						return this;		}				/** @private **/		private function onShowComplete(tween:GTween):void {			var fnc:Function	= data.onShowComplete as Function;						if(data.onShowParams) {				fnc(data.onShowParams);			} else {				fnc();			}						data.onShowComplete	= null;			data.onShowParams	= null;		}				/** Fade out element 		*	@param duration (optional) The duration of the animation. if set to 0, the element visibility is promptly set to false and alpha to 0.		*	@param delay (optional) Amount of time to wait before starting the aniamtion.		*	@param callback (optional) Function to call on completion.		*	@param params (optional) Parameters to send with function on complete.		*/		public function hide(duration:Number=0, delay:Number=0, callback:Function=null, params:Array=null):VisualElement {			if(callback != null) {				data.onHideComplete	= callback;				data.onHideParams	= params;				new GTween(this, duration, {alpha:0}, {delay:delay}, {ease:Quintic.easeInOut, onComplete:onHideComplete});			} else {				new GTween(this, duration, {alpha:0}, {delay:delay}, {ease:Quintic.easeInOut});			}						return this;		}				/** @private **/		private function onHideComplete(tween:GTween):void {			var fnc:Function	= data.onHideComplete as Function;						if(data.onHideParams) {				fnc(data.onHideParams);			} else {				fnc();			}						data.onHideComplete	= null;			data.onHideParams	= null;		}				/** Pulls the element in the front of the existing children. **/		public function toFront():void {			parent.setChildIndex(this, parent.numChildren-1);		}		/** Pushes the element to the back, behind all the elements within the parent **/		public function toBack():void {			parent.setChildIndex(this, 1);		}				/** Toggles the alpha and visibility of an element. 		*	@default false */		public function get hidden():Boolean {			var isHidden:Boolean	= (alpha == 0 && !visible) ? true : false;			return isHidden;		}		public function set hidden(value:Boolean):void {			data.hidden	= value;			if(id == 'out') trace('hidden', value);						if(value) {				alpha	= 0;				visible	= false;			} else {				alpha	= 1;				visible	= true;			}		}				/** Animate element **/		public function animate(obj:Object):Tween {			obj.target	= this;			//trace('VE::			_tween		= new Tween(obj);						return _tween;		}				/** @private **/		public function slideDown(duration:Number=0, callback:Function=null):VisualElement {			return this;		}				/** @private **/		public function slideUp(duration:Number=0, callback:Function=null):VisualElement {			return this;		}				/** @private **/		public function slideToggle(duration:Number=0, callback:Function=null):VisualElement {			return this;		}				/** Fade element to specific alpha value.		*	@param opacity (optional) Opacity of element. (default: 1)		*	@param duration (optional) The duration of the animation. if set to 0, the element visibility is promptly set to true and alpha to 1. (default: 0)		*	@param callback (optional) Function to call on completion.		*	@param params (optional) Parameters to send with function on complete.		*/		public function fadeTo(opacity:Number=1, duration:Number=0, callback:Function=null, params:Array=null):VisualElement {			var obj:Object	= {};			obj.target		= this;			obj.autoAlpha	= opacity;			obj.duration	= duration;						if(callback != null) {				obj.onComplete			= callback;				obj.onCompleteParams	= params;			}						new Tween(obj);						return this;		}				/** Flip the element horizontally **/		public function flipX():void {			scaleX = -1;		}				/** Flip the element vertically **/		public function flipY():void {			scaleY = -1;		}				/** 		*	Creates a custom hitArea for the element.		*	@param width (optional) Width of the hitArea. (default: 0)		*	@param height (optional) Height of the hitArea. (default: 0)		**/		public function hitBox(width:Number=0, height:Number=0):void {			if(width == 0) {				width	= data.width;			}						if(height == 0) {				height	= data.height;			}						_hitArea.graphics.clear();			_hitArea.graphics.beginFill(0x000000, 0);			_hitArea.graphics.drawRect(0, 0, width, height);			_hitArea.graphics.endFill();						hitArea	= _hitArea;		}				/** 		*	Creates a custom hitArea  in the shape of a circle for the element.		*	@param width (optional) Width of the hitArea. (default: 0)		*	@param height (optional) Height of the hitArea. (default: 0)		**/		public function hitSpot(width:Number=0, height:Number=0):void {			if(width == 0) {				width	= data.width *.8;			}			if(height == 0) {				height	= data.height *.8;			}						_hitArea.graphics.clear();			_hitArea.graphics.beginFill(0x000000, 0);			_hitArea.graphics.drawEllipse((data.width-width)*.5, (data.height-height)*.5, width, height);			_hitArea.graphics.endFill();						hitArea	= _hitArea;		}				/**		*	Pops the element outward.		*	@param duration (optional) Duration of the animation. (default: .5)		*	@param delay (optional) Time to wait before animating. (default: 0)		**/		public function popOut(time:Number=.5, delay:Number=0):void {			toFront();			new Tween({target:this, duration:time, startAt:{x:x+(width*.15), y:y+(height*.15), scaleX:.7, scaleY:.7, alpha:0}, x:x, y:y, scaleX:1, scaleY:1, autoAlpha:1, delay:delay, ease:Elastic.easeInOut, overwrite:2});		}				/**		*	Pops the element inward.		*	@param duration (optional) Duration of the animation. (default: .5)		*	@param delay (optional) Time to wait before animating. (default: 0)		**/		public function popIn(duration:Number=.5, delay:Number=0):void {			new Tween({target:this, duration:duration, x:x+(width*.15), y:y+(height*.15), scaleX:.7, scaleY:.7, autoAlpha:0, delay:delay, ease:Back.easeOut, overwrite:2, onComplete:resetPrevious});		}				/**@private **/		private function resetPrevious():void {			x		= data.x;			y		= data.y;			scaleX	= 1;			scaleY	= 1;		}				/**		*	Add a drop shadow to the element.		*	@param prop Properties of the dropShadowFilter.		*	<ul>		*		<li><strong>alpha</strong>:<em>Number</em> - Alpha transparency value for the color. (default: 1)</li>		*		<li><strong>distance</strong>:<em>Number</em> - Offset distance for the shadow, in pixels. (default: 0)</li>		*		<li><strong>angle</strong>:<em>Number</em> - Angle of the shadow. (default: 45)</li>		*		<li><strong>blurX</strong>:<em>Number</em> - Amount of horizontal blur. (default: 15)</li>		*		<li><strong>blurY</strong>:<em>Number</em> - Amount of vertical blur. (default: 15)</li>		*		<li><strong>color</strong>:<em>uint</em> - Color of the shadow. (default: 0x000000)</li>		*		<li><strong>strength</strong>:<em>Number</em> - The strength of the imprint or spread. (default: 1)</li>		*		<li><strong>inner</strong>:<em>Boolean</em> - Specifies whether the glow is an inner glow. (default: false)</li>		*		<li><strong>knockout</strong>:<em>Boolean</em> - Specifies whether the object has a knockout effect. (default: false)</li>		*		<li><strong>quality</strong>:<em>Number</em> - The number of times to apply the filter. 1 - Low, 2 - Medium, 3 - High. (default: 3)</li>		*		<li><strong>addFilter</strong>:<em>Boolean</em> - Add a new filter, else overwrite existing glowFilter. (default: true)</li>		*	</ul>		**/		public function shadow(prop:Object=null):Element {			var obj:Object	= {};						//Set defaults			obj.distance	= 0;			obj.angle		= 45;			obj.alpha		= 1;			obj.blurX		= 15;			obj.blurY		= 15;			obj.color		= 0x000000;			obj.strength	= 1;			obj.quality		= 3;			obj.inner		= false;			obj.knockout	= false;			obj.addFilter	= true;						if(prop) {				//Set custom properties				for(var s:String in prop) {					obj[s]	= prop[s];				}			}						new Tween({target:this, duration:0, dropShadowFilter:obj});			return this;		}				/**		*	Add a glow filter to the element.		*	@param prop Properties of the glowFilter.		*	<ul>		*		<li><strong>alpha</strong>:<em>Number</em> - Alpha transparency value for the color. (default: 1)</li>		*		<li><strong>blurX</strong>:<em>Number</em> - Amount of horizontal blur. (default: 15)</li>		*		<li><strong>blurY</strong>:<em>Number</em> - Amount of vertical blur. (default: 15)</li>		*		<li><strong>color</strong>:<em>uint</em> - Color of the glow. (default: 0xffffff)</li>		*		<li><strong>strength</strong>:<em>Number</em> - The strength of the imprint or spread. (default: 1)</li>		*		<li><strong>inner</strong>:<em>Boolean</em> - Specifies whether the glow is an inner glow. (default: false)</li>		*		<li><strong>knockout</strong>:<em>Boolean</em> - Specifies whether the object has a knockout effect. (default: false)</li>		*		<li><strong>quality</strong>:<em>Number</em> - The number of times to apply the filter. 1 - Low, 2 - Medium, 3 - High. (default: 3)</li>		*		<li><strong>addFilter</strong>:<em>Boolean</em> - Add a new filter, else overwrite existing glowFilter. (default: true)</li>		*	</ul>		**/		public function glow(prop:Object=null):VisualElement {			var obj:Object	= {};			var time:Number	= .25;						//Set defaults			obj.alpha		= 1;			obj.blurX		= 15;			obj.blurY		= 15;			obj.color		= 0xffffff;			obj.strength	= 1;			obj.quality		= 3;			obj.addFilter	= true;						if(prop) {				if('duration' in prop) {					time	= prop['duration'];					delete(prop['duration']);				}								//Set custom properties				for(var s:String in prop) {					obj[s]	= prop[s];				}			}						if(obj.blurX == 0 && obj.blurY == 0) {				new Tween({target:this, duration:time, glowFilter:{remove:true}});			} else {				new Tween({target:this, duration:time, glowFilter:obj});			}						return this;		}				/**		*	Creates a glow around the element when the mouse is over and removes it when mouse moves out.		*	@param size (optional) Size of the glow. (default: 10).		*	@param color (optional) Color of the glow. (default: 0xffffff).		**/		public function hoverGlow(size:Number=10, color:uint=0xffffff):void {			if(size > 0) {				data.hoverGlow_size		= size;				data.hoverGlow_color	= color;				hover(onGlowOn, onGlowOff);			} else {				unbind(ElementEvent.MOUSEOVER, onGlowOn);				unbind(ElementEvent.MOUSEOUT, onGlowOff);				new Tween({target:this, duration:0, glowFilter:{remove:true}});			}		}				/** @private **/		private function onGlowOn(e:ElementEvent):void {			new Tween({target:this, duration:.25, glowFilter:{alpha:1, blurX:data.hoverGlow_size, blurY:data.hoverGlow_size, color:data.hoverGlow_color}});		}				/** @private **/		private function onGlowOff(e:ElementEvent):void {			new Tween({target:this, duration:.25, glowFilter:{alpha:0, blurX:0, blurY:0, color:data.hoverGlow_color}});		}				/**		*	Creates a stroke around an element.		*	@param size (optional) Size of the stroke. (default: 1).		*	@param color (optional) Color of the stroke. (default: 0x000000).		**/		public function stroke(size:Number=1, color:uint=0x000000):Element {			data.stroke_size	= size;			data.stroke_color	= color;						if(size > 0) {				new Tween({target:this, duration:0, dropShadowFilter:{alpha:1, blurX:data.stroke_size, blurY:data.stroke_size, color:data.stroke_color, distance:0, angle:0, strength:25, addFilter:false}});			} else {				new Tween({target:this, duration:0, dropShadowFilter:{remove:true}});			}						return this;		}				/**		*	Blur an object. 		*	@param prop Variables used to blur.		*	<ul>		*		<li><strong>blurX</strong>:<em>Number</em> - (optional) The amount of horizontal blur. (default: .15)</li>		*		<li><strong>blurY</strong>:<em>Number</em> - (optional) The amount of vertical blur. (default: .15)</li>		*		<li><strong>duration</strong>:<em>Number</em> - (optional) If animating, duration of time to blur from previous values. (default: 0)</li>		*	</ul>		**/		public function blur(prop:Object=null):void {			var obj:Object={};						obj.blurX		= .15;			obj.blurY		= .15;			obj.duration	= 0;						for(var s:String in prop) {				obj[s] = prop[s];			}						if(obj.blurX == 0 && obj.blurY == 0) {				new Tween({target:this, duration:obj.duration, blurFilter:{remove:true}});			} else {				new Tween({target:this, duration:obj.duration, blurFilter:{blurX:obj.blurX, blurY:obj.blurY}});			}		}				/**		*	Create a reflection. 		*	@param prop Variables used to create reflection.		*	<ul>		*		<li><strong>alpha</strong>:<em>Number</em> - (optional) Opacity of the reflection. (default: .25)</li>		*		<li><strong>ratio</strong>:<em>Number</em> - (optional) Ratio of the glare. (default: 100)</li>		*		<li><strong>distance</strong>:<em>Number</em> - (optional) Distance from original element. (default: 0)</li>		*		<li><strong>updateTime</strong>:<em>Number</em> - (optional) Time persiod to update reflection. Use when animating element. To save on performance, set to -1 to turn off if not animating the element. (default: -1)</li>		*		<li><strong>reflectionDropoff</strong>:<em>Number</em> - (optional) Rate at which to fade. (default: 0)</li>		*	</ul>		**/		public function reflect(prop:Object=null):void {			var reflect:Reflect, obj:Object={};						obj.target				= this;			obj.alpha				= .25;			obj.ratio				= 100;			obj.distance			= 0;			obj.updateTime			= -1;			obj.reflectionDropoff	= 0;						for(var s:String in prop) {				obj[s] = prop[s];			}						reflect = new Reflect(obj);		}				/**		*	Set the size of the element		*	@param Set width.		*	@param Set height.		**/		public function setSize(width:Number, height:Number):void {			this.width	= width;			this.height	= height;		}				/**		*	Set the position of the element		*	@param Set x position.		*	@param Set y position.		**/		public function getSize():Rectangle {			var rect:Rectangle = new Rectangle(x, y, width, height);			return rect;		}				/**		*	Set the position of the element		*	@param Set x position.		*	@param Set y position.		**/		public function setPos(x:Number, y:Number, z:Number=0):void {			_layout.top		= NaN;			_layout.left	= NaN;						this.x	= x;			this.y	= y;		}				/** Get the bounds of the element **/		public function elementBounds():Rectangle {			var bounds:Rectangle	= new Rectangle(0, 0, width, height);			return bounds;		}				/** 		*	Scale element.		*	@param xScale Amount to scale along the x-axis.		*	@param yScale (optional) Amount to scale along the y-axis. If not set, yScale is set equal to xScale.		**/		public function scale(xScale:Number, yScale:Number=-1):void {			if(yScale < 0) {				scaleX	= scaleY = data.scaleX = data.scaleY = xScale;			} else {				scaleX	= data.scaleX = xScale;				scaleY	= data.scaleY = yScale;			}		}				/** Makes the element visible to the eye but invisible to the mouse. **/		public function ghost():void {			buttonMode		= false;			useHandCursor	= false;			mouseEnabled	= false;			mouseChildren	= false;		}				/** Gives the element button attributes. **/		public function button():void {			buttonMode		= true;			useHandCursor	= true;			mouseEnabled	= true;			mouseChildren	= false;		}				/** Toggles enable value. **/		public function set enabled(value:Boolean):void {			data.enabled	= value;		}		public function get enabled():Boolean {			return data.enabled;		}				/** References the Stage. Can add the stage if element has not yet been added. **/		public function set stage(container:Stage):void {			data.stage	= container;		}		public override function get stage():Stage {			if(super.stage) {				return super.stage;			} else if(data) {				return data.stage;			} else {				return null;			}		}				/** Indicates the width of the display object, in pixels. **/		public override function get width():Number {			if(data && data.width != undefined && data.width > 0) {				return data.width;			} else {				return super.width;			}		}		public override function set width(value:Number):void {			data.width		= value;			trace('VE::width', value, stretch, _layout.width);			if(stretch && value != _layout.width) {				_layout.width	= value;				reposition();			}		}				public function get maxWidth():Number {			return data.maxWidth;		}		public function set maxWidth(value:Number):void {			if(value != data.maxWidth) {				data.maxWidth	= value;				reposition();			}		}				public function get minWidth():Number {			return data.minWidth;		}		public function set minWidth(value:Number):void {			if(value != data.minWidth) {				data.minWidth	= value;				reposition();			}		}				/** Indicates the height of the display object, in pixels. **/		public override function get height():Number {			if(data && data.height != undefined && data.height > 0) {				return data.height;			} else {				return super.height;			}		}				public override function set height(value:Number):void {			data.height		= value;						if(stretch && value != _layout.height) {				_layout.height	= value;				reposition();			}		}				public function get minHeight():Number {			return data.minHeight;		}		public function set minHeight(value:Number):void {			if(value != data.minHeight) {				data.minHeight	= value;				reposition();			}		}				public function get maxHeight():Number {			return data.maxHeight;		}		public function set maxHeight(value:Number):void {			if(value != data.maxHeight) {				data.maxHeight	= value;				reposition();			}		}				public override function get x():Number {			return data.x;		}				public override function set x(value:Number):void {			data.x	= value;						if(value != _layout.left) {				_layout.left	= value;				reposition();			}		}				public function get minX():Number {			return data.minX;		}		public function set minX(value:Number):void {			if(value != data.minX) {				data.minX	= value;				reposition();			}		}				public function get maxX():Number {			return data.maxX;		}		public function set maxX(value:Number):void {			if(value != data.maxX) {				data.maxX	= value;				reposition();			}		}				public override function get y():Number {			return data.y;		}				public override function set y(value:Number):void {			data.y	= value;						if(value != _layout.top) {				_layout.top	= value;				reposition();			}		}				public function get minY():Number {			return data.minY;		}		public function set minY(value:Number):void {			if(value != data.minY) {				data.minY	= value;				reposition();			}		}				public function get maxY():Number {			return data.maxY;		}		public function set maxY(value:Number):void {			if(value != data.maxY) {				data.maxY	= value;				reposition();			}		}				public function get left():Number {			return data.x;		}				public function set left(value:Number):void {			data.x	= value;						if(value != _layout.left) {				_layout.left	= int(value);								/*				if(value < 1 && value > 0) {					data.percentLeft	= value;				} else {					data.percentLeft	= NaN;				}				*/								reposition();			}		}				public function get right():Number {			return data.right;		}				public function set right(value:Number):void {			data.right	= value;						if(value != _layout.right) {				_layout.right	= int(value);								/*				if(value < 1 && value > 0) {					data.percentRight	= value;				} else {					data.percentRight	= NaN;				}				*/								reposition();			}		}				public function get top():Number {			return data.y;		}				public function set top(value:Number):void {			data.y	= value;						if(value != _layout.top) {				_layout.top	= int(value);								/*				if(value < 1 && value > 0) {					data.percentTop	= value;				} else {					data.percentTop	= NaN;				}				*/								reposition();			}		}				public function get bottom():Number {			return data.bottom;		}				public function set bottom(value:Number):void {			data.bottom	= value;						if(value != _layout.bottom) {				_layout.bottom	= int(value);								/*				if(value < 1 && value > 0) {					data.percentBottom	= value;				} else {					data.percentBottom	= NaN;				}				*/								reposition();			}		}				public function get position():String {			return data.position;		}		public function set position(value:String):void {			var pos:String		= value.toLowerCase();			data.position		= pos;						if(_layout.position == pos) {				return;			}						switch(pos) {				case 'horizontalCenter':					data.horizontalCenter	= true;					break;				case 'verticalCenter':					data.verticalCenter		= true;					break;				case 'center':					data.horizontalCenter	= true;					data.verticalCenter		= true;					break;				case 'stretch':					data.x					= 0;					data.y					= 0;					data.width				= parentWidth;					data.height				= parentHeight;					stretch					= true;					break;				case 'stretchMin':					data.horizontalCenter	= true;					data.verticalCenter		= true;					data.minWidth			= data.width;					data.minHeight			= data.height;					break;				case 'stretchMax':					data.horizontalCenter	= true;					data.verticalCenter		= true;					data.maxWidth			= data.width;					data.maxHeight			= data.height;					break;				default:					data.horizontalCenter	= false;					data.verticalCenter		= false;					data.position	= 'default';					break;			}						_layout.position	= data.position;						reposition();		}				public function get horizontalCenter():Boolean {			return data.horizontalCenter;		}		public function set horizontalCenter(value:Boolean):void {			if(data.horizontalCenter == value) {				return;			}						data.horizontalCenter	= value;						reposition();		}				public function get verticalCenter():Boolean {			return data.verticalCenter;		}		public function set verticalCenter(value:Boolean):void {			if(data.verticalCenter == value) {				return;			}						data.verticalCenter	= value;						reposition();		}				public override function set visible(value:Boolean):void {			if(value) {				startResizing();			} else {				stopResizing();			}						super.visible	= value;		}				/** @private **/		private function get parentWidth():Number {			var w:int;						if(parent) {				w	= parent.width;			} else if(stage) {				w	= stage.stageWidth;			} else {				//trace(id + ': Stage or parent property is required.');				w	= 0;			}						return w;		}				/** @private **/		private function get parentHeight():Number {			var h:int;						if(parent) {				h	= parent.height;			} else if(stage) {				h	= stage.stageHeight;			} else {				//trace(id + ': Stage or parent property is required.');				h	= 0;			}						return h;		}				private function onAddToStage(e:ElementEvent):void {			isSetup	= true;			startResizing();		}				private function startResizing():void {			if(!_isResize && stage) {				_isResize	= true;				stage.addEventListener('resize', onResizeStage);				reposition();			}		}				private function stopResizing():void {			if(_isResize && stage) {				_isResize	= false;				stage.removeEventListener('resize', onResizeStage);			}		}				private function onResizeStage(e:Event):void {			update();		}				private function reposition():void {			if(!isSetup) {				return;			}						var tmpX:int;			var tmpY:int;			var tmpW:int;			var tmpH:int;			var autoPos:Boolean	= false;						//Get stage size			var stageW:int	= parentWidth;			var stageH:int	= parentHeight;						//Set anchor points			var stretchW:Boolean	= false;			var stretchH:Boolean	= false;						if(!isNaN(_layout.top) && !isNaN(_layout.bottom)) {				stretchH	= true;			}			if(!isNaN(_layout.left) && !isNaN(_layout.right)) {				stretchW	= true;			}						//Width			if(stretchW) {				tmpW	= stageW;								if(!isNaN(data.percentLeft) || !isNaN(data.percentRight)) {					if(!isNaN(data.percentLeft)) {						tmpW	-= stageW * data.percentLeft;					} else {						tmpW	-= _layout.left;					}										if(!isNaN(data.percentRight)) {						tmpW	-= stageW * data.percentRight;					} else {						tmpW	-= _layout.right;					}				} else {					tmpW	-= _layout.left - _layout.right;				}								_layout.width	= tmpW;			}						//Height			if(stretchH) {				_layout.height	= (stageH - _layout.bottom) - _layout.top;			}						if(!isNaN(_layout.height)) {				if(!isNaN(data.percentBottom)) {					if(!_layout.height) {						_layout.height	= stageH - (stageH * data.percentBottom);												if(!isNaN(_layout.top)) {							_layout.height	-= _layout.top;						}					}				}			}						//Get current width and height			tmpW	= (_layout.width) ? _layout.width : super.width;			tmpH	= (_layout.height) ? _layout.height : super.height;						//X position			if(data.horizontalCenter) {				_layout.x	= (stageW * .5) - (tmpW * .5);			}			else if(!stretchW && !isNaN(_layout.right)) {				_layout.x	= stageW - (super.width + _layout.right);			}			else if(!isNaN(_layout.left)) {				if(!isNaN(data.percentLeft)) {					_layout.x	= stageW * data.percentLeft;				} else {					_layout.x	= _layout.left;				}			}						//Y position			if(data.verticalCenter) {				_layout.y	= (stageH * .5) - (tmpH * .5);			}			else if(!stretchH && _layout.bottom && isNaN(data.percentBottom)) {				_layout.y		= stageH - (tmpH - _layout.bottom);			}			else if(!isNaN(_layout.top)) {				if(!isNaN(data.percentTop)) {					_layout.top	= stageH * data.percentTop;				}								_layout.y	= _layout.top;			} else {				if(!isNaN(_layout.height)) {					_layout.y	= stageH - (stageH * data.percentBottom) - _layout.height;				}			}						//Stay within the constraints			//Set X			if(data.horizontalCenter){				if(!isNaN(data.minX) && data.minX > _layout.x) {					_layout.x	= data.minX;				}				if(!isNaN(data.maxX) && data.maxX < _layout.x) {					_layout.x	= data.maxX;				}			}						super.x	= _layout.x;						//Set Y			if(data.verticalCenter){				if(!isNaN(data.minY) && data.minY > _layout.y) {					_layout.y	= data.minY;				}				if(!isNaN(data.maxY) && data.maxY < _layout.y) {					_layout.y	= data.maxY;				}			}						super.y	= _layout.y;						//Set Width			if(!isNaN(_layout.width)) {				if(!isNaN(data.minWidth) && data.minWidth > _layout.width) {					_layout.width	= data.minWidth;				}								if(!isNaN(data.maxWidth) && (data.maxWidth < _layout.width)) {					_layout.width	= data.maxWidth;				}								if(super.width > 0) {					super.width		= _layout.width;				}			}						//Set Height			if(!isNaN(_layout.height)) {				if(!isNaN(data.minHeight) && data.minHeight > _layout.height) {					_layout.height	= data.minHeight;				}								if(!isNaN(data.maxHeight) && (data.maxHeight < _layout.height)) {					_layout.height	= data.maxHeight;				}								if(super.height > 0) {					super.height	= _layout.height;				}			}		}				public function getBitmapData():BitmapData {			var bData:BitmapData = new BitmapData(width, height, true, 0x000000);			bData.draw(this);						return bData;		}				private function invalidate(value1:*, value2:*):void {			if (value1 != value2) {				reposition();			}		}				/** Update the elements properties. **/		public override function update(obj:Object=null):void {			reposition();		}				/** Kill the object and clean from memory. **/		public override function kill():void {			super.kill();		}	}}