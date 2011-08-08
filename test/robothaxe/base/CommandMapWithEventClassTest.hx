/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package robothaxe.base;

import massive.munit.Assert;
import robothaxe.event.Event;
import robothaxe.event.EventDispatcher;
import robothaxe.event.IEventDispatcher;
import robothaxe.injector.Injector;
import robothaxe.injector.Reflector;
import robothaxe.base.CommandMap;
import robothaxe.core.ICommandMap;
import robothaxe.core.IInjector;
import robothaxe.core.IReflector;
import robothaxe.mvcs.support.ICommandTester;
import robothaxe.mvcs.support.CustomEventCommand;
import robothaxe.mvcs.support.CustomEvent;

class CommandMapWithEventClassTest implements ICommandTester
{
	public function new(){}
	
	var eventDispatcher:IEventDispatcher;
	var commandExecuted:Bool;
	var commandMap:ICommandMap;
	var injector:IInjector;
	var reflector:IReflector;

	@Before
	public function runBeforeEachTest():Void
	{
		eventDispatcher = new EventDispatcher();
		injector = new Injector();
		reflector = new Reflector();
		commandMap = new CommandMap(eventDispatcher, injector, reflector);
		injector.mapValue(ICommandTester, this);
	}
	
	@After
	public function runAfterEachTest():Void
	{
		injector.unmap(ICommandTester);
		resetCommandExecuted();
	}
	
	@Test
	public function hasCommandForSpecifiedEventClass():Void
	{
		commandMap.mapEvent(CustomEvent.STARTED, CustomEventCommand, CustomEvent);
		var hasCommand:Bool = commandMap.hasEventCommand(CustomEvent.STARTED, CustomEventCommand, CustomEvent);
		Assert.isTrue(hasCommand);
		//'Command Map should have Command'
	}
	
	@Test
	public function shouldNotHaveCommandForUnmappedEventClass():Void
	{
		commandMap.mapEvent(CustomEvent.STARTED, CustomEventCommand, CustomEvent);
		var hasCommand:Bool = commandMap.hasEventCommand(CustomEvent.STARTED, CustomEventCommand, Event);
		Assert.isFalse(hasCommand);
		//'Command Map should not have Command for wrong event class'
	}
	
	@Test
	public function normalCommand():Void
	{
		commandMap.mapEvent(CustomEvent.STARTED, CustomEventCommand, CustomEvent);
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		Assert.isTrue(commandExecuted);
		//'Command should have reponded to event'
	}
	/*
	@Test
	public function dispatchingUnmappedEventClassShouldNotExecuteCommand():Void
	{
		commandMap.mapEvent(CustomEvent.STARTED, CustomEventCommand, CustomEvent);
		eventDispatcher.dispatchEvent(new Event(CustomEvent.STARTED));
		Assert.isFalse(commandExecuted);//'Command should not have reponded to unmapped event'
	}
	*/
	@Test
	public function normalCommandRepeated():Void
	{
		commandMap.mapEvent(CustomEvent.STARTED, CustomEventCommand, CustomEvent);
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		Assert.isTrue(commandExecuted);//'Command should have reponded to event'
		resetCommandExecuted();
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		Assert.isTrue(commandExecuted);//'Command should have reponded to event again'
	}
	
	@Test
	public function oneshotCommandShouldBeRemovedAfterFirstExecution():Void
	{
		var oneshot:Bool = true;
		commandMap.mapEvent(CustomEvent.STARTED, CustomEventCommand, CustomEvent, oneshot);
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		var hasCommand:Bool = commandMap.hasEventCommand(CustomEvent.STARTED, CustomEventCommand, CustomEvent);
		Assert.isFalse(hasCommand);
		//'Command Map should NOT have oneshot Command after first execution'
	}
	
	@Test
	public function oneshotCommandShouldNotExecuteASecondTime():Void
	{
		var oneshot:Bool = true;
		commandMap.mapEvent(CustomEvent.STARTED, CustomEventCommand, CustomEvent, oneshot);
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		Assert.isTrue(commandExecuted);
		//'Command should have reponded to event'
		resetCommandExecuted();
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		Assert.isFalse(commandExecuted);
		//'Oneshot Command should NOT have reponded to event a second time'
	}
	
	@Test
	public function normalCommandRemoved():Void
	{
		commandMap.mapEvent(CustomEvent.STARTED, CustomEventCommand, CustomEvent);
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		Assert.isTrue(commandExecuted);
		//'Command should have reponded to event'
		resetCommandExecuted();
		commandMap.unmapEvent(CustomEvent.STARTED, CustomEventCommand, CustomEvent);
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
		Assert.isFalse(commandExecuted);
		//'Command should NOT have reponded to event'
	}
	
	@Test
	public function unmapEvents():Void
	{
		commandMap.mapEvent(CustomEvent.EVENT0, CustomEventCommand, CustomEvent);
		commandMap.mapEvent(CustomEvent.EVENT1, CustomEventCommand, CustomEvent);
		commandMap.mapEvent(CustomEvent.EVENT2, CustomEventCommand, CustomEvent);
		commandMap.mapEvent(CustomEvent.EVENT3, CustomEventCommand, CustomEvent);
		commandMap.unmapEvents();
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.EVENT0));
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.EVENT1));
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.EVENT2));
		eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.EVENT3));
		Assert.isFalse(commandExecuted);
		//'Command should NOT have reponded to event'
	}
	/*
	@Test
	public function mappingNonCommandClassShouldFail():Void
	{
		var passed = false;

		try
		{
			commandMap.mapEvent(CustomEvent.STARTED, Dynamic, CustomEvent);
		}
		catch (e:ContextError)
		{
			passed = true;
		}

		Assert.isTrue(passed);
	}
	
	@Test
	public function mappingSameThingTwiceShouldFail():Void
	{
		var passed = false;

		try
		{
			commandMap.mapEvent(CustomEvent.STARTED, CustomEventCommand, CustomEvent);
			commandMap.mapEvent(CustomEvent.STARTED, CustomEventCommand, CustomEvent);
		}
		catch (e:ContextError)
		{
			passed = true;
		}

		Assert.isTrue(passed);
	}
	*/
	public function markCommandExecuted():Void
	{
		commandExecuted = true;
	}
	
	public function resetCommandExecuted():Void
	{
		commandExecuted = false;
	}
}
