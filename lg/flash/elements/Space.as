/**
* Space by Giraldo Rosales.
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

package lg.flash.elements {
	//Flash
	import flash.utils.Timer;
	import flash.events.Event;
	
	//PaperVision3D Classes
	import org.papervision3d.view.Viewport3D;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.core.render.clipping.ClipFlags;
	
	//LG Classes
	import lg.flash.events.ElementEvent;
	import lg.flash.elements.VisualElement;
	import flash.display.DisplayObject;
	
	
	/**
	* Dispatched when a space starts rendering.
	* @eventType mx.events.ElementEvent.PLAY
	*/
	[Event(name="element_play", type="lg.flash.events.ElementEvent")]
	
	/**
	* Dispatched when a space stops rendering.
	* @eventType mx.events.ElementEvent.STOP
	*/
	[Event(name="element_stop", type="lg.flash.events.ElementEvent")]
	
	
	public class Space extends VisualElement {
		//Public Vars
		/** Reference to PaperVision3D Viewport3D object **/
		public var viewport:Viewport3D;
		/** Reference to PaperVision3D scene **/
		//public var scene:Scene3D		= new Scene3D();
		public var scene:Scene3D;
		/** Reference to the Papervision3D Camera3D object. **/
		public var camera:Camera3D;
		
		/** @private **/
		private var _renderer:BasicRenderEngine;
		/** @private **/
		private var _delayedStop:Timer	= new Timer(500, 0);
		
		/** 
		*	Constructs a new Space object. Camera coordinates are all set to 0.
			Camera zoom is set to 100 and far is set to 1500 by default.
		*	@param obj Object containing all properties to construct the class	
		**/
		public function Space(obj:Object) {
			super();
			holder();
			
			data.x					= 0;
			data.y					= 0;
			data.autoPlay			= true;
			data.autoSize			= false;
			data.interactive		= false;
			data.autoClipping		= true;
			data.autoCulling		= true;
			
			if(!data.width || !data.height) {
				data.width		= 0;
				data.height		= 0;
				data.autoSize	= true;
			}
			
			//Camera settings
			var camObj:Object		= {};
			camObj.x				= 0;
			camObj.y				= 0;
			camObj.z				= 0;
			camObj.fov				= 60;
			camObj.near				= 1;
			camObj.far				= 5000;
			camObj.rotationX		= 0;
			camObj.rotationY		= 0;
			camObj.rotationZ		= 0;
			camObj.enableCulling	= true;
			camObj.showFrustum		= false;
			
			//Set Attributes
			setAttributes(obj);
			
			//Set camera attributes
			if(data.camera) {
				var obj:Object	= data.camera as Object;
				
				for(var s:String in obj) {
					camObj[s]	= obj[s];
				}
			}
			
			//Scene
			scene					= new Scene3D();
			
			//Camera
			camera					= new Camera3D({id:'Camera'});
			camera.x				= camObj.x;
			camera.y				= camObj.y;
			camera.z				= camObj.z;
			camera.fov				= camObj.fov;
			camera.near				= camObj.near;
			camera.far				= camObj.far;
			camera.rotationX		= camObj.rotationX;
			camera.rotationY		= camObj.rotationY;
			camera.rotationZ		= camObj.rotationZ;
			camera.enableCulling	= camObj.enableCulling;
			camera.showFrustum		= camObj.showFrustum;
			scene.addCamera(camera);
			
			//Viewport
			viewport				= new Viewport3D({width:data.width, height:data.height, autoSize:data.autoSize, interactive:data.interactive, autoClipping:data.autoClipping, autoCulling:data.autoCulling});
			viewport.scene			= scene;
			addChild(viewport);
			
			//Renderer
			_renderer				= new BasicRenderEngine();
			_renderer.clipFlags 	= ClipFlags.ALL;
			
			isSetup = true;
			bind(ElementEvent.ADD, onAddedToStage);
			
			//Resize element
			super.width				= data.width;
			super.height			= data.height;
			
			_delayedStop.addEventListener('timer', onDelayedStop);
		}
		
		/** Start rendering the 3D scene. **/
		public function play():void {
			//trace('play::isPlaying', isPlaying);
			_delayedStop.stop();
			
			if(!isPlaying) {
				bind('element_enter', onEnter);
			}
		}
		
		/** Stop rendering the 3D scene. **/
		public function stop():void {
			_delayedStop.reset();
			_delayedStop.start();
		}
		private function onDelayedStop(e:Event):void {
			_delayedStop.stop();
			
			if(isPlaying) {
				unbind('element_enter', onEnter);
			}
		}
		
		/** Determine if the scene is currently rendering. **/
		public function get isPlaying():Boolean {
			var playing:Boolean = hasEventListener('element_enter');
			return playing;
		}
		
		/** Start rendering 3D scene when added to stage. **/
		public function set autoPlay(value:Boolean):void {
			data.autoPlay	= value;
		}
		public function get autoPlay():Boolean {
			return data.autoPlay;
		}
		
		/** @private **/
		private function onAddedToStage(e:ElementEvent):void {
			unbind('element_add', onAddedToStage);
			
			if(scene.numChildren > 0 && data.autoPlay) {
				play();
			}
		}
		
		
		/** @private **/
		private function onEnter(e:ElementEvent=null):void {
			if(scene.numChildren > 0) {
				_renderer.renderScene(scene, camera, viewport);
			}
		}
		
		public function addObject(child:DisplayObject3D):void {
			//addChild(child);
			scene.addChild(child);
		}
		/*
		public override function addChild(child:DisplayObject):DisplayObject {
			super.addChild(child);
			var child3D:DisplayObject3D	= child as DisplayObject3D;
			scene.addObject(child3D);
		}
		
		*/
		/** @private **/
		public function set navigateDrag(value:Boolean):void {
			data.navigateDrag	= value;
			
			if(data.navigateDrag) {
				mousedown(moveByDrag);
			} else {
				unbind(ElementEvent.MOUSEDOWN, moveByDrag);
			}
		}
		public function get navigateDrag():Boolean {
			return data.navigateDrag;
		}
		
		/** @private **/
		private function moveByDrag(e:ElementEvent):void {
			
		}
		
		/** Kill the object and clean from memory. **/
		public override function kill():void {
			unbind('element_add', onAddedToStage);
			unbind('element_enter', onEnter);
			//unbind(ElementEvent.MOUSEDOWN, moveByDrag);
			
			_renderer.kill();
			
			for(var s:String in children) {
				removeChild(children[s]);
				children[s] = null;
			}
			super.kill();
		}
	}
}