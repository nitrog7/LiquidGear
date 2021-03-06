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
*/
package lg.flash.layout.utils
{
	import lg.flash.layout.layouts.ICoreLayout;
	import lg.flash.layout.layouts.twodee.ILayout2d;
	
	public class LayoutTransitioner
	{
		private static var _tweenFunction:Function;
		
		/**
		 * 
		 * @param value
		 * 
		 */		
		static public function set tweenFunction(value:Function):void { _tweenFunction=value; }
		
		/**
		 * 
		 * @param layout
		 * 
		 */		
		static public function syncNodesTo(layout:ICoreLayout):void
		{
			var i:int;
			
			
			if(_tweenFunction==null) 
			{
				if(layout is ILayout2d) for(i=0; i<layout.size; i++) if(layout.nodes[i].link.z) layout.nodes[i].link.z=0;
				layout.updateAndRender();
				return;
			}
			for(i=0; i<layout.size; i++) _tweenFunction(layout.nodes[i]);
		}
		
		

	}
}