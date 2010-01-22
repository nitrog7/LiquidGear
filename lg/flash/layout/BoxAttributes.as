package lg.flash.layout {
	//Flash
	import flash.display.DisplayObject;
	
	//LG
	import lg.flash.layout.Attributes;
	
	/**
	 * HBox/VBox/ZBox attributes
	 */
	public class BoxAttributes extends Attributes {
		private var _align:String;
		private var _valign:String;
		private var _flex:Number;
		
		public function BoxAttributes() {
			_flex	= 0;
			_align	= 'fill';
			_valign	= 'fill';
		}
		
		public function get align():String {
			return _align;
		}
		
		public function set align(value:String):void {
			_align = value; invalidateContainer();
		}
		
		public function get valign():String {
			return _valign;
		}
		
		public function set valign(value:String):void {
			_valign = value; invalidateContainer();
		}
		
		public function get flex():Number {
			return _flex;
		}		
		
		public function set flex(value:Number):void {
			_flex = value; invalidateContainer();
		}
	}
}
