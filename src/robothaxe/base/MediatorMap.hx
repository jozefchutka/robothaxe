/*
* Copyright (c) 2009, 2010 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package robothaxe.base;

import robothaxe.event.Event;
import robothaxe.core.IInjector;
import robothaxe.core.IMediator;
import robothaxe.core.IMediatorMap;
import robothaxe.core.IReflector;
import robothaxe.util.Dictionary;
import massive.ui.core.Container;
import massive.ui.core.Component;

/**
 * An abstract <code>IMediatorMap</code> implementation
 */
class MediatorMap extends ViewMapBase, implements IMediatorMap
{
	/**
	 * @private
	 */
	var mediatorByView:Dictionary<Dynamic, IMediator>;
	
	/**
	 * @private
	 */
	var mappingConfigByView:Dictionary<Dynamic, MappingConfig>;
	
	/**
	 * @private
	 */
	var mappingConfigByViewClassName:Dictionary<Dynamic, MappingConfig>;
	
	/**
	 * @private
	 */
	var mediatorsMarkedForRemoval:Dictionary<Dynamic, Dynamic>;
	
	/**
	 * @private
	 */
	var hasMediatorsMarkedForRemoval:Bool;
	
	/**
	 * @private
	 */
	var reflector:IReflector;
	
	
	//---------------------------------------------------------------------
	//  Constructor
	//---------------------------------------------------------------------
	
	/**
	 * Creates a new <code>MediatorMap</code> object
	 *
	 * @param contextView The root view node of the context. The map will listen for ADDED_TO_STAGE events on this node
	 * @param injector An <code>IInjector</code> to use for this context
	 * @param reflector An <code>IReflector</code> to use for this context
	 */
	public function new(contextView:Container, injector:IInjector, reflector:IReflector)
	{
		super(contextView, injector);
		
		this.reflector = reflector;
		
		// mappings - if you can do it with fewer dictionaries you get a prize
		this.mediatorByView = new Dictionary();
		this.mappingConfigByView = new Dictionary();
		this.mappingConfigByViewClassName = new Dictionary();
		this.mediatorsMarkedForRemoval = new Dictionary();
	}
	
	//---------------------------------------------------------------------
	//  API
	//---------------------------------------------------------------------
	
	/**
	 * @inheritDoc
	 */
	public function mapView(viewClassOrName:Dynamic, mediatorClass:Class<Dynamic>, ?injectViewAs:Dynamic = null, ?autoCreate:Bool = true, ?autoRemove:Bool = true):Void
	{
		var viewClassName:String = reflector.getFQCN(viewClassOrName);
		
		if (mappingConfigByViewClassName.get(viewClassName) != null)
		{
			throw new ContextError(ContextError.E_MEDIATORMAP_OVR + ' - ' + mediatorClass);
		}
		
		if (reflector.classExtendsOrImplements(mediatorClass, IMediator) == false)
		{
			throw new ContextError(ContextError.E_MEDIATORMAP_NOIMPL + ' - ' + mediatorClass);
		}
		
		var config = new MappingConfig();
		config.mediatorClass = mediatorClass;
		config.autoCreate = autoCreate;
		config.autoRemove = autoRemove;

		if (injectViewAs)
		{
			if (Std.is(injectViewAs, Array))
			{
				config.typedViewClasses = cast(injectViewAs, Array<Dynamic>).copy();
			}
			else if (Std.is(injectViewAs, Class))
			{
				config.typedViewClasses = [injectViewAs];
			}
		}
		else if (Std.is(viewClassOrName, Class))
		{
			config.typedViewClasses = [viewClassOrName];
		}
		mappingConfigByViewClassName.add(viewClassName, config);
		
		if (autoCreate || autoRemove)
		{
			viewListenerCount++;

			if (viewListenerCount == 1)
			{
				addListeners();
			}	
		}
		
		// This was a bad idea - causes unexpected eager instantiation of object graph 
		if (autoCreate && contextView != null && viewClassName == Type.getClassName(Type.getClass(contextView)))
		{
			createMediatorUsing(contextView, viewClassName, config);
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public function unmapView(viewClassOrName:Dynamic):Void
	{
		var viewClassName = reflector.getFQCN(viewClassOrName);
		var config = mappingConfigByViewClassName.get(viewClassName);

		if (config != null && (config.autoCreate || config.autoRemove))
		{
			viewListenerCount--;

			if (viewListenerCount == 0)
			{
				removeListeners();
			}
		}

		mappingConfigByViewClassName.remove(viewClassName);
	}
	
	/**
	 * @inheritDoc
	 */
	public function createMediator(viewComponent:Dynamic):IMediator
	{
		return createMediatorUsing(viewComponent);
	}
	
	/**
	 * @inheritDoc
	 */
	public function registerMediator(viewComponent:Dynamic, mediator:IMediator):Void
	{
		injector.mapValue(reflector.getClass(mediator), mediator);
		mediatorByView.add(viewComponent, mediator);
		var mapping = mappingConfigByViewClassName.get(Type.getClassName(Type.getClass(viewComponent)));
		mappingConfigByView.add(viewComponent, mapping);
		mediator.setViewComponent(viewComponent);
		mediator.preRegister();
	}
	
	/**
	 * @inheritDoc
	 */
	public function removeMediator(mediator:IMediator):IMediator
	{
		if (mediator != null)
		{
			var viewComponent:Dynamic = mediator.getViewComponent();
			Reflect.deleteField(mediatorByView, viewComponent);
			Reflect.deleteField(mappingConfigByView, viewComponent);
			mediator.preRemove();
			mediator.setViewComponent(null);
			injector.unmap(reflector.getClass(mediator));
		}
		return mediator;
	}
	
	/**
	 * @inheritDoc
	 */
	public function removeMediatorByView(viewComponent:Dynamic):IMediator
	{
		return removeMediator(retrieveMediator(viewComponent));
	}
	
	/**
	 * @inheritDoc
	 */
	public function retrieveMediator(viewComponent:Dynamic):IMediator
	{
		return mediatorByView.get(viewComponent);
	}
	
	/**
	 * @inheritDoc
	 */
	public function hasMapping(viewClassOrName:Dynamic):Bool
	{
		var viewClassName:String = reflector.getFQCN(viewClassOrName);
		return mappingConfigByViewClassName.get(viewClassName) != null;
	}
	
	/**
	 * @inheritDoc
	 */
	public function hasMediatorForView(viewComponent:Dynamic):Bool
	{
		return mediatorByView.get(viewComponent) != null;
	}
	
	/**
	 * @inheritDoc
	 */
	public function hasMediator(mediator:IMediator):Bool
	{
		for (med in mediatorByView)
		{
			if (med == mediator)
			{
				return true;
			}
		}
			
		return false;
	}
	
	//---------------------------------------------------------------------
	//  Internal
	//---------------------------------------------------------------------
	
	/**
	 * @private
	 */		
	override function addListeners():Void
	{
		if (contextView != null && enabled)
		{
			contextView.dispatcher.add(onViewAdded, COMPONENT_ADDED);
			//contextView.dispatcher.add(COMPONENT_REMOVED, onViewRemoved);
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
			//contextView.dispatcher.remove(COMPONENT_REMOVED, onViewRemoved);
		}
	}
	
	/**
	 * @private
	 */		
	override function onViewAdded(message:Dynamic, target:Component):Void
	{
		if (mediatorsMarkedForRemoval.get(target) != null)
		{
			mediatorsMarkedForRemoval.remove(target);
			return;
		}
		
		var viewClassName:String = Type.getClassName(Type.getClass(target));
		var config = mappingConfigByViewClassName.get(viewClassName);
		
		if (config != null && config.autoCreate)
		{
			createMediatorUsing(target, viewClassName, config);
		}
	}
	
	/**
	 * @private
	 */		
	function createMediatorUsing(viewComponent:Dynamic, ?viewClassName:String="", ?config:MappingConfig=null):IMediator
	{
		var mediator = mediatorByView.get(viewComponent);

		if (mediator == null)
		{
			if (viewClassName == null)
			{
				viewClassName = Type.getClassName(Type.getClass(viewComponent));
			}

			if (config == null)
			{
				config = mappingConfigByViewClassName.get(viewClassName);
			}

			if (config != null)
			{
				for (claxx in config.typedViewClasses) 
				{
					injector.mapValue(claxx, viewComponent);
				}

				mediator = injector.instantiate(config.mediatorClass);

				for (clazz in config.typedViewClasses) 
				{
					injector.unmap(clazz);
				}

				registerMediator(viewComponent, mediator);
			}
		}

		return mediator;			
	}
}

class MappingConfig
{
	public function new(){}

	public var mediatorClass:Class<Dynamic>;
	public var typedViewClasses:Array<Dynamic>;
	public var autoCreate:Bool;
	public var autoRemove:Bool;
}