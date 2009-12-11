﻿/*
 * Copyright 2008 Adobe Systems Inc., 2008 Google Inc.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * 
 * Contributor(s):
 *   Zwetan Kjukov <zwetan@gmail.com>.
 */

package lg.flash.track.google.analytics {
    import lg.flash.track.google.analytics.utils.Version;
    
    public class API {
        /**
        * version of Google Analytics AS3 API
        * 
        * note:
        * each components share the same code base and so the same version
        */
        public static var version:Version = new Version();
        version.major=1
		version.minor=0
		version.build=1
        version.revision = "$Rev: 319 $ ".split( " " )[1];
    }
}