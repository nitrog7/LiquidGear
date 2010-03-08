/**
* YouTubeData Class by Giraldo Rosales.
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

package lg.flash.model.google {
	//Flash Classes
	import flash.net.URLRequest;
	
	//LG Classes
	import lg.flash.events.ModelEvent;
	import lg.flash.model.LGData;
	import lg.flash.model.xmlData;
	import lg.flash.model.google.yt.YouTubeEntry;
	import lg.flash.model.google.yt.YouTubePlaylist;
	import lg.flash.model.google.yt.YouTubeVideo;
	import lg.flash.utils.LGString;
	import lg.flash.utils.LGDate;
	
	public class YouTubeData extends LGData {
		public var list:Array		= [];
		public var playlists:YouTubePlaylist	= new YouTubePlaylist();
		public var videos:Object	= {};
		
		private var _ytData:xmlData		= new xmlData();
		private var _startData:int		= 1;
		private var _curData:int		= 0;
		private var _maxData:int		= 25;
		private var _plID:String		= '';
		private var _videos:Array		= [];
		
		private var atom:Namespace		= new Namespace("http://www.w3.org/2005/Atom");
		private var media:Namespace		= new Namespace("http://search.yahoo.com/mrss/");
		private var gd:Namespace		= new Namespace("http://schemas.google.com/g/2005");
		private var yt:Namespace		= new Namespace("http://gdata.youtube.com/schemas/2007");
		
		private var _dataURL:String		= 'http://gdata.youtube.com/feeds/api/users/';
		private var _vidURL:String		= 'http://gdata.youtube.com/feeds/api/videos/';
		private var _plURL:String		= 'http://gdata.youtube.com/feeds/api/playlists/';
		
		public function YouTubeData() {
		}
		
		public function getVideoByID(id:String):void {
			var vidURL:String	= _vidURL + id + '?v=2';
			
			_ytData.load({id:'video', url:vidURL});
			_ytData.loaded(onLoadVideoURL);
		}
		
		public function getVideos():Array {
			return _videos;
		}
		
		private function onLoadVideoURL(e:ModelEvent):void {
			//Clean
			var results:Object		= e.data as Object;
			var vidXML:XML			= results.data as XML;
			vidXML.setNamespace(atom);
			
			var video:YouTubeVideo	= createVideo(vidXML);
			videos[video.id]		= video as Object;
			
			var vidLen:int			= _videos.length;
			_videos[vidLen]			= videos[video.id];
			
			trigger('data_loaded', {id:video.id, video:video});
		}
		
		private function createVideo(xml:XML):YouTubeVideo {
			var video:YouTubeVideo	= new YouTubeVideo();
			
			video.id			= convertString(xml.atom::id);
			video.published		= convertDate(xml.atom::published);
			video.updated		= convertDate(xml.atom::updated);
			video.uploaded		= convertDate(xml.media::group.yt::uploaded);
			video.category		= getCategories(xml.atom::category);
			video.title			= convertString(xml.atom::title);
			video.link			= getLinks(xml.atom::link);
			video.author		= getAuthors(xml.atom::author);
			video.summary		= getSummary(xml.atom::summary);
			video.content		= getContent(xml.media::group.media::content);
			video.description	= convertString(xml.media::group.media::description);
			video.keywords		= convertList(xml.media::group.media::keywords);
			video.duration		= convertNumber(xml.media::group.yt::duration.@seconds);
			video.videoid		= convertString(xml.media::group.yt::videoid);
			video.player		= convertString(xml.media::group.media::player);
			video.credit		= getCredit(xml.media::group.media::credit);
			video.thumbnail		= getThumbnail(xml.media::group.media::thumbnail);
			video.statistics	= getStats(xml.yt::statistics);
			video.rating		= getRating(xml.gd::rating);
			
			return video;
		}
		
		private function convertString(xml:XMLList):String {
			var str:String	= LGString.trim(String(xml));
			return str;
		}
		
		private function convertDate(xml:XMLList):Date {
			var str:String	= LGString.trim(String(xml));
			var date:Date	= LGDate.iso8601ToDate(str);
			return date;
		}
		
		private function convertList(xml:XMLList):Array {
			var list:Array	= [];
			var str:String	= LGString.trim(String(xml));
			
			if(str.length > 0) {
				list			= str.split(',');
				var listLen:int	= list.length;
				
				for(var g:int=0; g<listLen; g++) {
					list[g]	= LGString.trim(list[g]);
				}
			}
			
			return list;
		}
		
		private function convertNumber(xml:XMLList):Number {
			var num:Number	= Number(String(xml));
			return num;
		}
		
		private function getCategories(xml:XMLList):Array {
			var results:Array	= [];
			var obj:Object;
			var len:int;
			
			for each (var x:XML in xml) {
				obj				= {};
				obj.term		= convertString(x.@term);
				obj.scheme		= convertString(x.@scheme);
				obj.label		= convertString(x.@label);
				
				len				= results.length;
				results[len]	= obj;
			}
			
			return results;
		}
		
		private function getLinks(xml:XMLList):Array {
			var results:Array	= [];
			var obj:Object;
			var len:int;
			
			for each (var x:XML in xml) {
				obj				= {};
				obj.rel			= convertString(x.@rel);
				obj.type		= convertString(x.@type);
				obj.hreflang	= convertString(x.@hreflang);
				obj.href		= convertString(x.@href);
				obj.title		= convertString(x.@title);
				obj.length		= convertString(x.@["length"]);
				
				len				= results.length;
				results[len]	= obj;
			}
			
			return results;
		}
		
		private function getAuthors(xml:XMLList):Array {
			var results:Array	= [];
			var obj:Object;
			var len:int;
			
			for each (var x:XML in xml) {
				obj				= {};
				obj.name		= convertString(x.atom::["name"]);
				obj.email		= convertString(x.atom::email);
				obj.uri			= convertString(x.atom::uri);
				
				len				= results.length;
				results[len]	= obj;
			}
			
			return results;
		}
		
		private function getContent(xml:XMLList):Array {
			var results:Array	= [];
			var obj:Object;
			var len:int;
			
			for each (var x:XML in xml) {
				obj				= {};
				obj.url			= convertString(x.@url);
				obj.type		= convertString(x.@type);
				obj.medium		= convertString(x.@medium);
				obj.isDefault	= (convertString(x.@isDefault) == 'true') ? true : false;
				obj.expression	= convertString(x.@expression);
				obj.duration	= convertNumber(x.@duration);
				obj.format		= convertNumber(x.@yt::format);
				
				len				= results.length;
				results[len]	= obj;
			}
			
			return results;
		}
		
		private function getSummary(xml:XMLList):Object {
			var results:Object	= {};
			
			if(convertString(xml) != '') {
				results.type	= convertString(xml.@type);
				
				if(results.type == 'xhtml') {
					//results.value	= convertString(xml.xhtml::div);
				} else {
					results.value	= convertString(xml);
				}
			}
			
			return results;
		}
		
		private function getThumbnail(xml:XMLList):Array {
			var results:Array	= [];
			var obj:Object;
			var len:int;
			
			for each(var x:XML in xml) {
				obj				= {};
				obj.url			= convertString(x.@url);
				obj.height		= convertNumber(x.@height);
				obj.width		= convertNumber(x.@width);
				obj.time		= convertString(x.@time);
				
				len				= results.length;
				results[len]	= obj;
			}
			
			return results;
		}
		
		private function getStats(xml:XMLList):Object {
			var results:Object	= {};
			
			if(convertString(xml) != '') {
				results.viewCount		= convertNumber(xml.@viewCount);
				results.videoWatchCount	= convertNumber(xml.@videoWatchCount);
				results.subscriberCount	= convertNumber(xml.@subscriberCount);
				results.lastWebAccess	= convertDate(xml.@lastWebAccess);
				results.favoriteCount	= convertNumber(xml.@favoriteCount);
			}
			
			return results;
		}
		
		private function getCredit(xml:XMLList):Array {
			var results:Array	= [];
			var obj:Object;
			var len:int;
			
			for each (var x:XML in xml) {
				obj			= {};
				obj.role	= convertString(xml.@role);
				obj.type	= convertString(xml.@yt::type);
				obj.value	= convertString(xml);
				
				len				= results.length;
				results[len]	= obj;
			}
			
			return results;
		}
		
		private function getRating(xml:XMLList):Object {
			var results:Object	= {};
			
			if(convertString(xml) != '') {
				results.min			= convertNumber(xml.@min);
				results.max			= convertNumber(xml.@max);
				results.numRaters	= convertNumber(xml.@numRaters);
				results.average		= convertNumber(xml.@average);
				results.value		= convertNumber(xml.@value);
			}
			
			return results;
		}
		
		private function getLocation(xml:XMLList):Array {
			var results:Array	= [0, 0];
			var location:String	= convertString(xml);
			
			if(location != '') {
				results	= location.split(' ');
			}
			
			return results;
		}
		
		public function loadUserPlaylist(userID:String):void {
			var playlistURL:String	= _dataURL + userID + '/playlists?v=2';
			
			_ytData.load({id:'playlist', url:playlistURL + '&alt=json'});
			_ytData.loaded(onLoadPlaylistURL);
		}
		
		public function loadPlaylist(plID:String, start:int=1):void {
			_plID	= plID;
			var playlistURL:String	= _plURL+_plID+'?v=2';
			
			_ytData.loaded(onLoadVideoList);
			_ytData.load({id:'playlist', url:playlistURL + '&alt=json&max-results=' + _maxData + '&start-index=' + start});
		}
		
		private function onLoadPlaylistURL(e:ModelEvent):void {
			//Clean
			_ytData.unbind('data_loaded', onLoadPlaylistURL);
			
			var playData:Object	= e.data.data.feed;
			var lists:Array		= playData.entry;
			var entry:YouTubeEntry;
			_ytData.loaded(onLoadVideoList);
			
			for(var g:int=0; g<lists.length; g++) {
				//entry	= createVideoEntry(lists[g]);
				//playlists.addEntry(entry);
			}
		}
		
		private function onLoadVideoList(e:ModelEvent):void {
			//Clean
			_ytData.unbind('data_loaded', onLoadVideoList);
			
			var vidData:Object	= e.data.data.feed;
			var lists:Array		= vidData.entry as Array;
			var playlistID:int	= e.data.id.split('_')[1];
			var video:YouTubeVideo;
			
			//TODO: fill in rest of playlist data
			if(playlists.entry.length == 0) {
				var entry:YouTubeEntry = new YouTubeEntry();
				_ytData.loaded(onLoadVideoList);
				
				if(vidData.author && vidData.author.length > 0) {
					entry.author	= vidData.author[0].name;
				}
				
				if(vidData['openSearch$totalResults'] && vidData['openSearch$totalResults']['$t']) {
					entry.total		= int(vidData['openSearch$totalResults']['$t']);
				}
				if(vidData.title) {
					entry.title		= vidData.title.$t;
				}
				
				if(vidData.summary) {
					entry.summary	= vidData.summary.$t;
				}
				
				if(vidData.content) {
					entry.url	= vidData.content.src;
					_ytData.load({id:'pl_'+g, url:entry.url+'&alt=json'});
				}
				
				playlists.addEntry(entry);
			}
			
			for(var g:int=0; g<lists.length; g++) {
				//video = createVideoEntry(lists[g]);
				
				if(video) {
					playlists.entry[playlistID].addVideo(video);
				}
			}
			
			if(lists && lists.length >= _maxData && entry && entry.total > _startData) {
				_startData	= _startData + lists.length;
				loadPlaylist(_plID, _startData);
			} else {
				var event:ModelEvent	= new ModelEvent('data_loaded');
				event.data				= {playlists:playlists};
				dispatchEvent(event);
			}
		}
		/*
		private function createVideoEntry(obj:Object):YouTubeVideo {
			var entry:YouTubeVideo	= new YouTubeVideo();
			var timeStr:String;
			var timeDate:Array;
			var dateArray:Array;
			var timeArray:Array;
			var y:Number;
			var m:Number;
			var d:Number;
			var h:Number;
			var n:Number;
			var s:Number;
			
			if(obj.yt$statistics) {
				entry.statistics	= obj.yt$statistics;
			}
				
			if(obj.updated && obj.updated.$t) {
				timeStr		= obj.updated.$t;
				timeDate	= timeStr.split('T');
				dateArray	= timeDate[0].split('-');
				timeArray	= timeDate[1].split(':');
				
				y	= dateArray[0];
				m	= Number(dateArray[1])-1;
				d	= dateArray[2];
				h	= timeArray[0];
				n	= timeArray[1];
				s	= timeArray[2].split('.')[0];
				entry.updated	= new Date(y, m, d, h, n, s);
			}
			
			if(obj.media$group) {
				if(obj.media$group.yt$duration && obj.media$group.yt$duration.seconds) {
					entry.duration	= obj.media$group.yt$duration.seconds;
				}
				
				if(obj.media$group.yt$videoid && obj.media$group.yt$videoid.$t) {
					entry.id		= obj.media$group.yt$videoid.$t;
					entry.url		= 'http://www.youtube.com/watch?v='+entry.id;
					entry.embedCode	= '<object width="425" height="344"><param name="movie" value="http://www.youtube.com/v/'+entry.id+'&hl=en&fs=1"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/'+entry.id+'&hl=en&fs=1" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="425" height="344"></embed></object>';
				}
				
				if(obj.media$group.yt$videoid && obj.media$group.yt$uploaded.$t) {
					timeStr		= obj.media$group.yt$uploaded.$t;
					timeDate	= timeStr.split('T');
					dateArray	= timeDate[0].split('-');
					timeArray	= timeDate[1].split(':');
					
					y	= dateArray[0];
					m	= Number(dateArray[1])-1;
					d	= dateArray[2];
					h	= timeArray[0];
					n	= timeArray[1];
					s	= timeArray[2].split('.')[0];
					entry.uploaded	= new Date(y, m, d, h, n, s);
				}
				
				if(obj.media$group.media$category && obj.media$group.media$category.length > 0) {
					entry.category	= obj.media$group.media$category;
				}
				
				if(obj.media$group.media$content && obj.media$group.media$content.length > 0) {
					entry.content	= obj.media$group.media$content;
				}
				
				if(obj.media$group.media$thumbnail && obj.media$group.media$thumbnail.length > 0) {
					entry.thumbnail	= obj.media$group.media$thumbnail;
				}
				
				if(obj.media$group.media$keywords && obj.media$group.media$keywords.$t) {
					var keys:String	= obj.media$group.media$keywords.$t.toLowerCase();
					entry.keywords	= keys.split(', ');
				}
				
				if(obj.media$group.media$description && obj.media$group.media$description.$t) {
					entry.description	= obj.media$group.media$description.$t;
				}
				
				if(obj.media$group.media$title && obj.media$group.media$title.$t) {
					entry.title	= obj.media$group.media$title.$t;
				}
			}
			
			return entry;
		}
		*/
		public function getPlaylistByName(listName:String):String {
			var lists:Array	= playlists.entry;
			for(var g:int=0; g<lists.length; g++) {
				if(lists[g].title.$t == listName) {
					return lists[g].content.src;
				}
			}
			
			return '';
		}
		
		private function onErrorXML(e:ModelEvent):void {
			trace('YouTube::onErrorXML');
		}
	}
}