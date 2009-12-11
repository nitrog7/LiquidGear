//Drop Down Menu
package lg.flash.components.menu {
	import flash.display.*;
	import flash.events.*;
	
	//LG Classes
	import lg.flash.events.ElementEvent;
	import lg.flash.elements.VisualElement;
	
	public class DropDown extends VisualElement {
		private var _speed:Number;
		private var _effect:String;
		private var _menuItems:Array	= [];
		private var _hoverItems:Array	= [];
		private var _menu:VisualElement	= new VisualElement();
		private var _mask:Shape;
		private var _target:VisualElement;
		
		public function DropDown(element:VisualElement, speed:Number=0.5, effect:String='none') {
			_target	= element;
			_speed	= speed;
			_effect	= effect;
			
			resetPosition();
			_menu.hide();
			
			//Create Mask
			_mask = new Shape({width:50, height:50, color:0x000000, alpha:0});
			addChild(_mask);
			
			_target.toggle(onToggleOn, onToggleOff)
		}
		
		private function resetPosition():void {
			this.setPos(_target.x, (_target.y + _target.height));
		}

		private function onToggleOn(e:ElementEvent):void {
			show(_speed);
		}

		private function onToggleOff(e:ElementEvent):void {
			hide(_speed);
		}
		
		public function addItem(element:VisualElement, hover:VisualElement=null):void {
			var menuLen:int		= _menuItems.length;
			_menuItems[menuLen]	= element;
			
			if(hc != null) {
				var hoverLen:int		= _hoverItems.length;
				_hoverItems[hoverLen]	= hover;
			}
			
			genMenu();
		}
		
		private function genMenu():void {
			var g:int, menuLen:int, menuHeight:Number=0, menuWidth:Number=0, itemVertGap:Number=0, itemHorzGap:Number=0, element:VisualElement, hover:VisualElement;
			
			//Remove Existing Items
			menuLen	= _menuItems.length;
			for(g=menuLen-1; g<0; g--) {
				_menu.removeChildAt(g);
			}
			
			//Add New Items
			for(g=0; g<menuLen; g++) {
				element		= _menuItems[g];
				hover		= _hoverItems[g];
				menuHeight	+= element.height;
				
				if(element.width > menuWidth)
					menuWidth	= element.width;
				
				element.show();
				element.index		= g;
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
						break;
					case 'none':
						break;
				}
			}
			_mask.width		= menuWidth;
			_mask.height	= menuHeight;
			_mask.x			= -(itemVertGap);
			_mask.y			= -(itemHorzGap);
			
			this.mask		= _mask;
			_menu.y			= -(_menu.height);
		}
		
		public override function show(time:Number=0, delay:Number=0):void {
			toFront();
			tween({alpha:1, y:0}, {duration:time, delay:delay});
		}
		public override function hide(time:Number=0, delay:Number=0):void {
			toFront();
			tween({alpha:0, y:-(_menu.height)}, {duration:time, delay:delay});
		}
		private function onClick(e:ElementEvent):void {
			toggleMenu(e);
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
			menuLen		= _menuItems.length;
			
			for(g=0; g<menuLen; g++) {
				element	= _menuItems[g];
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
			var hover:VisualElement, g:int=0, element:VisualElement;
			
			hoverIdx	= e.target.vars.index;
			hover		= _hoverItems[hoverIdx] as VisualElement;
			menuLen		= _menuItems.length;
			
			for(g=0; g<menuLen; g++) {
				element	= _menuItems[g];
				if(g == hoverIdx)
					element.animate({alpha:1}, {duration:.2});
				else
					element.animate({y:element.vars.y}, {duration:.2});
			}
			
			hover.animate({alpha:0}, {duration:.2});
		}
	}
}