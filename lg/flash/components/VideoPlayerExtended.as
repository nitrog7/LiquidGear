/**
* VideoPlayerExtended by Jonathan Marston.
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

package lg.flash.components {
	import fl.video.*;

    import flash.events.NetStatusEvent;
    import flash.net.NetStream;

    use namespace flvplayback_internal;

    /**
     * Extended version of fl.video.VideoPlayer class.
     *
     * @see http://marstonstudio.com/?p=45
     *
     * @author Jonathan Marston
     * @version 2007.12.26
     *
     * This work is licensed under a Creative Commons Attribution NonCommercial ShareAlike 3.0 License.
     * @see http://creativecommons.org/licenses/by-nc-sa/3.0/
     *
     */

    public class VideoPlayerExtended extends VideoPlayer {
        /**
         * Override the default means of creating a netstream object
         * Add checkPolicyFile=true to force loading of a crossdomain.xml file
         * @private
         */
        flvplayback_internal override function _createStream():void {
            _ns = null;
            var theNS:NetStream = new NetStream(_ncMgr.netConnection);
            if (_ncMgr.isRTMP) {
                theNS.addEventListener(NetStatusEvent.NET_STATUS, rtmpNetStatus);
            } else {
                theNS.addEventListener(NetStatusEvent.NET_STATUS, httpNetStatus);
            }
            theNS.client = new VideoPlayerClient(this);
            theNS.bufferTime = _bufferTime;
            theNS.soundTransform = soundTransform;
            theNS.checkPolicyFile = true;
            _ns = theNS;
            attachNetStream(_ns);
        }
    }
}