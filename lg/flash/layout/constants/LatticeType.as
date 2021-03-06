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
	public class LatticeType
	{
		/**
		 * Sets layout of Lattice to that of a square/rectangular lattice (nodes are set orthogonally) 
		 * 
		 * @see lg.flash.layout.layouts.twodee.Lattice 
		 */		
		public static const SQUARE:String="squareLattice";
		
		/**
		 * Sets layout of Lattice to that of a triangular/rhombic lattice lattice (nodes are set alternatingly shifted one half spacing)
		 * 
		 * @see lg.flash.layout.layouts.twodee.Lattice 
		 */		
		public static const DIAGONAL:String="diagonalLattice";
	}
}