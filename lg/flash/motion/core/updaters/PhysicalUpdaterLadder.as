﻿/*
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
package lg.flash.motion.core.updaters
{
	import lg.flash.motion.core.easing.IPhysicalEasing;
	/**
	 * .
	 * 
	 * @author	yossy:beinteractive
	 */
	public class PhysicalUpdaterLadder implements IPhysicalUpdater
	{
		public function PhysicalUpdaterLadder(parent:IPhysicalUpdater, child:IPhysicalUpdater, propertyName:String)
		{
			_parent = parent;
			_child = child;
			_propertyName = propertyName;
			_duration = child.duration;
		}
		
		private var _parent:IPhysicalUpdater;
		private var _child:IPhysicalUpdater;
		private var _propertyName:String;
		private var _duration:Number = 0.0;
		
		/**
		 * .
		 */
		public function get parent():IPhysicalUpdater
		{
			return _parent;
		}
		
		/**
		 * .
		 */
		public function get child():IPhysicalUpdater
		{
			return _child;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get target():Object
		{
			return null;
		}
		
		/**
		 * @private
		 */
		public function set target(value:Object):void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function get easing():IPhysicalEasing
		{
			return null;
		}
		
		/**
		 * @private
		 */
		public function set easing(value:IPhysicalEasing):void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function get duration():Number
		{
			return _duration;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setSourceValue(propertyName:String, value:Number, isRelative:Boolean = false):void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function setDestinationValue(propertyName:String, value:Number, isRelative:Boolean = false):void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function getObject(propertyName:String):Object
		{
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setObject(propertyName:String, value:Object):void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function resolveValues():void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function update(factor:Number):void
		{
			_child.update(factor);
			_parent.setObject(_propertyName, _child.target);
		}
		
		/**
		 * @inheritDoc
		 */
		public function clone():IUpdater
		{
			return new PhysicalUpdaterLadder(_parent, _child, _propertyName);
		}
	}
}