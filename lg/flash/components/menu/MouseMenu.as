//Drop Down Menu
package lg.flash.components.menu {
	//LG Classes
	import lg.flash.events.ElementEvent;
	import lg.flash.elements.VisualElement;
	import lg.flash.elements.Shape;
	
	public class MouseMenu extends VisualElement {
		public var index:int			= 0;
		private var _duration:Number;
		private var _effect:String;
		private var _menuItems:Array	= [];
		private var _hoverItems:Array	= [];
		private var _mask:Shape;
		private var _menu:VisualElement;
		private var _target:VisualElement;
		
		public function MouseMenu(obj:Object) {
			_target		= obj.target;
			_duration	= duration in obj ? obj.duration : 0;
			_effect		= effect in obj ? obj.effect : 'none';
			
			//Create item container
			_menu		= new VisualElement();
			addChild(_menu);
			
			//Create Mask
			cacheAsBitmap	= true;
			_mask = new Shape({width:50, height:50, color:0x000000, alpha:0, cacheAsBitmap:true});
			addChild(_mask);
			//mask			= _mask;
			
			_target.button();
			_target.toggle(onToggleOn, onToggleOff);
		}

		private function onToggleOn(e:ElementEvent):void {
			trace('onToggleOn');
			setPos(e.target.mouseX, e.target.mouseY);
			show(_duration);
		}

		private function onToggleOff(e:ElementEvent):void {
			trace('onToggleOff');
			hide(_duration);
		}
		
		public function addItem(element:VisualElement, hover:VisualElement=null):void {
			var menuLen:int		= _menuItems.length;
			_menuItems[menuLen]	= element;
			
			if(hover != null) {
				var hoverLen:int		= _hoverItems.length;
				_hoverItems[hoverLen]	= hover;
			}
			
			generate();
		}
		
		private function generate():void {
			var g:int, menuLen:int, menuHeight:Number=0, menuWidth:Number=0, itemVertGap:Number=0, itemHorzGap:Number=0, element:VisualElement, hover:VisualElement;
			
			//Remove Existing Items
			menuLen = _menu.children.length;
			for(g=menuLen-1; g<0; g--) {
				_menu.removeChildAt(g);
			}
			
			//Add New Items
			for(g=0; g<menuLen; g++) {
				element		= _menuItems[g];
				hover		= g in _hoverItems ? _hoverItems[g] : null;
				menuHeight	+= element.height;
				
				if(element.width > menuWidth)
					menuWidth	= element.width;
				
//				element.show();
				element.vars.index	= g;
				element.x			= 0;
				element.y			= element.height * g;
				element.vars['y']	= element.y;
				_menu.addChild(element);
				
				//Add Listeners
				element.click(onClick);
				
				//Add Rollover effects
				switch(_effect) {
					case 'grow':
						element.hover(onGrowOver, onGrowOut);
						break;
					case 'hover':
						if(hover) {
							hover.ghost();
							hover.vars.index	= g;
							hover.x				= 0;
							
							if(hover.width > menuWidth) {
								menuWidth	= hover.width;
							}
							
							//Squeeze Effect
							if(hover.height > element.height) {
								itemVertGap			= (hover.height - element.height)*.5;
								hover.y				= element.y - itemVertGap;
								hover.vars.gap		= itemVertGap;
								menuHeight			+= (itemVertGap*2);
							} else {
								hover.y	= element.y;
							}
							
							
							if(hover.width > element.width) {
								itemHorzGap	= (hover.width - element.width)*.5;
								hover.x		= element.x - itemHorzGap;
							}
							
							_menu.addChild(hover);
							element.hover(onHoverOver, onHoverOut);
						}
						break;
					case 'none':
						break;
				}
			}
			_mask.width		= menuWidth;
			_mask.height	= menuHeight;
			_mask.x			= -(itemVertGap);
			_mask.y			= -(itemHorzGap);
			
			_menu.y			= -(_menu.height);
		}
		
		public override function show(duration:Number=0, delay:Number=0, callback:Function=null):VisualElement {
			toFront();
			tween({alpha:1, y:0}, {duration:duration, delay:delay});
			return this;
		}
		public override function hide(duration:Number=0, delay:Number=0, callback:Function=null):VisualElement {
			toFront();
			tween({alpha:0, y:-(_menu.height)}, {duration:duration, delay:delay});
			return this;
		}
		private function onClick(e:ElementEvent):void {
			index = e.target.vars.index;
			trigger(ElementEvent.CHANGE);
		//	toggleMenu(e);
		}
		
		public function onGrowOver(e:ElementEvent):void {
			var element:VisualElement	= e.target as VisualElement;
			element.animate({scaleX:1.2, scaleY:1.2}, {duration:.5});
		}
		public function onGrowOut(e:ElementEvent):void {
			var element:VisualElement	= e.target as VisualElement;
			element.animate({scaleX:1, scaleY:1}, {duration:.5});
		}
		
		public function onHoverOver(e:ElementEvent):void {
			var g:int=0, element:VisualElement, menuLen:int, hoverIdx:int, hover:VisualElement;
			
			hoverIdx	= e.target.vars.index;
			hover		= _hoverItems[hoverIdx] as VisualElement;
			menuLen		= _menu.children.length;
			
			for(g=0; g<menuLen; g++) {
				element	= _menu.children[g];
				if(g < hoverIdx)
					element.animate({alpha:1, y:element.vars.y - hover.vars.gap}, {duration:.2});
				
				if(g == hoverIdx)
					element.animate({alpha:0}, {duration:.2});
				
				if(g > hoverIdx)
					element.animate({alpha:1, y:element.vars.y + hover.vars.gap}, {duration:.2});
			}
			
			hover.animate({alpha:1}, {duration:.2});
		}
		
		public function onHoverOut(e:ElementEvent):void {
			var hover:VisualElement, g:int=0, element:VisualElement, menuLen:int, hoverIdx:int;
			
			hoverIdx	= e.target.vars.index;
			hover		= _hoverItems[hoverIdx] as VisualElement;
			menuLen		= _menu.children.length;
			
			for(g=0; g<menuLen; g++) {
				element	= _menu.children[g];
				if(g == hoverIdx)
					element.animate({alpha:1}, {duration:.2});
				else
					element.animate({y:element.vars.y}, {duration:.2});
			}
			
			hover.animate({alpha:0}, {duration:.2});
		}
	}
}