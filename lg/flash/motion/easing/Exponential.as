/*
 * BetweenAS3
 * 
 * Licensed under the MIT License
 * 
 * Copyright (c) 2009 BeInteractive! (www.be-interactive.org) and
 *                    Spark project  (www.libspark.org)
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 */
package lg.flash.motion.easing
{
	import lg.flash.motion.core.easing.ExponentialEaseIn;
	import lg.flash.motion.core.easing.ExponentialEaseInOut;
	import lg.flash.motion.core.easing.ExponentialEaseOut;
	import lg.flash.motion.core.easing.ExponentialEaseOutIn;
	import lg.flash.motion.core.easing.IEasing;
	
	/**
	 * Exponential.
	 * 
	 * @author	yossy:beinteractive
	 */
	public class Exponential
	{
		public static const easeIn:IEasing = new ExponentialEaseIn();
		public static const easeOut:IEasing = new ExponentialEaseOut();
		public static const easeInOut:IEasing = new ExponentialEaseInOut();
		public static const easeOutIn:IEasing = new ExponentialEaseOutIn();
	}
}