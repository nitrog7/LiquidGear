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
package lg.flash.motion.core.tweens.groups
{
	import lg.flash.motion.core.ticker.ITicker;
	import lg.flash.motion.core.tweens.AbstractTween;
	import lg.flash.motion.core.tweens.IITween;
	import lg.flash.motion.core.tweens.IITweenGroup;
	import lg.flash.motion.tweens.ITween;
	
	/**
	 * 複数の ITween を順番に実行.
	 * 
	 * @author	yossy:beinteractive
	 */
	public class SerialTween extends AbstractTween implements IITweenGroup
	{
		public function SerialTween(targets:Array, ticker:ITicker, position:Number)
		{
			super(ticker, position);
			
			var l:uint = targets.length;
			
			_duration = 0;
			
			if (l > 0) {
				_a = targets[0] as IITween;
				_duration += _a.duration;
				if (l > 1) {
					_b = targets[1] as IITween;
					_duration += _b.duration;
					if (l > 2) {
						_c = targets[2] as IITween;
						_duration += _c.duration;
						if (l > 3) {
							_d = targets[3] as IITween;
							_duration += _d.duration;
							if (l > 4) {
								_targets = new Vector.<IITween>(l - 4, true);
								for (var i:uint = 4; i < l; ++i) {
									var t:IITween = targets[i] as IITween;
									_targets[i - 4] = t;
									_duration += t.duration;
								}
							}
						}
					}
				}
			}
		}
		
		private var _a:IITween;
		private var _b:IITween;
		private var _c:IITween;
		private var _d:IITween;
		private var _targets:Vector.<IITween>;
		private var _lastTime:Number = 0;
		
		
		/**
		 * @inheritDoc
		 */
		public function contains(tween:ITween):Boolean
		{
			if (tween == null) {
				return false;
			}
			if (_a == tween) {
				return true;
			}
			if (_b == tween) {
				return true;
			}
			if (_c == tween) {
				return true;
			}
			if (_d == tween) {
				return true;
			}
			if (_targets != null) {
				return _targets.indexOf(tween as IITween) != -1;
			}
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getTweenAt(index:int):ITween
		{
			if (index < 0) {
				return null;
			}
			if (index == 0) {
				return _a;
			}
			if (index == 1) {
				return _b;
			}
			if (index == 2) {
				return _c;
			}
			if (index == 3) {
				return _d;
			}
			if (_targets != null) {
				if (index - 4 < _targets.length) {
					return _targets[index - 4];
				}
			}
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getTweenIndex(tween:ITween):int
		{
			if (tween == null) {
				return -1;
			}
			if (_a == tween) {
				return 0;
			}
			if (_b == tween) {
				return 1;
			}
			if (_c == tween) {
				return 2;
			}
			if (_d == tween) {
				return 3;
			}
			if (_targets != null) {
				var i:int = _targets.indexOf(tween as IITween);
				if (i != -1) {
					return i + 4;
				}
			}
			return -1;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function internalUpdate(time:Number):void 
		{
			var d:Number = 0, ld:Number = 0, lt:Number = _lastTime, l:uint, i:int, t:IITween;
			
			if ((time - lt) >= 0) {
				if (_a != null) {
					if (lt <= (d += _a.duration) && ld <= time) {
						_a.update(time - ld);
					}
					ld = d;
					if (_b != null) {
						if (lt <= (d += _b.duration) && ld <= time) {
							_b.update(time - ld);
						}
						ld = d;
						if (_c != null) {
							if (lt <= (d += _c.duration) && ld <= time) {
								_c.update(time - ld);
							}
							ld = d;
							if (_d != null) {
								if (lt <= (d += _d.duration) && ld <= time) {
									_d.update(time - ld);
								}
								ld = d;
								if (_targets != null) {
									l = _targets.length;
									for (i = 0; i < l; ++i) {
										t = _targets[i];
										if (lt <= (d += t.duration) && ld <= time) {
											t.update(time - ld);
										}
										ld = d;
									}
								}
							}
						}
					}
				}
			}
			else {
				d = _duration;
				ld = d;
				if (_targets != null) {
					for (i = _targets.length - 1; i >= 0; --i) {
						t = _targets[i];
						if (lt >= (d -= t.duration) && ld >= time) {
							t.update(time - d);
						}
						ld = d;
					}
				}
				if (_d != null) {
					if (lt >= (d -= _d.duration) && ld >= time) {
						_d.update(time - d);
					}
					ld = d;
				}
				if (_c != null) {
					if (lt >= (d -= _c.duration) && ld >= time) {
						_c.update(time - d);
					}
					ld = d;
				}
				if (_b != null) {
					if (lt >= (d -= _b.duration) && ld >= time) {
						_b.update(time - d);
					}
					ld = d;
				}
				if (_a != null) {
					if (lt >= (d -= _a.duration) && ld >= time) {
						_a.update(time - d);
					}
					ld = d;
				}
			}
			_lastTime = time;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function newInstance():AbstractTween 
		{
			var targets:Array = [];
			if (_a != null) {
				targets.push(_a.clone());
			}
			if (_b != null) {
				targets.push(_b.clone());
			}
			if (_c != null) {
				targets.push(_c.clone());
			}
			if (_d != null) {
				targets.push(_d.clone());
			}
			if (_targets != null) {
				var t:Vector.<IITween> = _targets;
				var l:uint = t.length;
				for (var i:uint = 0; i < l; ++i) {
					targets.push(t[i].clone());
				}
			}
			return new SerialTween(targets, ticker, 0);
		}
	}
}