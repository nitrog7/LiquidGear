/*
VERSION: 0.9
DATE: 7/15/2008
ACTIONSCRIPT VERSION: 3.0 (Requires Flash Player 9)
DESCRIPTION: 
	Used for Event dispatching from the AS3 version of TweenMax (www.tweenmax.com)


CODED BY: Jack Doyle, jack@greensock.com
Copyright 2008, GreenSock (This work is subject to the terms at http://www.greensock.com/terms_of_use.html.)
*/

package lg.flash.events {
	import flash.events.Event;
	
	public class TweenEvent extends Event {
		public static const version:Number = 1.0;
		public static const START:String			= 'tween_start';
		public static const UPDATE:String			= 'tween_update';
		public static const COMPLETE:String			= 'tween_complete';
		public static const REPEAT:String			= 'tween_repeat';
		public static const REPEAT_COMPLETE:String	= 'tween_repeat_complete';
		public static const REVERSE:String			= 'tween_reverse';
		public static const REVERSE_COMPLETE:String	= 'tween_reverse_complete';
		
		public var params:Object;
		
		public function TweenEvent($type:String, $info:Object = null, $bubbles:Boolean = false, $cancelable:Boolean = false){
			super($type, $bubbles, $cancelable);
			this.params = $info;
		}
		
		public override function clone():Event{
			return new TweenEvent(this.type, this.params, this.bubbles, this.cancelable);
		}
	
	}
	
}