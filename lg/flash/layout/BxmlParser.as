/**
* BxmlParser Class by Nick Farina and Philippe Elass.
* Visit www.liquidgear.net for documentation and updates.
*
*
* Copyright (c) 2008 Nick Farina and Philippe Elass. All rights reserved.
* 
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the 'Software'), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
* 
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
**/

package lg.flash.elements.layout {
	//Flash
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.describeType;
	
	//LG
	import lg.flash.layout.Attributes;
	import lg.flash.utils.Designer;
	
	
	public class BxmlParser {
		public static var standardImports:Array = ['flash.filters.*', 'flash.events.*', 'lg.flash.elements.*', 'lg.flash.elements.layout.*'];
		
		// cached as string for speed
		private static var EVENT_TYPE:String = getQualifiedClassName(Event);

		private var typeCache:TypeCache = new TypeCache();
		private var imports:Array;
		private var embeds:Object;
		private var insert:Object;
		private var insertIndex:Number;
		private var idElements:Dictionary;
		private var harness:DisplayObjectContainer;
		private var representedType:String; // if you're in the designer, this might be something like 'controls.MyClassDesign'
		
		public var ignoreErrors:Boolean;
		
		public function parseXML(xml:XML, representedType:String = null):* {
			this.representedType	= representedType;
			buildImports(xml);
			buildEmbeds(xml);
			insert					= null;
			insertIndex				= NaN;
			idElements				= new Dictionary();
			var o:*					= createObject(xml, null);
			
			if(insert) {
				o.addChildProxy			= insert;
				insert.addChildIndex	= insertIndex;
			}
			
			return o;
		}
		
		public function get designHarness():DisplayObjectContainer {
			return harness;
		}
		
		public function getElementById(id:String):* {
			return idElements[id];
		}
		
		private function createObject(xml:XML, parent:*, oClass:Class = null):* {
			// is it just text?
			if (xml.nodeKind() == 'text') return xml.toString();
			
			var nodeName:String = xml.name().toString();
			
			// is this the ID of an embedded asset?
			if (!oClass && embeds[nodeName])
				oClass = Class(getDefinitionByName(embeds[nodeName]));
			
			// figure out the class that the xml node represents, like 'Container' => 'lg.flash.elements.layout.Container'
			if (!oClass) oClass = resolveClass(nodeName);
			
			switch (oClass)
			{
				case Array: return createArray(xml.children(), parent);
				case String: case Number: case Boolean: case int: case uint: case Date:
					return new oClass(xml.toString()); // primitive type
				default: // complex object
					if (!oClass) throw new Error('Could not find the class ''' + nodeName + ''''); // has to exist to create one!
					var o:* = new oClass();
					populateObject(o, parent, xml); // set the object's properties and children
					return o;			
			}
		}
		
		// Given a list of XML nodes, returns either an Array (if multiple children) or a single object.
		private function createObjectFromChildren(xml:XML, parent:*=null):* {
			switch (xml.children().length())
			{
				case 0: return null;
				case 1: return createObject(xml.children()[0], parent);
				default: return createArray(xml.children(), parent);
			}
		}
		
		// Parses and returns a generic Array type from a list of XML nodes
		private function createArray(children:XMLList, parent:*):Array {
			var a:Array = new Array();
			for each (var child:XML in children)
				a.push(createObject(child, parent));
			return a;
		}

		// 'fill in' an object that already exists
		private function populateObject(o:*, parent:*, xml:XML):void {
			for each (var attribute:XML in xml.attributes()) // like 'width=100'
				handleObjectProperty(o, xml.name(), parent, attribute.name(), attribute);
			
			for each (var child:XML in xml.children())
				if (child.name() == 'DesignOnly') populateObject(o, parent, child);
				else if (child.name() == 'DesignHarness') { if (harness) handleError(Error,'<DesignHarness> was already specified.'); harness = createObjectFromChildren(child); }
				else if (child.name() == 'Insert') { if (insert) handleError(Error,'<Insert> was already placed.'); insert = o; insertIndex = o.numChildren; }
				else if (child.name() != 'Import' && child.name() != 'Embed') 
					handleObjectChild(o, xml.name(), parent, child);
		}
		
		// handle things like 'width', 'Box.flex', 'flex', and 'Event.COMPLETE'
		private function handleObjectProperty(o:*, oName:String, parent:*, name:String, value:XML):void {
			// ignore 'getter' and 'setter' which are compiler features
			if (name == 'getter' || name == 'setter') return;
			// remember elements with id= properties so you can retrieve them using getElementById().
			if (name == 'id') { idElements[value.toString()] = o; return; }
			// transform 'class' into 'className'
			if (name == 'class') name = 'className';

			var typeInfo:XML = typeCache.describe(o.constructor);
			
			// if you provided something like 'width' or 'flex' instead of 'Box.flex', we need to resolve it
			if (name.indexOf('.') == -1)
			{
				if (TypeHelper.getPropertyNode(typeInfo, name)) // is 'width' is a property of 'Container'
					{ setObjectProperty(o, name, value); return; }
				
				// maybe it's an attribute; search the parent to see if it or its superclass(es) provide it
				if (parent)
				{
					var parentInfo:XML = typeCache.describe(parent.constructor);
					var attributesProvider:Class = typeCache.findAttributeProvider(parentInfo, name);
					if (attributesProvider)
						{ setObjectAttribute(o, attributesProvider, name, value); return; }
				}
				
				var isDynamic:Boolean = describeType(o).attribute('isDynamic').toString() == 'true';

				if (isDynamic)
					{ setObjectProperty(o, name, value); return; }
				
				// try to provide a helpful message
				if (name.charAt(0).toUpperCase() == name.charAt(0))
					handleError(ReferenceError,'The class ''' + name + ''' was not found. Make sure it''s compiled into your SWF and that you have an Import tag (if necessary).');
				else
					handleError(ReferenceError,'''' + name + ''' is not a property of ' + typeInfo.attribute('name') + ' or an attribute supplied by the parent element.');
			}
			else // it's a dot-property: direct attribute or event
			{
				var split:Array = name.split('.');
				var className:String = split[0];
				var propName:String = split[1];

				// ok, resolve this other class whatever it is
				var propClass:Class = resolveClass(className);
				
				// does this class provide Attributes?
				if (propClass.attributes)
					{ setObjectAttribute(o, propClass, propName, value); return; }
				
				// is this class an Event?
				if (TypeHelper.typeIs(typeCache.describe(propClass), EVENT_TYPE))
					return; // nothing we can do in the parser right now for events
				
				handleError(ReferenceError,'''' + name + ''' is not recognized as an attribute or event.');
			}
		}
				
		private function handleObjectChild(o:*, oName:String, parent:*, child:XML):void {
			var nodeKind:String = child.nodeKind();
			if (nodeKind == 'text')
				{ addChild(o, trim(child.toString())); return; }
			
			if (nodeKind != 'element') return;

			var nodeName:String = child.name().toString();

			// attempt to treat this element like a classname of an object we want to addChild().
			if (nodeName.indexOf('.') == -1)
			{
				var nodeClass:Class = resolveClass(nodeName, true);
				if (nodeClass || embeds[nodeName])
					{ addChild(o, createObject(child, o, nodeClass)); return; }
			}
			
			// no luck? assume it's a property setting or event listener
			handleObjectProperty(o, oName, parent, nodeName, child);
		}

		// Set a property on an object from an XML value, performing type conversion if necessary
		private function setObjectProperty(o:*, name:String, value:XML):void {
			var typeInfo:XML = typeCache.describe(o.constructor);
			var propAccess:String = TypeHelper.getPropertyAccess(typeInfo, name);
			
			if (propAccess == 'readonly')
				{ manipulateObjectProperty(o, name, value); return; }
			
			var isDynamic:Boolean = describeType(o).attribute('isDynamic').toString() == 'true';
			var propType:Class = TypeHelper.getPropertyType(typeInfo, name);
			var propValue:*;
			
			if (!isDynamic && !propType)
				{ handleError(ReferenceError,'''' + name + ''' is not an accessible property or variable on ' + typeInfo.attribute('name') + '.'); return; }
			
			switch (value.nodeKind())
			{
				case 'attribute': propValue = value.toString(); break;
				case 'element': propValue = createObjectFromChildren(value, null); break;
				default: return; // maybe a comment or something
			}
			
			o[name] = TypeConverter.changeType(propValue, propType, this);
		}
		
		// manipulate a read-only property of an object by adding children or text to it, and/or 
		// setting the value's properties
		private function manipulateObjectProperty(o:*, name:String, value:XML):void {
			var target:* = o[name];
			
			if (!target)
				{ handleError(ReferenceError,'Attempted to access the ' + name + ' property of ' + getQualifiedClassName(o) + ' but it returned null!'); return; }
			
			switch (value.nodeKind())
			{
				case 'attribute': addChild(o[name], value.toString()); break;
				case 'element': populateObject(o[name], null, value); break;
			}
		}
		
		private function setObjectAttribute(o:*, attributeProvider:Class, name:String, value:XML):void {
			var atts:* = attributeProvider['attributes'](o);
			setObjectProperty(atts, name, value);
		}
		
		public function resolveClass(shortName:String, nullIfNotFound:Boolean = false):Class {
			if (shortName.indexOf('.') > -1)
				{ handleError(ArgumentError,'Cannot reference classes explicitly, you must use an <Import> tag instead.'); return null; }
			
			// ok try the standard imports
			for each (var imp:String in imports)
				try { return TypeHelper.resolveClassIn(shortName, imp); }
				catch (e:ReferenceError) { }

			// try top level classes
			try { return Class(getDefinitionByName(shortName)); }
			catch (e:ReferenceError) { }

			// try current package if any
			if (representedType != null && representedType.indexOf('.') > -1)
				try { return TypeHelper.resolveClassIn(shortName, representedType.substring(0, representedType.lastIndexOf('.')) + '.*'); }
				catch (e:ReferenceError) { }

			if (!nullIfNotFound)
				handleError(ReferenceError,'Could not locate the class ''' + shortName + '''. Try recompiling to make sure the class is in your SWF. Make sure you have an <Import> tag if necessary.');
			
			return null;
		}
		
		private function addChild(o:*, child:*):void {
			var typeInfo:XML = typeCache.describe(o.constructor);
			var addChildType:Class = TypeHelper.getAddChildType(typeInfo);
			o.addChild(TypeConverter.changeType(child, addChildType, this));
		}
		
		private function buildImports(xml:XML):void {
			imports = [];
			
			for each (var imp:String in standardImports) {
				imports.push(imp);
			}
			
			for each (var ns:XML in xml.Import.attribute('ns')) {
				imports.push(ns.toString());
			}
		}
		
		private function buildEmbeds(xml:XML):void {
			embeds = new Object();
			
			for each (var id:XML in xml.Embed.attribute('id'))
				embeds[id] = representedType + '_' + id;
		}
		
		private function trim(s:String):String {
			return s.replace(/^\s+|\s+$/g, '');
		}
		
		private function handleError(type:Class, message:String):void {
			if (!ignoreErrors)
				throw new type(message);
		}
	}
}
