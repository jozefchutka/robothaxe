/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/
package robothaxe.mvcs;

import massive.munit.Assert;
import robothaxe.event.Event;
import robothaxe.core.IViewContainer;
import robothaxe.base.ContextEvent;
import robothaxe.mvcs.support.TestContext;
import robothaxe.mvcs.support.TestContextView;

class ContextTest
{
	var context:TestContext;
	var contextView:TestContextView;
	
	public function new(){}

	@Before
	public function runBeforeEachTest():Void
	{
		contextView = new TestContextView();
	}
	
	@After
	public function runAfterEachTest():Void
	{
	}
	
	@Test
	public function autoStartupWithViewComponent():Void
	{
		context = new TestContext(contextView, true);
		Assert.isTrue(context.startupComplete);//"Context should have started"
	}
	
	@Test
	public function autoStartupWithLateViewComponent():Void
	{
		context = new TestContext(null, true);
		Assert.isFalse(context.startupComplete);//"Context should NOT have started"
		context.contextView = contextView;
		Assert.isTrue(context.startupComplete);//"Context should have started"
	}
	
	@Test
	public function manualStartupWithViewComponent():Void
	{
		context = new TestContext(contextView, false);
		Assert.isFalse(context.startupComplete);//"Context should NOT have started"
		context.startup();
		Assert.isTrue(context.startupComplete);//"Context should now be started"
	}
	
	@Test
	public function manualStartupWithLateViewComponent():Void
	{
		context = new TestContext(null, false);
		Assert.isFalse(context.startupComplete);//"Context should NOT have started"
		context.contextView = contextView;
		context.startup();
		Assert.isTrue(context.startupComplete);//"Context should now be started"
	}
	/*
	[Test(async, timeout="3000")]
	public function autoStartupWithViewComponentAfterAddedToStage():Void
	{
		contextView = new TestContextView();
		context = new TestContext(contextView, true);
		Async.handleEvent(this, context, ContextEvent.STARTUP_COMPLETE, handleContextAutoStartupOnAddedToStage);
		
		Assert.isFalse("Context should NOT be started", context.startupComplete);
		UIImpersonator.addChild(contextView);
	}
	
	[Test(async, timeout="3000")]
	public function autoStartupWithLateViewComponentAfterAddedToStage():Void
	{
		contextView = new TestContextView();
		context = new TestContext(null, true);
		Async.handleEvent(this, context, ContextEvent.STARTUP_COMPLETE, handleContextAutoStartupOnAddedToStage);
		Assert.isFalse("Context should NOT be started", context.startupComplete);
		context.contextView = contextView;
		Assert.isFalse("Context should still NOT be started", context.startupComplete);
		UIImpersonator.addChild(contextView);
	}
	
	function handleContextAutoStartupOnAddedToStage(event:ContextEvent, param:Dynamic):Void
	{
		Assert.isTrue("Context should be started", context.startupComplete);
	}
	
	[Test(async, timeout="3000")]
	public function manualStartupWithViewComponentAfterAddedToStage():Void
	{
		contextView = new TestContextView();
		context = new TestContext(contextView, false);
		Async.handleEvent(this, contextView, Event.ADDED_TO_STAGE, handleContextManualStartupOnAddedToStage);
		Assert.isFalse("Context should NOT be started", context.startupComplete);
		UIImpersonator.addChild(contextView);
	}
	
	function handleContextManualStartupOnAddedToStage(event:Event, param:Dynamic):Void
	{
		Assert.isFalse("Context should NOT be started", context.startupComplete);
		context.startup();
		Assert.isTrue("Context should now be started", context.startupComplete);
	}
	*/
	@Test
	public function contextInitializationComplete():Void
	{
		context = new TestContext(contextView);
		Assert.isTrue(context.isInitialized);//"Context should be initialized"
	}
}
