/*
* Copyright (c) 2009, 2010 the original author or authors
*
* Permission is hereby granted to use, modify, and distribute this file
* in accordance with the terms of the license agreement accompanying it.
*/

package robothaxe.base;

import robothaxe.event.Event;
import robothaxe.util.Dictionary;
import robothaxe.core.IInjector;
import robothaxe.core.IViewMap;
import massive.display.Display;
import massive.ui.core.Component;
import massive.ui.core.Container;

/**
 * An abstract <code>IViewMap</code> implementation
 */
class ViewMap extends ViewMapBase, implements IViewMap {
	/**
	 * @private
	 */
	
	/**
	 * @private
	 */
	var mappedPackages:Array<Dynamic>;

	/**
	 * @private
	 */
	var mappedTypes:Dictionary<Dynamic, Dynamic>;

	/**
	 * @private
	 */
	var injectedViews:Dictionary<Dynamic, Dynamic>;

	//---------------------------------------------------------------------
	// Constructor
	//---------------------------------------------------------------------

	/**
	 * Creates a new <code>ViewMap</code> object
	 *
	 * @param contextView The root view node of the context. The map will listen for ADDED_TO_STAGE events on this node
	 * @param injector An <code>IInjector</code> to use for this context
	 */
	public function new(contextView:Container, injector:IInjector)
	{
		super(contextView, injector);

		// mappings - if you can do it with fewer dictionaries you get a prize
		this.mappedPackages = new Array<Dynamic>();
		this.mappedTypes = new Dictionary<Dynamic, Dynamic>();
		this.injectedViews = new Dictionary<Dynamic, Dynamic>();
	}

	//---------------------------------------------------------------------
	// API
	//---------------------------------------------------------------------

	/**
	 * @inheritDoc
	 */
	public function mapPackage(packageName:String):Void
	{
		if (!Lambda.has(mappedPackages, packageName))
		{
			mappedPackages.push(packageName);
			viewListenerCount++;

			if (viewListenerCount == 1)
			{
				addListeners();
			}
		}
	}

	/**
	 * @inheritDoc
	 */
	public function unmapPackage(packageName:String):Void
	{
		var index = Lambda.indexOf(mappedPackages, packageName);

		if (index > -1)
		{
			mappedPackages.splice(index, 1);
			viewListenerCount--;

			if (viewListenerCount == 0)
			{
				removeListeners();
			}
		}
	}

	/**
	 * @inheritDoc
	 */
	public function mapType(type:Class<Dynamic>):Void
	{
		if (mappedTypes.get(type) != null) return;

		mappedTypes.add(type, type);

		viewListenerCount++;
		if (viewListenerCount == 1)
		{
			addListeners();
		}
		
		// This was a bad idea - causes unexpected eager instantiation of object graph 
		if (contextView != null && Std.is(contextView, type))
		{
			injectInto(contextView);
		}
	}

	/**
	 * @inheritDoc
	 */
	public function unmapType(type:Class<Dynamic>):Void
	{
		var mapping:Class<Dynamic> = mappedTypes.get(type);
		mappedTypes.remove(type);
		
		if (mapping != null)
		{
			viewListenerCount--;

			if (viewListenerCount == 0)
			{
				removeListeners();
			}
		}
	}

	/**
	 * @inheritDoc
	 */
	public function hasType(type:Class<Dynamic>):Bool
	{
		return mappedTypes.get(type) != null;
	}

	/**
	 * @inheritDoc
	 */
	public function hasPackage(packageName:String):Bool
	{
		return Lambda.has(mappedPackages, packageName);
	}

	//---------------------------------------------------------------------
	// Internal
	//---------------------------------------------------------------------

	/**
	 * @private
	 */
	override function addListeners():Void
	{
		if (contextView != null && enabled)
		{
			contextView.dispatcher.add(onViewAdded, COMPONENT_ADDED);
		}
	}

	/**
	 * @private
	 */
	override function removeListeners():Void
	{
		if (contextView != null)
		{
			contextView.dispatcher.remove(onViewAdded);
		}
	}

	/**
	 * @private
	 */
	override function onViewAdded(message:Dynamic, target:Component):Void
	{
		if (injectedViews.get(target) != null)
		{
			return;
		}
		
		for (type in mappedTypes)
		{
			if (Std.is(target, type))
			{
				injectInto(target);
				return;
			}
		}

		var len:Int = mappedPackages.length;

		if (len > 0)
		{
			var className = Type.getClassName(Type.getClass(target));

			for (i in 0...len)
			{
				var packageName:String = mappedPackages[i];

				if (className.indexOf(packageName) == 0)
				{
					injectInto(target);
					return;
				}
			}
		}
	}

	function injectInto(target:Display):Void
	{
		injector.injectInto(target);
		injectedViews.add(target, true);
	}
}
