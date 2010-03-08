/**
 * IObjectTween Class by yossy:beinteractive.
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

package lg.flash.motion.tweens {
	//Target value for each property setter. The main role in providing treatment and special properties.
	//But just because each property has a responsibility, it does not need all the properties, do I only want special treatment.
	//For example, if DisplayObject those with major x, y, rotation only good enough for the processing and properties.
	//For other properties, generic properties that can handle all ObjectTweenTarget responsibly so that the process is
	//There is no need to worry.
	
	/**
	 * Targets one Object.
	 * 
	 * @author	yossy:beinteractive
	 */
	public interface IObjectTween extends ITween {
		/** Object to tween. */
		function get target():Object;
	}
}