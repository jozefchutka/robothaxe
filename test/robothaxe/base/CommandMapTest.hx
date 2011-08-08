/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package robothaxe.base;

import robothaxe.event.EventDispatcher;
import robothaxe.event.IEventDispatcher;

import massive.munit.Assert;
import robothaxe.base.CommandMap;
import robothaxe.base.support.ManualCommand;
import robothaxe.core.ICommandMap;
import robothaxe.core.IInjector;
import robothaxe.core.IReflector;
import robothaxe.injector.Injector;
import robothaxe.injector.Reflector;
import robothaxe.mvcs.support.CustomEvent;
import robothaxe.mvcs.support.EventCommand;
import robothaxe.mvcs.support.ICommandTester;

class CommandMapTest implements ICommandTester
{
	public function new(){}
	
	var eventDispatcher:IEventDispatcher;
	var commandExecuted:Bool;
	var commandMap:ICommandMap;
	var injector:IInjector;
	var reflector:IReflector;
	
	@Before
	public function setup():Void
	{
		eventDispatcher = new EventDispatcher();
		injector = new Injector();
		reflector = new Reflector();
		commandMap = new CommandMap(eventDispatcher, injector, reflector);
		injector.mapValue(ICommandTester, this);
	}
	
	@After
	public function tearDown():Void
	{
		injector.unmap(ICommandTester);
		resetCommandExecuted();
	}
	
	@Test
	public function noCommand():Void
	{
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		Assert.isFalse(commandExecuted);
		//'Command should not have reponded to event'
	}
	
	@Test
	public function hasCommand():Void
	{
		commandMap.mapEvent(CustomEvent.STARTED, EventCommand);
		var hasCommand:Bool = commandMap.hasEventCommand(CustomEvent.STARTED, EventCommand);
		Assert.isTrue(hasCommand);
		//'Command Map should have Command'
	}
	
	@Test
	public function normalCommand():Void
	{
		commandMap.mapEvent(CustomEvent.STARTED, EventCommand);
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		Assert.isTrue(commandExecuted);
		//'Command should have reponded to event'
	}
	
	@Test
	public function normalCommandRepeated():Void
	{
		commandMap.mapEvent(CustomEvent.STARTED, EventCommand);
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		Assert.isTrue(commandExecuted);
		//'Command should have reponded to event'

		resetCommandExecuted();
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		Assert.isTrue(commandExecuted);
		//'Command should have reponded to event again'
	}
	
	@Test
	public function oneshotCommand():Void
	{
		commandMap.mapEvent(CustomEvent.STARTED, EventCommand, null, true);
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		Assert.isTrue(commandExecuted);
		//'Command should have reponded to event'

		resetCommandExecuted();
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		Assert.isFalse(commandExecuted);
		//'Command should NOT have reponded to event'
	}
	
	@Test
	public function normalCommandRemoved():Void
	{
		commandMap.mapEvent(CustomEvent.STARTED, EventCommand);
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		Assert.isTrue(commandExecuted);//'Command should have reponded to event'

		resetCommandExecuted();
		commandMap.unmapEvent(CustomEvent.STARTED, EventCommand);
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		Assert.isFalse(commandExecuted);//'Command should NOT have reponded to event'
	}
	
	@Test
	public function unmapEvents():Void
	{
		commandMap.mapEvent(CustomEvent.EVENT0, EventCommand);
		commandMap.mapEvent(CustomEvent.EVENT1, EventCommand);
		commandMap.mapEvent(CustomEvent.EVENT2, EventCommand);
		commandMap.mapEvent(CustomEvent.EVENT3, EventCommand);
		commandMap.unmapEvents();
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.EVENT0));
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.EVENT1));
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.EVENT2));
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.EVENT3));
		Assert.isFalse(commandExecuted);
		//'Command should NOT have reponded to event'
	}
	
	@Test
	public function manuallyExecute():Void
	{
		commandMap.execute(ManualCommand, {});
		Assert.isTrue(commandExecuted);//'Command should have executed with custom payload'
	}
	
	@Test
	public function mappingNonCommandClassShouldFail():Void
	{
		var passed = false;

		try
		{
			commandMap.mapEvent(CustomEvent.STARTED, Dynamic);
		}
		catch (e:Dynamic)
		{
			passed = Std.is(e, ContextError);
		}

		Assert.isTrue(passed);
	}
	
	@Test
	public function mappingSameThingTwiceShouldFail():Void
	{
		var passed = false;

		try
		{
			commandMap.mapEvent(CustomEvent.STARTED, EventCommand);
			commandMap.mapEvent(CustomEvent.STARTED, EventCommand);
		}
		catch (e:Dynamic)
		{
			passed = Std.is(e, ContextError);
		}

		Assert.isTrue(passed);
	}
	
	public function markCommandExecuted():Void
	{
		commandExecuted = true;
	}
	
	public function resetCommandExecuted():Void
	{
		commandExecuted = false;
	}
}
