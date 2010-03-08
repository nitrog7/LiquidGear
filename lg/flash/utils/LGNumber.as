/**
 * CASA Lib for ActionScript 3.0
 * Copyright (c) 2009, Aaron Clinger & Contributors of CASA Lib
 * All rights reserved.
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

package lg.flash.utils {
	import lg.flash.math.Percent;
	
	/**
		Provides utility functions for manipulating numbers.
		
		@author Aaron Clinger
		@author David Nelson
		@author Mike Creighton
		@version 02/14/09
	*/
	public class LGNumber {
		public static function random(min:Number, max:Number):Number {
			var n:Number = Math.floor(Math.random() * (max - min + 1)) + min;  
			return n;
		}
		/**
			Determines if the two values are equal, with the option to define the precision.
			
			@param val1: A value to compare.
			@param val2: A value to compare.
			@param precision: The maximum amount the two values can differ and still be considered equal.
			@return Returns <code>true</code> the values are equal; otherwise <code>false</code>.
			@example
				<code>
					trace(LGNumber.isEqual(3.042, 3, 0)); // Traces false
					trace(LGNumber.isEqual(3.042, 3, 0.5)); // Traces true
				</code>
		*/
		public static function isEqual(val1:Number, val2:Number, precision:Number = 0):Boolean {
			return Math.abs(val1 - val2) <= Math.abs(precision);
		}
		
		/**
			Evaluates <code>val1</code> and <code>val2</code> and returns the smaller value. Unlike <code>Math.min</code> this method will return the defined value if the other value is <code>null</code> or not a number.
			
			@param val1: A value to compare.
			@param val2: A value to compare.
			@return Returns the smallest value, or the value out of the two that is defined and valid.
			@example
				<code>
					trace(LGNumber.min(5, null)); // Traces 5
					trace(LGNumber.min(5, "CASA")); // Traces 5
					trace(LGNumber.min(5, 13)); // Traces 5
				</code>
		*/
		public static function min(val1:*, val2:*):Number {
			if (isNaN(val1) && isNaN(val2) || val1 == null && val2 == null)
				return NaN;
			
			if (val1 == null || val2 == null)
				return (val2 == null) ? val1 : val2;
			
			if (isNaN(val1) || isNaN(val2))
				return isNaN(val2) ? val1 : val2;
			
			return Math.min(val1, val2);
		}
		
		/**
			Evaluates <code>val1</code> and <code>val2</code> and returns the larger value. Unlike <code>Math.max</code> this method will return the defined value if the other value is <code>null</code> or not a number.
			
			@param val1: A value to compare.
			@param val2: A value to compare.
			@return Returns the largest value, or the value out of the two that is defined and valid.
			@example
				<code>
					trace(LGNumber.max(-5, null)); // Traces -5
					trace(LGNumber.max(-5, "CASA")); // Traces -5
					trace(LGNumber.max(-5, -13)); // Traces -5
				</code>
		*/
		public static function max(val1:*, val2:*):Number {
			if (isNaN(val1) && isNaN(val2) || val1 == null && val2 == null)
				return NaN;
			
			if (val1 == null || val2 == null)
				return (val2 == null) ? val1 : val2;
			
			if (isNaN(val1) || isNaN(val2))
				return (isNaN(val2)) ? val1 : val2;
			
			return Math.max(val1, val2);
		}
		
		/**
			Creates a random number within the defined range.
			
			@param min: The minimum value the random number can be.
			@param min: The maximum value the random number can be.
			@return Returns a random number within the range.
		*/
		public static function randomWithinRange(min:Number, max:Number):Number {
			return min + (Math.random() * (max - min));
		}
		
		/**
			Creates a random integer within the defined range.
			
			@param min: The minimum value the random integer can be.
			@param min: The maximum value the random integer can be.
			@return Returns a random integer within the range.
		*/
		public static function randomIntegerWithinRange(min:int, max:int):int {
			return Math.round(LGNumber.randomWithinRange(min, max));
		}
		
		/**
			Determines if the number is even.
			
			@param value: A number to determine if it is divisible by <code>2</code>.
			@return Returns <code>true</code> if the number is even; otherwise <code>false</code>.
			@example
				<code>
					trace(LGNumber.isEven(7)); // Traces false
					trace(LGNumber.isEven(12)); // Traces true
				</code>
		*/
		public static function isEven(value:Number):Boolean {
			return (value & 1) == 0;
		}
		
		/**
			Determines if the number is odd.
			
			@param value: A number to determine if it is not divisible by <code>2</code>.
			@return Returns <code>true</code> if the number is odd; otherwise <code>false</code>.
			@example
				<code>
					trace(LGNumber.isOdd(7)); // Traces true
					trace(LGNumber.isOdd(12)); // Traces false
				</code>
		*/
		public static function isOdd(value:Number):Boolean {
			return !LGNumber.isEven(value);
		}
		
		/**
			Determines if the number is an integer.
			
			@param value: A number to determine if it contains no decimal values.
			@return Returns <code>true</code> if the number is an integer; otherwise <code>false</code>.
			@example
				<code>
					trace(LGNumber.isInteger(13)); // Traces true
					trace(LGNumber.isInteger(1.2345)); // Traces false
				</code>
		*/
		public static function isInteger(value:Number):Boolean {
			return (value % 1) == 0;
		}
		
		/**
			Determines if the number is prime.
			
			@param value: A number to determine if it is only divisible by <code>1</code> and itself.
			@return Returns <code>true</code> if the number is prime; otherwise <code>false</code>.
			@example
				<code>
					trace(LGNumber.isPrime(13)); // Traces true
					trace(LGNumber.isPrime(4)); // Traces false
				</code>
		*/
		public static function isPrime(value:Number):Boolean {
			if (value == 1 || value == 2)
				return true;
			
			if (LGNumber.isEven(value))
				return false;
			
			var s:Number = Math.sqrt(value);
			for (var i:Number = 3; i <= s; i++)
				if (value % i == 0)
					return false;
			
			return true;
		}
		
		/**
			Rounds a number's decimal value to a specific place.
			
			@param value: The number to round.
			@param place: The decimal place to round.
			@return Returns the value rounded to the defined place. 
			@example
				<code>
					trace(LGNumber.roundToPlace(3.14159, 2)); // Traces 3.14
					trace(LGNumber.roundToPlace(3.14159, 3)); // Traces 3.142
				</code>
		*/
		public static function roundDecimalToPlace(value:Number, place:uint):Number {
			var p:Number = Math.pow(10, place);
			
			return Math.round(value * p) / p;
		}
		
		/**
			Determines if index is included within the collection length otherwise the index loops to the beginning or end of the range and continues.
			
			@param index: Index to loop if needed.
			@param length: The total elements in the collection.
			@return A valid zero-based index.
			@example
				<code>
					var colors:Array = new Array("Red", "Green", "Blue");
					
					trace(colors[LGNumber.loopIndex(2, colors.length)]); // Traces Blue
					trace(colors[LGNumber.loopIndex(4, colors.length)]); // Traces Green
					trace(colors[LGNumber.loopIndex(-6, colors.length)]); // Traces Red
				</code>
		*/
		public static function loopIndex(index:int, length:uint):uint {
			if (index < 0)
				index = length + index % length;
			
			if (index >= length)
				return index % length;
			
			return index;
		}
		
		/**
			Determines if the value is included within a range.
			
			@param value: Number to determine if it is included in the range.
			@param firstValue: First value of the range.
			@param secondValue: Second value of the range.
			@return Returns <code>true</code> if the number falls within the range; otherwise <code>false</code>.
			@usageNote The range values do not need to be in order.
			@example
				<code>
					trace(LGNumber.isBetween(3, 0, 5)); // Traces true
					trace(LGNumber.isBetween(7, 0, 5)); // Traces false
				</code>
		*/
		public static function isBetween(value:Number, firstValue:Number, secondValue:Number):Boolean {
			return !(value < Math.min(firstValue, secondValue) || value > Math.max(firstValue, secondValue));
		}
		
		/**
			Determines if value falls within a range; if not it is snapped to the nearest range value.
			
			@param value: Number to determine if it is included in the range.
			@param firstValue: First value of the range.
			@param secondValue: Second value of the range.
			@return Returns either the number as passed, or its value once snapped to nearest range value.
			@usageNote The constraint values do not need to be in order.
			@example
				<code>
					trace(LGNumber.constrain(3, 0, 5)); // Traces 3
					trace(LGNumber.constrain(7, 0, 5)); // Traces 5
				</code>
		*/
		public static function constrain(value:Number, firstValue:Number, secondValue:Number):Number {
			return Math.min(Math.max(value, Math.min(firstValue, secondValue)), Math.max(firstValue, secondValue));
		}
		
		/**
			Creates evenly spaced numerical increments between two numbers.
			
			@param begin: The starting value.
			@param end: The ending value.
			@param steps: The number of increments between the starting and ending values.
			@return Returns an Array composed of the increments between the two values.
			@example
				<code>
					trace(LGNumber.createStepsBetween(0, 5, 4)); // Traces 1,2,3,4
					trace(LGNumber.createStepsBetween(1, 3, 3)); // Traces 1.5,2,2.5
				</code>
		*/
		public static function createStepsBetween(begin:Number, end:Number, steps:Number):Array {
			steps++;
			
			var i:uint = 0;
			var stepsBetween:Array = new Array();
			var increment:Number = (end - begin) / steps;
			
			while (++i < steps)
				stepsBetween.push((i * increment) + begin);
			
			return stepsBetween;
		}
		
		/**
			Determines a value between two specified values.
			
			@param amount: The level of interpolation between the two values. If <code>0%</code>, <code>begin</code> value is returned; if <code>100%</code>, <code>end</code> value is returned.
			@param minimum: The lower value.
			@param maximum: The upper value.
			@example
				<code>
					trace(LGNumber.interpolate(new Percent(0.5), 0, 10)); // Traces 5
				</code>
		*/
		public static function interpolate(amount:Percent, minimum:Number, maximum:Number):Number {
			return minimum + (maximum - minimum) * amount.decimalPercentage;
		}
		
		/**
			Determines a percentage of a value in a given range.
			
			@param value: The value to be converted.
			@param minimum: The lower value of the range.
			@param maximum: The upper value of the range.
			@example
				<code>
					trace(LGNumber.normalize(8, 4, 20).decimalPercentage); // Traces 0.25
				</code>
		*/
		public static function normalize(value:Number, minimum:Number, maximum:Number):Percent {
			return new Percent((value - minimum) / (maximum - minimum));
		}
		
		/**
			Maps a value from one coordinate space to another.
			
			@param value: Value from the input coordinate space to map to the output coordinate space.
			@param min1: Starting value of the input coordinate space.
			@param max1: Ending value of the input coordinate space.
			@param min2: Starting value of the output coordinate space.
			@param max2: Ending value of the output coordinate space.
			@example
				<code>
					trace(LGNumber.map(0.75, 0, 1, 0, 100)); // Traces 75
				</code>
		*/
		public static function map(value:Number, min1:Number, max1:Number, min2:Number, max2:Number):Number {
			return min2 + (max2 - min2) * ((value - min1) / (max1 - min1));
		}
		
		/**
			Low pass filter alogrithm for easing a value toward a destination value. Works best for tweening values when no definite time duration exists and when the destination value changes.
			
			If <code>(0.5 < n < 1)</code>, then the resulting values will overshoot (ping-pong) until they reach the destination value. When <code>n</code> is greater than 1, as its value increases, the time it takes to reach the destination also increases. A pleasing value for <code>n</code> is 5.
			
			@param value: The current value.
			@param dest: The destination value.
			@param n: The slowdown factor.
			@return The weighted average.
		*/
		public static function getWeightedAverage(value:Number, dest:Number, n:Number):Number {
			return value + (dest - value) / n;
		}
		
		/**
			Formats a number.
			
			@param value: The number you wish to format.
			@param minLength: The minimum length of the number.
			@param thouDelim: The character used to seperate thousands.
			@param fillChar: The leading character used to make the number the minimum length.
			@return Returns the formated number as a String.
			@example
				<code>
					trace(LGNumber.format(1234567, 8, ",")); // Traces 01,234,567
				</code>
		*/
		public static function format(value:Number, minLength:uint, thouDelim:String = null, fillChar:String = null):String {
			var num:String = value.toString();
			var len:uint   = num.length;
			
			if (thouDelim != null) {
				var numSplit:Array = num.split('');
				var counter:uint = 3;
				var i:uint       = numSplit.length;
				
				while (--i > 0) {
					counter--;
					if (counter == 0) {
						counter = 3;
						numSplit.splice(i, 0, thouDelim);
					}
				}
				
				num = numSplit.join('');
			}
			
			if (minLength != 0) {
				if (len < minLength) {
					minLength -= len;
					
					var addChar:String = (fillChar == null) ? '0' : fillChar;
					
					while (minLength--)
						num = addChar + num;
				}
			}
			
			return num;
		}
		
		/**
			Finds the English ordinal suffix for the number given.
			
			@param value: Number to find the ordinal suffix of.
			@return Returns the suffix for the number, 2 characters.
			@example
				<code>
					trace(32 + LGNumber.getOrdinalSuffix(32)); // Traces 32nd
				</code>
		*/
		public static function getOrdinalSuffix(value:int):String {
			if (value >= 10 && value <= 20)
				return 'th';
			
			switch (value % 10) {
				case 0 :
				case 4 :
				case 5 :
				case 6 :
				case 7 :
				case 8 :
				case 9 :
					return 'th';
				case 3 :
					return 'rd';
				case 2 :
					return 'nd';
				case 1 :
					return 'st';
				default :
					return '';
			}
		}
		
		/**
			Adds a leading zero for numbers less than ten.
			
			@param value: Number to add leading zero.
			@return Number as a String; if the number was less than ten the number will have a leading zero.
			@example
				<code>
					trace(LGNumber.addLeadingZero(7)); // Traces 07
					trace(LGNumber.addLeadingZero(11)); // Traces 11
				</code>
		*/
		public static function leadingZero(value:Number):String {
			return (value < 10) ? '0' + value : value.toString();
		}
	}
}