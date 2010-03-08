/**
* Shell Class by Giraldo Rosales.
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

package lg.flash.track {
	import lg.flash.elements.Element;
	import lg.flash.events.ElementEvent;
	import lg.flash.track.google.analytics.GATracker;

    /**
     * Dispatched after the factory has built the tracker object.
     * @eventType lg.flash.events.AnalyticsEvent.READY
     */
    [Event(name='element_init', type="lg.flash.events.ElementEvent")]
    
	public class Analytics extends Element {
		public var tracker:GATracker;
		
		public function Analytics(obj:Object) {
			
			data.visual	= false;
			
			//Set Attributes
			for(var s:String in obj) {
				if(s in this) {
					this[s] = obj[s];
				}
				data[s] = obj[s];
			}
			
			tracker = new GATracker(data.view, data.id, 'AS3', data.visual);
		}
	
		public function trackPage(pageName:String):void {
			tracker.trackPageview('/'+pageName);
		}
		
		public function trackEvent(eventName:String, eventType:String, eventLabel:String=null, eventValue:Number=NaN):void {
			tracker.trackEvent(eventName, eventType, eventLabel, eventValue);
		}
	}
}
