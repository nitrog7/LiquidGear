package lg.flash.data {
	//Flash Classes
	import flash.net.*;
	
	public class DataStore {
		private var _data:SharedObject;
		/**
		*	Create a SharedObject. Think of it as a cookie within the Flash Player instead of the browser.
		*	@param name Name of the new DataSource.
		**/
		public function DataStore(name:String='default') {
			_data	= SharedObject.getLocal(name);
		}
		
		/**
		*	Set the value of a key.
		*	@param key Name of the object to store.
		*	@param value Value of the object to store.
		**/
		public function store(key:String, value:*):void {
			_data.data[key]	= value;
			_data.flush();
		}
		
		/**
		*	Get the value of a key.
		*	@param key Name of the object to retrieve.
		**/
		public function value(key:String):* {
			return _data.data[key];
		}
		
		/** Clear the DataStore of all values **/
		public function clear():void {
			_data.clear();
		}
	}
}