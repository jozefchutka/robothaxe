/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/
package robothaxe.mvcs.support;

import massive.ui.core.Container;
import robothaxe.core.IInjector;
import robothaxe.mvcs.Context;

class TestContext extends Context
{
	public var isInitialized(getIsInitialized, null):Bool;
	public var startupComplete:Bool ;
	
	public function new(?contextView:Container=null, ?autoStartup:Bool=true)
	{
		startupComplete = false;
		super(contextView, autoStartup);
	}
	
	public override function startup():Void
	{
		startupComplete = true;
		super.startup();
	}
	
	public function getInjector():IInjector
	{
		return this.injector;
	}
	
	public function getIsInitialized():Bool
	{
		var initialized:Bool = true;
		initialized = (commandMap != null && initialized);
		initialized = (mediatorMap != null && initialized);
		return initialized;
	}
}
