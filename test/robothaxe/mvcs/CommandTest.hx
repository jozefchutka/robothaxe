/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/
package robothaxe.mvcs;

import robothaxe.event.Event;
import robothaxe.event.EventDispatcher;
import robothaxe.event.IEventDispatcher;

import massive.munit.Assert;
import robothaxe.injector.Injector;
import robothaxe.injector.Reflector;
import robothaxe.base.CommandMap;
import robothaxe.core.ICommandMap;
import robothaxe.core.IInjector;
import robothaxe.core.IReflector;
import robothaxe.mvcs.support.ICommandTester;
import robothaxe.mvcs.support.TestCommand;

class CommandTest implements ICommandTester
{
	public static var TEST_EVENT = "testEvent";

	var eventDispatcher:IEventDispatcher;
	var commandExecuted:Bool;
	var commandMap:ICommandMap;
	var injector:IInjector;
	var reflector:IReflector;
	
	public function new(){}
	
	@Before
	public function before():Void
	{
		eventDispatcher = new EventDispatcher();
		injector = new Injector();
		reflector = new Reflector();
		commandMap = new CommandMap(eventDispatcher, injector, reflector);
		injector.mapValue(ICommandTester, this);
	}
	
	@After
	public function after():Void
	{
		injector.unmap(ICommandTester);
		resetCommandExecuted();
	}
	/*
	@Test
	public function commandIsExecuted():Void
	{
		Assert.isFalse(commandExecuted);//"Command should NOT have executed"
		commandMap.mapEvent(TEST_EVENT, TestCommand);
		eventDispatcher.dispatchEvent(new Event(TEST_EVENT));
		Assert.isTrue(commandExecuted);//"Command should have executed"
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
