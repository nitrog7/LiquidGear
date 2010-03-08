/**
* YouTubeVideo Class by Giraldo Rosales.
* Visit www.liquidgear.net for documentation and updates.
*
*
* Copyright (c) 2010 Nitrogen Design, Inc. All rights reserved.
* 
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
* 
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
**/

package lg.flash.model.google.yt {
	import flash.system.Security;
	import flash.events.EventDispatcher;
	
	import lg.flash.events.ModelEvent;
	import lg.flash.model.xmlData;
	
	public class YouTubeVideo extends Object {
		public var id:String			= '';
		public var published:Date		= new Date();
		public var updated:Date			= new Date();
		public var uploaded:Date		= new Date();
		public var category:Array		= [];
		public var title:String			= '';
		public var link:Array			= [];
		public var author:Array			= [];
		public var summary:Object		= {};
		public var content:Array		= [];
		public var description:String	= '';
		public var keywords:Array		= [];
		public var duration:int			= 0;
		public var videoid:String		= '';
		public var thumbnail:Array		= [];
		public var credit:Array			= [];
		public var player:String		= '';
		public var statistics:Object	= {};
		public var rating:Object		= {};
		public var longitude:Number		= 0;
		public var latitude:Number		= 0;
		
		public function YouTubeVideo() {
		}
	}
}