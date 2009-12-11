/**
 * SVNSocket class
 *
 * @author: Giraldo Rosales
 * Copyright (c) 2009 Nitrogen Design. All rights reserved.
 *
 */
 package lg.flex.svn {
	import flash.net.Socket;
	import flash.events.*;
	import flash.errors.*;

    public class SVNSocket extends Socket {
    	private var _response:String;
    	
    	public function SVNSocket(host:String=null, port:uint=0) {
     	   super();
     	   
     	   addEventListener(Event.CONNECT, connectHandler);
     	   addEventListener(Event.CLOSE, closeHandler);
     	   addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
     	   addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
     	   addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
     	   
     	   if(host && port)
     	       super.connect(host, port);
        }
        
		private function sendRequest():void {
			trace("sendRequest");
			_response	= '';
			writeln("svn --help");
			flush();
		}
		private function readResponse():void {
			var str:String = readUTFBytes(bytesAvailable);
			_response += str;
		}
        
        private function connectHandler(e:Event):void {
			trace("connectHandler: " + e);
			sendRequest();
		}
		
		private function closeHandler(e:Event):void {
			trace("closeHandler: " + e);
			trace(_response.toString());
		}
        
        private function writeln(str:String):void {
        	str += "\n";
        	
			try {
				writeUTFBytes(str);
			}
			catch(e:IOError) {
				trace(e);
			}
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void {
			trace("ioErrorHandler: " + e);
		}
		
		private function securityErrorHandler(e:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + e);
		}
		
		private function socketDataHandler(e:ProgressEvent):void {
			trace("socketDataHandler: " + e);
			readResponse();
		}
	}
}