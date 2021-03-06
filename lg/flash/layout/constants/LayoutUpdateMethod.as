 /*
The MIT License

Copyright (c) 2009 P.J. Onori (pj@somerandomdude.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
  /**
 *
 *
 * @author      P.J. Onori
 * @version     0.1
 * @description
 * @url 
 */
 package lg.flash.layout.constants
{
	public class LayoutUpdateMethod
	{
		/**
		 * No update or render occurs when layout properties are changed. The layout's <em>updateAndRender()</em>
		 * must be called for updating/rendering to occur.
		 */		
		public static const NONE:String="none";
		
		/**
		 * The layout's <em>update()</em> method is called when layout properties are changed - which only updates 
		 * each node's virtual coordinates, but not the actual DisplayObjects' coordinates.
		 */		
		public static const UPDATE_ONLY:String="updateOnly";
		
		/**
		 * The layout is updated and rendered whenever a property is changed
		 */		
		public static const UPDATE_AND_RENDER:String="updateAndRender";

	}
}