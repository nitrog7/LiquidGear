package lg.flex.components {
	import lg.flex.components.scroll.*;
	import lg.flex.events.*;
	
    import mx.core.mx_internal;
	import mx.containers.Panel;
	import mx.events.FlexEvent;
	import mx.controls.scrollClasses.ScrollBar;
    import mx.styles.StyleProxy;
	
    use namespace mx_internal;
    
	public class LGpanel extends Panel {
		private var _eventParams:Object		= {};
		private var _fixedVThumb:Boolean	= false;
		private var _fixedHThumb:Boolean	= false;
		
		public function LGpanel() {
			super();
			
			//Add Event Listeners
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onComplete);
			this.addEventListener(FlexEvent.UPDATE_COMPLETE, onUpdate);
		}
		
		
		/* ScrollBars */
		public function get horizontalScroll():ScrollBar {
			return super.horizontalScrollBar;
		}
		public function set horizontalScroll(scroll:ScrollBar):void {
			super.horizontalScrollBar = scroll;
		}
		
		public function get verticalScroll():ScrollBar {
			return super.verticalScrollBar;
		}
		public function set verticalScroll(scroll:ScrollBar):void {
			super.verticalScrollBar = scroll;
		}
		
        
        /* Fixed Thumb */
		//Horizontal
		public function get fixedHorizontalThumb():Boolean {
			return _fixedHThumb;
		}
		public function set fixedHorizontalThumb(value:Boolean):void {
            _fixedHThumb	= value;
            
            if(_fixedHThumb) {
	            if (horizontalScroll != null) {
	                if (!(horizontalScroll.scrollThumb is FixedSizeThumb)) {
	                    horizontalScroll.removeChild(horizontalScroll.scrollThumb);
	                    
	                    var fixedThumb:FixedSizeThumb = new FixedSizeThumb();
	                    fixedThumb.x	= horizontalScroll.scrollThumb.x;
	                    fixedThumb.y	= horizontalScroll.scrollThumb.y;
	                    
	                    fixedThumb.styleName	= new StyleProxy(horizontalScroll, null);
	                    fixedThumb.upSkinName	= "thumbUpSkin";
	                    fixedThumb.overSkinName	= "thumbOverSkin";
	                    fixedThumb.downSkinName	= "thumbDownSkin";
	                    fixedThumb.iconName		= "thumbIcon";
	                    fixedThumb.skinName		= "thumbSkin";
	                    
	                    horizontalScroll.scrollThumb	= fixedThumb;
	                    horizontalScroll.addChildAt(fixedThumb, horizontalScroll.getChildIndex(horizontalScroll.downArrow));
	                }
	            }
            }
        }
        
        //Vertical
		public function get fixedVerticalThumb():Boolean {
			return _fixedVThumb;
		}
		public function set fixedVerticalThumb(value:Boolean):void {
            _fixedVThumb	= value;
            
            if(_fixedVThumb) {
	            if (verticalScroll != null) {
	                if (!(verticalScroll.scrollThumb is FixedSizeThumb)) {
	                    verticalScroll.removeChild(verticalScroll.scrollThumb);
	                    
	                    var fixedThumb:FixedSizeThumb = new FixedSizeThumb();
	                    fixedThumb.x = verticalScroll.scrollThumb.x;
	                    fixedThumb.y = verticalScroll.scrollThumb.y;
	                    
	                    fixedThumb.styleName	= new StyleProxy(verticalScroll, null);
	                    fixedThumb.upSkinName	= "thumbUpSkin";
	                    fixedThumb.overSkinName	= "thumbOverSkin";
	                    fixedThumb.downSkinName	= "thumbDownSkin";
	                    fixedThumb.iconName		= "thumbIcon";
	                    fixedThumb.skinName		= "thumbSkin";
	                    
	                    verticalScroll.scrollThumb	= fixedThumb;
	                    verticalScroll.addChildAt(fixedThumb, verticalScroll.getChildIndex(verticalScroll.downArrow));
	                }
	            }
            }
        }
        
        
		/* Events */
		private function setupEventParams():void {
			_eventParams['name']	= name;
		}
		private function onComplete(e:FlexEvent):void {
			setupEventParams();
			var event:ObjectEvent	= new ObjectEvent(ObjectEvent.COMPLETE, _eventParams);
			this.dispatchEvent(event);
		}
		
		private function onUpdate(e:FlexEvent):void {
			//If scrollbar thumbs are fixed, make sure they are rendered
			onFixedHThumb();
			onFixedVThumb();
            
			setupEventParams();
			var event:ObjectEvent	= new ObjectEvent(ObjectEvent.UPDATE, _eventParams);
			this.dispatchEvent(event);
		}
	}
}