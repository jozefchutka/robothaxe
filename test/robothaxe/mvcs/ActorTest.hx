/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/
package robothaxe.mvcs;

import robothaxe.event.Event;
import robothaxe.event.IEventDispatcher;
import robothaxe.core.IInjector;
import robothaxe.core.IView;
import robothaxe.mvcs.support.TestActor;
import robothaxe.mvcs.support.TestContext;
import robothaxe.mvcs.support.TestContextView;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

class ActorTest
 {
 	public static var TEST_EVENT = "testEvent";

	var context:TestContext;
	var contextView:IView;
	var actor:TestActor;
	var injector:IInjector;
	var eventDispatcher:IEventDispatcher;
	
	public function new(){}
	
	@Before
	public function before():Void
	{
		dispatched = false;
		contextView = new TestContextView();
		context = new TestContext(contextView);
		actor = new TestActor();
		injector = context.getInjector();
		injector.injectInto(actor);
	}
	
	@After
	public function after():Void
	{
	}

	@Test
	public function passingTest():Void
	{
		Assert.isTrue(true);
	}
	/*
	@Test
	public function hasEventDispatcher():Void
	{
		Assert.isNotNull(actor.eventDispatcher);
	}
	
	@Test
	public function canDispatchEvent():Void
	{
		context.addEventListener(TEST_EVENT, handleEventDispatch);
		actor.dispatchTestEvent();
		Assert.isTrue(dispatched);
	}
	*/
	var dispatched:Bool;

	function handleEventDispatch(event:Event):Void
	{
		dispatched = (event.type == TEST_EVENT);
	}
}
