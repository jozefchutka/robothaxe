/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package robothaxe.base;

import robothaxe.event.Event;
import robothaxe.event.EventDispatcher;
import robothaxe.event.IEventDispatcher;

import massive.munit.Assert;
import robothaxe.core.IEventMap;
import robothaxe.core.IInjector;
import robothaxe.core.IMediator;
import robothaxe.core.IMediatorMap;
import robothaxe.core.IReflector;
import robothaxe.core.IViewContainer;
/*
import robothaxe.mvcs.support.TestContextView;
import robothaxe.mvcs.support.TestContextViewMediator;
import robothaxe.mvcs.support.ViewComponent;
import robothaxe.mvcs.support.ViewComponentAdvanced;
import robothaxe.mvcs.support.ViewMediator;
import robothaxe.mvcs.support.ViewMediatorAdvanced;
*/
class MediatorMapTest
 {
	public function new() { }
	
	public static var TEST_EVENT:String = 'testEvent';
	
	// var contextView:IViewContainer;
	// var eventDispatcher:IEventDispatcher;
	// var commandExecuted:Bool;
	// var mediatorMap:MediatorMap;
	// var injector:IInjector;
	// var reflector:IReflector;
	// var eventMap:IEventMap;
	
	@Before
	public function runBeforeEachTest():Void
	{
		// contextView = new TestContextView();
		// eventDispatcher = new EventDispatcher();
		// injector = new SwiftSuspendersInjector();
		// reflector = new SwiftSuspendersReflector();
		// mediatorMap = new MediatorMap(contextView, injector, reflector);
		
		// injector.mapValue(IViewContainer, contextView);
		// injector.mapValue(IInjector, injector);
		// injector.mapValue(IEventDispatcher, eventDispatcher);
		// injector.mapValue(IMediatorMap, mediatorMap);
		
		// UIImpersonator.addChild(contextView);
	}
	
	@After
	public function runAfterEachTest():Void
	{
		// UIImpersonator.removeAllChildren();
		// injector.unmap(IMediatorMap);
	}

	public function passingTest()
	{
		Assert.isTrue(true);
	}

	/*
	@Test
	public function mediatorIsMappedAndCreatedForView():Void
	{
		mediatorMap.mapView(ViewComponent, ViewMediator, null, false, false);
		var viewComponent:ViewComponent = new ViewComponent();
		contextView.addChild(viewComponent);
		var mediator:IMediator = mediatorMap.createMediator(viewComponent);
		var hasMapping:Bool = mediatorMap.hasMapping(ViewComponent);
		Assert.assertNotNull('Mediator should have been created ', mediator);
		Assert.isTrue('Mediator should have been created for View Component', mediatorMap.hasMediatorForView(viewComponent));
		Assert.isTrue('View mapping should exist for View Component', hasMapping);
	}
	
	@Test
	public function mediatorIsMappedAndCreatedWithInjectViewAsClass():Void {
		mediatorMap.mapView(ViewComponent, ViewMediator, ViewComponent, false, false);
		var viewComponent:ViewComponent = new ViewComponent();
		contextView.addChild(viewComponent);
		var mediator:IMediator = mediatorMap.createMediator(viewComponent);
		var exactMediator:ViewMediator = cast( mediator, ViewMediator);
		Assert.assertNotNull('Mediator should have been created', mediator);
		Assert.isTrue('Mediator should have been created of the exact desired class', Std.is( mediator, ViewMediator));
		Assert.isTrue('Mediator should have been created for View Component', mediatorMap.hasMediatorForView(viewComponent));
		Assert.assertNotNull('View Component should have been injected into Mediator', exactMediator.view);
		Assert.isTrue('View Component injected should match the desired class type', Std.is( exactMediator.view, ViewComponent));
	}
	
	@Test
	public function mediatorIsMappedAndCreatedWithInjectViewAsArrayOfSameClass():Void {
		mediatorMap.mapView(ViewComponent, ViewMediator, [ViewComponent], false, false);
		var viewComponent:ViewComponent = new ViewComponent();
		contextView.addChild(viewComponent);
		var mediator:IMediator = mediatorMap.createMediator(viewComponent);
		var exactMediator:ViewMediator = cast( mediator, ViewMediator);
		Assert.assertNotNull('Mediator should have been created', mediator);
		Assert.isTrue('Mediator should have been created of the exact desired class', Std.is( mediator, ViewMediator));
		Assert.isTrue('Mediator should have been created for View Component', mediatorMap.hasMediatorForView(viewComponent));
		Assert.assertNotNull('View Component should have been injected into Mediator', exactMediator.view);
		Assert.isTrue('View Component injected should match the desired class type', Std.is( exactMediator.view, ViewComponent));
	}
	
	@Test
	public function mediatorIsMappedAndCreatedWithInjectViewAsArrayOfRelatedClass():Void {
		mediatorMap.mapView(ViewComponentAdvanced, ViewMediatorAdvanced, [ViewComponent, ViewComponentAdvanced], false, false);
		var viewComponentAdvanced:ViewComponentAdvanced = new ViewComponentAdvanced();
		contextView.addChild(viewComponentAdvanced);
		var mediator:IMediator = mediatorMap.createMediator(viewComponentAdvanced);
		var exactMediator:ViewMediatorAdvanced = cast( mediator, ViewMediatorAdvanced);
		Assert.assertNotNull('Mediator should have been created', mediator);
		Assert.isTrue('Mediator should have been created of the exact desired class', Std.is( mediator, ViewMediatorAdvanced));
		Assert.isTrue('Mediator should have been created for View Component', mediatorMap.hasMediatorForView(viewComponentAdvanced));
		Assert.assertNotNull('First Class in the "injectViewAs" array should have been injected into Mediator', exactMediator.view);
		Assert.assertNotNull('Second Class in the "injectViewAs" array should have been injected into Mediator', exactMediator.viewAdvanced);
		Assert.isTrue('First Class injected via the "injectViewAs" array should match the desired class type', Std.is( exactMediator.view, ViewComponent));
		Assert.isTrue('Second Class injected via the "injectViewAs" array should match the desired class type', Std.is( exactMediator.viewAdvanced, ViewComponentAdvanced));
	}
	
	
	@Test
	public function mediatorIsMappedAddedAndRemoved():Void
	{
		var viewComponent:ViewComponent = new ViewComponent();
		var mediator:IMediator;
		
		mediatorMap.mapView(ViewComponent, ViewMediator, null, false, false);
		contextView.addChild(viewComponent);
		mediator = mediatorMap.createMediator(viewComponent);
		Assert.assertNotNull('Mediator should have been created', mediator);
		Assert.isTrue('Mediator should have been created', mediatorMap.hasMediator(mediator));
		Assert.isTrue('Mediator should have been created for View Component', mediatorMap.hasMediatorForView(viewComponent));
		mediatorMap.removeMediator(mediator);
		Assert.isFalse("Mediator Should Not Exist", mediatorMap.hasMediator(mediator));
		Assert.isFalse("View Mediator Should Not Exist", mediatorMap.hasMediatorForView(viewComponent));
	}
	
	@Test
	public function mediatorIsMappedAddedAndRemovedByView():Void
	{
		var viewComponent:ViewComponent = new ViewComponent();
		var mediator:IMediator;
		
		mediatorMap.mapView(ViewComponent, ViewMediator, null, false, false);
		contextView.addChild(viewComponent);
		mediator = mediatorMap.createMediator(viewComponent);
		Assert.assertNotNull('Mediator should have been created', mediator);
		Assert.isTrue('Mediator should have been created', mediatorMap.hasMediator(mediator));
		Assert.isTrue('Mediator should have been created for View Component', mediatorMap.hasMediatorForView(viewComponent));
		mediatorMap.removeMediatorByView(viewComponent);
		Assert.isFalse("Mediator should not exist", mediatorMap.hasMediator(mediator));
		Assert.isFalse("View Mediator should not exist", mediatorMap.hasMediatorForView(viewComponent));
	}
	
	@Test
	public function autoRegister():Void
	{
		mediatorMap.mapView(ViewComponent, ViewMediator, null, true, true);
		var viewComponent:ViewComponent = new ViewComponent();
		contextView.addChild(viewComponent);
		Assert.isTrue('Mediator should have been created for View Component', mediatorMap.hasMediatorForView(viewComponent));
	}
	
	[Test(async, timeout='500')]
	public function mediatorIsKeptDuringReparenting():Void
	{
		var viewComponent:ViewComponent = new ViewComponent();
		var mediator:IMediator;
		
		mediatorMap.mapView(ViewComponent, ViewMediator, null, false, true);
		contextView.addChild(viewComponent);
		mediator = mediatorMap.createMediator(viewComponent);
		Assert.assertNotNull('Mediator should have been created', mediator);
		Assert.isTrue('Mediator should have been created', mediatorMap.hasMediator(mediator));
		Assert.isTrue('Mediator should have been created for View Component', mediatorMap.hasMediatorForView(viewComponent));
		var container:UIComponent = new UIComponent();
		contextView.addChild(container);
		container.addChild(viewComponent);
		
		Async.handleEvent(this, contextView, Event.ENTER_FRAME, delayFurther, 500, {dispatcher: contextView, method: verifyMediatorSurvival, view: viewComponent, mediator: mediator});
	}
	
	function verifyMediatorSurvival(event:Event, data:Dynamic):Void
	{
		var viewComponent:ViewComponent = data.view;
		var mediator:IMediator = data.mediator;
		Assert.isTrue("Mediator should exist", mediatorMap.hasMediator(mediator));
		Assert.isTrue("View Mediator should exist", mediatorMap.hasMediatorForView(viewComponent));
	}
	
	[Test(async, timeout='500')]
	public function mediatorIsRemovedWithView():Void
	{
		var viewComponent:ViewComponent = new ViewComponent();
		var mediator:IMediator;
		
		mediatorMap.mapView(ViewComponent, ViewMediator, null, false, true);
		contextView.addChild(viewComponent);
		mediator = mediatorMap.createMediator(viewComponent);
		Assert.assertNotNull('Mediator should have been created', mediator);
		Assert.isTrue('Mediator should have been created', mediatorMap.hasMediator(mediator));
		Assert.isTrue('Mediator should have been created for View Component', mediatorMap.hasMediatorForView(viewComponent));
		
		contextView.removeChild(viewComponent);
		Async.handleEvent(this, contextView, Event.ENTER_FRAME, delayFurther, 500, {dispatcher: contextView, method: verifyMediatorRemoval, view: viewComponent, mediator: mediator});
	}
	
	function verifyMediatorRemoval(event:Event, data:Dynamic):Void
	{
		var viewComponent:ViewComponent = data.view;
		var mediator:IMediator = data.mediator;
		Assert.isFalse("Mediator should not exist", mediatorMap.hasMediator(mediator));
		Assert.isFalse("View Mediator should not exist", mediatorMap.hasMediatorForView(viewComponent));
	}
	
	function delayFurther(event:Event, data:Dynamic):Void
	{
		Async.handleEvent(this, data.dispatcher, Event.ENTER_FRAME, data.method, 500, data);
		delete data.dispatcher;
		delete data.method;
	}
	
	@Test
	public function contextViewMediatorIsCreatedWhenMapped():Void
	{
		mediatorMap.mapView( TestContextView, TestContextViewMediator );
		Assert.isTrue('Mediator should have been created for contextView', mediatorMap.hasMediatorForView(contextView));
	}
	
	@Test
	public function contextViewMediatorIsNotCreatedWhenMappedAndAutoCreateIsFalse():Void
	{
		mediatorMap.mapView( TestContextView, TestContextViewMediator, null, false );
		Assert.isFalse('Mediator should NOT have been created for contextView', mediatorMap.hasMediatorForView(contextView));
	}
	
	@Test
	public function unmapView():Void
	{
		mediatorMap.mapView(ViewComponent, ViewMediator);
		mediatorMap.unmapView(ViewComponent);
		var viewComponent:ViewComponent = new ViewComponent();
		contextView.addChild(viewComponent);
		var hasMediator:Bool = mediatorMap.hasMediatorForView(viewComponent);
		var hasMapping:Bool = mediatorMap.hasMapping(ViewComponent);
		Assert.isFalse('Mediator should NOT have been created for View Component', hasMediator);
		Assert.isFalse('View mapping should NOT exist for View Component', hasMapping);
	}
	
	@Test
	public function autoRegisterUnregisterRegister():Void
	{
		var viewComponent:ViewComponent = new ViewComponent();
		
		mediatorMap.mapView(ViewComponent, ViewMediator, null, true, true);
		mediatorMap.unmapView(ViewComponent);
		contextView.addChild(viewComponent);
		Assert.isFalse('Mediator should NOT have been created for View Component', mediatorMap.hasMediatorForView(viewComponent));
		contextView.removeChild(viewComponent);
		
		mediatorMap.mapView(ViewComponent, ViewMediator, null, true, true);
		contextView.addChild(viewComponent);
		Assert.isTrue('Mediator should have been created for View Component', mediatorMap.hasMediatorForView(viewComponent));
	}
	*/
}
