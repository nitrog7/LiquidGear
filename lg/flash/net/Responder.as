package lg.flash.net {
	import flash.net.Responder;

	public class Responder extends flash.net.Responder {
		private var _result:Function;
		private var _status:Function;
		private var _params:Object;
		
		public function Responder(result:Function, status:Function=null, params:Object=null) {
			_result	= result;
			_status	= status;
			_params	= params;
			
			super(onLoaded, onStatus);
		}
		
		private function onLoaded(result:Object):void {
			_result.apply(this, [result, _params]);
		}
		
		private function onStatus(status:Object):void {
			_status.apply(this, [status, _params]);
		}
	}
}