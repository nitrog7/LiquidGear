package lg.flash.layout {
	//Flash 
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	//LG
	import lg.flash.elements.Container;
	import lg.flash.layout.Attributes;
	import lg.flash.layout.AutoSize;
	import lg.flash.layout.Size;
	import lg.flash.layout.Thickness;
	import lg.flash.layout.BoxAttributes;
	
	/**
	 * A Box that stacks its children on top of each other, and allows them to all flex to the
	 * largest child.
	 */
	public class Box extends Container {
		private var _gap:Number		= 0;
		private var _vgap:Number	= 0;
		
		public static function attributes(child:DisplayObject):BoxAttributes {
			return Attributes.findOrCreate(child, BoxAttributes);
		}
		
		// even though Box does not use these properties, HBox and VBox do and we 
		// declare them here to save bytecode
		public function get gap():Number {
			return _gap;
		}
		
		public function set gap(value:Number):void {
			_gap = value;
			invalidateLayout();
		}
		
		public function get vgap():Number {
			return _vgap;
		}
		
		public function set vgap(value:Number):void {
			_vgap = value;
			invalidateLayout();
		}
		
		override protected function layoutChildren(rect:Rectangle, auto:AutoSize, size:Size):Size {
			// allow Container to make the first pass
			size = super.layoutChildren(rect, auto, size);
			
			if (auto.isNone) return size;
			
			// we'll need a second pass if we're set to autosize, so our children get a chance to stretch
			// to the total size
			var actualRect:Rectangle = rect.clone();
			actualRect.width = size.width;
			actualRect.height = size.height;
			
			for (var i:int = 0; i < numChildren; i++)
			{
				var child:DisplayObject = getChildAt(i);
				layoutChild(child, actualRect, new AutoSize(false, false));
			}
			
			return size;
		}
		
		protected override function layoutChild(child:DisplayObject, rect:Rectangle, auto:AutoSize):Size {
			var atts:BoxAttributes = Box.attributes(child);
			var cAtts:ContainerAttributes = Container.attributes(child);
			
			// if you're not flexing in a direction, that direction becomes autosized.
			// otherwise you'd never have any sort of ability to align elements.
			var childAuto:AutoSize = auto.clone();
			if (atts.align != 'fill') childAuto.width = true;
			if (atts.valign != 'fill') childAuto.height = true;
			
			var size:Size = super.layoutChild(child, rect, childAuto);
			
			// take care of align=right,center if we have space
			if (!auto.width) {
				if (atts.align == 'right')
					cAtts.layoutX = Math.round(rect.right - size.width + cAtts.margin.left);
				else if (atts.align == 'center')
					cAtts.layoutX = Math.round(rect.x + (rect.width - size.width) / 2 + cAtts.margin.left);
			}
			
			// take care of valign=bottom,middle if we have space
			if (!auto.height) {
				if (atts.valign == 'bottom')
					cAtts.layoutY = Math.round(rect.bottom - size.height + cAtts.margin.top);
				else if (atts.valign == 'middle')
					cAtts.layoutY = Math.round(rect.y + (rect.height - size.height) / 2 + cAtts.margin.top);
			}
			
			return size;
		}
	}
}
