package lg.flex.components.scroll {
	import flash.display.*;
    import flash.events.*;
    
    import mx.controls.scrollClasses.ScrollThumb;
    import mx.core.mx_internal;
    import mx.events.ResizeEvent;
    
    use namespace mx_internal;
	
    [Style(name="thumbWidth", type="Number")]
    [Style(name="thumbHeight", type="Number")]
    [Style(name="hitAreaPadding", type="Number")]
    
	public class FixedSizeThumb extends ScrollThumb {
        private var isActualSizeSet:Boolean = false;
        
		public function FixedSizeThumb() {
            super();
            buttonMode = true;
        }
        
        public override function setActualSize(w:Number, h:Number):void {
            var oldWidth:Number=width, oldHeight:Number=height, thumbWidth:Number=getStyle("thumbWidth"), thumbHeight:Number=getStyle("thumbHeight"), resizeEvent:ResizeEvent;
            
            if (!isActualSizeSet && !isNaN(thumbWidth) && !isNaN(thumbHeight)) {
                isActualSizeSet = true;
                
                _width = thumbWidth;
                _height = thumbHeight;
                
                dispatchEvent(new Event("widthChanged"));
                dispatchEvent(new Event("heightChanged"));
    
                invalidateDisplayList();
                resizeEvent				= new ResizeEvent(ResizeEvent.RESIZE);
				resizeEvent.oldWidth	= thumbHeight;
				resizeEvent.oldHeight	= oldHeight;
				dispatchEvent(resizeEvent);
            }
            
            setHitAreaSize(thumbWidth, thumbHeight);
        }
        
        private function setHitAreaSize(w:Number, h:Number):void  {
            var hitAreaPadding:Number = Number(getStyle("hitAreaPadding")), sprite:Sprite=new Sprite();
            
            sprite.graphics.beginFill(0xFF0000, 0.2);
            sprite.graphics.drawRect(-hitAreaPadding, -hitAreaPadding, 2*hitAreaPadding + w, 2*hitAreaPadding + h);
            sprite.graphics.endFill();
            sprite.mouseEnabled = false;
            sprite.visible = false;
            addChild(sprite);
            hitArea = sprite;
        }
    }
}