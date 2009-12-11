package lg.flex.events {
	import flash.events.MouseEvent;
	
	public class ObjectEvent extends MouseEvent {
		//Mouse Interaction
		public static var OVER:String			= 'object_over';
		public static var DOWN:String			= 'object_down';
		public static var UP:String				= 'object_up';
		public static var OUT:String			= 'object_out';
		public static var CLICK:String			= 'object_click';
		public static var GLOW:String			= 'object_glow';
		public static var SCROLL_LEFT:String	= 'object_scrollLeft';
		public static var SCROLL_RIGHT:String	= 'object_scrollRight';
		
		//Render
		public static var COMPLETE:String		= 'object_complete';
		public static var UPDATE:String			= 'object_update';
		public static var VALID:String			= 'object_valid';
		
		//Loading
		public static var PROGRESS:String		= 'object_progress';
		public static var LOADED:String			= 'object_loaded';
		
		//Audio Video
		public static var CUE:String			= 'object_cue';
		public static var FINISHED:String		= 'object_finished';
		public static var STOPPED:String		= 'object_stopped';
		
		public var params:Object = {};
		
		public function ObjectEvent(type:String, param:Object=null) {
			super(type);
			
			if(param != null)
				this.params = param;
		}
		
		public override function toString():String {
			return formatToString("ObjectEvent","type","bubbles","cancelable","eventPhase","params");
		}
	}
}