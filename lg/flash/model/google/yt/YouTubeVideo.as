/**
* YouTubeVideo Class by Giraldo Rosales.
* Visit www.liquidgear.net for documentation and updates.
*
*
* Copyright (c) 2010 Nitrogen Labs, Inc. All rights reserved.
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
	import flash.events.EventDispatcher;
	import flash.system.Security;
	
	import lg.flash.events.ModelEvent;
	import lg.flash.model.xmlData;
	import lg.flash.utils.LGDate;
	import lg.flash.utils.LGString;
	
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
		public var content:Object		= {};
		public var description:String	= '';
		public var keywords:Array		= [];
		public var duration:int			= 0;
		public var videoid:String		= '';
		public var thumbnail:Array		= [];
		public var credit:Array			= [];
		public var player:String		= '';
		public var statistics:Object	= {};
		public var likes:Object			= {};
		public var rating:Object		= {};
		public var longitude:Number		= 0;
		public var latitude:Number		= 0;
		public var accessControl:Array	= [];
		
		public function YouTubeVideo(obj:Object=null) {
			if(obj) {
				setAttributes(obj);
			}
		}
		
		public function setAttributes(obj:Object):void {
			var g:int;
			var len:int;
			var list:Array;
			
			if(obj.published) {published				= convertDate(obj.published.$t);}
			if(obj.updated) {updated					= convertDate(obj.updated.$t);}
			if(obj.title) {title						= obj.title.$t;}
			if(obj.content) {content					= obj.content.$t;}
			if(obj.link) {link							= obj.link;}
			if(obj['yt$accessControl']) {accessControl	= obj['yt$accessControl'];}
			
			if(obj.category && obj.category.length > 0) {
				list	= obj.category as Array;
				len		= list.length;
				
				for(g=0; g<len; g++) {
					category.push(list[g].term);
				}
			}
			
			if(obj.author && obj.author.length > 0) {
				list	= obj.author as Array;
				len		= list.length;
				
				for(g=0; g<len; g++) {
					author.push(list[g].name.$t);
				}
			}
			
			if(obj['media$group']) {
				var media:Object	= obj['media$group'];
				
				if(media['media$description']) {
					description	= media['media$description'].$t;
				}
				if(media['media$keywords']) {
					keywords	= String(media['media$keywords'].$t).split(', ');
				}
				if(media['media$thumbnail']) {
					thumbnail	= media['media$thumbnail'];
				}
				if(media['yt$duration']) {
					duration	= media['yt$duration'].seconds;
				}
				if(media['yt$videoid']) {
					id			= media['yt$videoid'].$t;
				}
			}
			
			if(obj['gd$rating']) {
				rating		= obj['gd$rating'];
			}
			if(obj['yt$statistics']) {
				statistics	= obj['yt$statistics'];
			}
			if(obj['yt$rating']) {
				likes		= obj['yt$rating'];
			}
		}
		
		private function convertDate(str:String):Date {
			var str:String	= LGString.trim(str);
			var date:Date	= LGDate.iso8601ToDate(str);
			return date;
		}
	}
}