/**
 * TimeUtil Class by yossy:beinteractive.
 * Visit www.liquidgear.net for documentation and updates.
 *
 *
 * Copyright (c) 2009 BeInteractive! (www.be-interactive.org) and
 *                    Spark project  (www.libspark.org)
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

package lg.flash.motion.utils {
	/**
	 * Time Utility.
	 * 
	 * @author	yossy:beinteractive
	 */
	public class TimeUtil {
		private static var _defaultFrameRate:Number = 30;
		
		/** Set the default framerate. */
		public static function get defaultFrameRate():Number {
			return _defaultFrameRate;
		}
		
		/** @private */
		public static function set defaultFrameRate(value:Number):void {
			_defaultFrameRate = value;
		}
		
		/**
		 * Convert frames to time.
		 * 
		 * @param	frames		Number of frames to convert
		 * @param	frameRate	Frame rate used to convert
		 * @return	Time (seconds)
		 */
		public static function toTime(frames:Number, frameRate:Number = NaN):Number {
			var time:Number	= frames * (1.0 / (isNaN(frameRate) ? _defaultFrameRate : frameRate));
			time			= int(time * 1000) / 1000;
			return time;
		}
		
		/**
		 * Convert time into frames.
		 * 
		 * @param	time		Time to convert (seconds)
		 * @param	frameRate	Framerate
		 * @return	Frames
		 */
		public static function toFrames(time:Number, frameRate:Number = NaN):Number {
			var frames:Number	= time / (1.0 / (isNaN(frameRate) ? _defaultFrameRate : frameRate)); 
			return frames;
		}
	}
}