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
import robothaxe.injector.Injector;
import robothaxe.injector.Reflector;
import robothaxe.core.IMediator;
import robothaxe.core.IMediatorMap;
import robothaxe.core.IReflector;
import robothaxe.core.IView;

import robothaxe.mvcs.support.TestContextView;
import robothaxe.mvcs.support.TestContextViewMediator;
import robothaxe.mvcs.support.ViewComponent;
import robothaxe.mvcs.support.ViewComponentAdvanced;
import robothaxe.mvcs.support.ViewMediator;
import robothaxe.mvcs.support.ViewMediatorAdvanced;

class MediatorMapTest
 {
	public function new() { }
	
	public static var TEST_EVENT:String = 'testEvent';
	
	var contextView:TestContextView;
	var eventDispatcher:IEventDispatcher;
	var commandExecuted:Bool;
	var mediatorMap:MediatorMap;
	var injector:IInjector;
	var reflector:IReflector;
	var eventMap:IEventMap;
	
	@Before
	public function runBeforeEachTest():Void
	{
		contextView = new TestContextView();
		eventDispatcher = new EventDispatcher();
		injector = new Injector();
		reflector = new Reflector();
		mediatorMap = new MediatorMap(contextView, injector, reflector);
		
		injector.mapValue(IView, contextView);
		injector.mapValue(IInjector, injector);
		injector.mapValue(IEventDispatcher, eventDispatcher);
		injector.mapValue(IMediatorMap, mediatorMap);
	}
	
	@After
	public function runAfterEachTest():Void
	{
		injector.unmap(IMediatorMap);
	}
	
	@Test
	public function mediatorIsMappedAndCreatedForView():Void
	{
		mediatorMap.mapView(ViewComponent, ViewMediator, null, false, false);
		
		var viewComponent = new ViewComponent();
		contextView.addView(viewComponent);
		
		var mediator = mediatorMap.createMediator(viewComponent);
		var hasMapping = mediatorMap.hasMapping(ViewComponent);
		
		Assert.isTrue(hasMapping);//'View mapping should exist for View Component'
		Assert.isNotNull(mediator);//'Mediator should have been created'
		Assert.isTrue(mediatorMap.hasMediatorForView(viewComponent));//'Mediator should have been created for View Component'
	}
	
	@Test
	public function mediatorIsMappedAndCreatedWithInjectViewAsClass():Void
	{
		mediatorMap.mapView(ViewComponent, ViewMediator, ViewComponent, false, false);
		
		var viewComponent = new ViewComponent();
		contextView.addView(viewComponent);
		
		var mediator:IMediator = mediatorMap.createMediator(viewComponent);
		var exactMediator:ViewMediator = cast( mediator, ViewMediator);

		Assert.isNotNull(mediator);//'Mediator should have been created'
		Assert.isTrue(Std.is(mediator, ViewMediator));//'Mediator should have been created of the exact desired class'
		Assert.isTrue(mediatorMap.hasMediatorForView(viewComponent));//'Mediator should have been created for View Component'
		Assert.isNotNull(exactMediator.view);//'View Component should have been injected into Mediator'
		Assert.isTrue(Std.is(exactMediator.view, ViewComponent));//'View Component injected should match the desired class type'
	}
	
	@Test
	public function mediatorIsMappedAndCreatedWithInjectViewAsArrayOfSameClass():Void
	{
		mediatorMap.mapView(ViewComponent, ViewMediator, [ViewComponent], false, false);

		var viewComponent = new ViewComponent();
		contextView.addView(viewComponent);
		
		var mediator:IMediator = mediatorMap.createMediator(viewComponent);
		var exactMediator:ViewMediator = cast( mediator, ViewMediator);
		
		Assert.isNotNull(mediator);//'Mediator should have been created'
		Assert.isTrue(Std.is(mediator, ViewMediator));//'Mediator should have been created of the exact desired class'
		Assert.isTrue(mediatorMap.hasMediatorForView(viewComponent));//'Mediator should have been created for View Component'
		Assert.isNotNull(exactMediator.view);//'View Component should have been injected into Mediator'
		Assert.isTrue(Std.is(exactMediator.view, ViewComponent));//'View Component injected should match the desired class type'
	}
	
	@Test
	public function mediatorIsMappedAndCreatedWithInjectViewAsArrayOfRelatedClass():Void
	{
		mediatorMap.mapView(ViewComponentAdvanced, ViewMediatorAdvanced, [ViewComponent, ViewComponentAdvanced], false, false);
		
		var viewComponentAdvanced:ViewComponentAdvanced = new ViewComponentAdvanced();
		contextView.addView(viewComponentAdvanced);

		var mediator:IMediator = mediatorMap.createMediator(viewComponentAdvanced);
		var exactMediator:ViewMediatorAdvanced = cast( mediator, ViewMediatorAdvanced);

		Assert.isNotNull(mediator);//'Mediator should have been created'
		Assert.isTrue(Std.is(mediator, ViewMediatorAdvanced));//'Mediator should have been created of the exact desired class'
		Assert.isTrue(mediatorMap.hasMediatorForView(viewComponentAdvanced));//'Mediator should have been created for View Component'
		Assert.isNotNull(exactMediator.view);//'First Class in the "injectViewAs" array should have been injected into Mediator'
		Assert.isNotNull(exactMediator.viewAdvanced);//'Second Class in the "injectViewAs" array should have been injected into Mediator'
		Assert.isTrue(Std.is(exactMediator.view, ViewComponent));//'First Class injected via the "injectViewAs" array should match the desired class type'
		Assert.isTrue(Std.is(exactMediator.viewAdvanced, ViewComponentAdvanced));//'Second Class injected via the "injectViewAs" array should match the desired class type'
	}
	
	@Test
	public function mediatorIsMappedAddedAndRemoved():Void
	{
		var viewComponent:ViewComponent = new ViewComponent();
		
		mediatorMap.mapView(ViewComponent, ViewMediator, null, false, false);
		contextView.addView(viewComponent);

		var mediator:IMediator = mediatorMap.createMediator(viewComponent);
		
		Assert.isNotNull(mediator);//'Mediator should have been created'
		Assert.isTrue(mediatorMap.hasMediator(mediator));//'Mediator should have been created'
		Assert.isTrue(mediatorMap.hasMediatorForView(viewComponent));//'Mediator should have been created for View Component'
		
		mediatorMap.removeMediator(mediator);
		
		Assert.isFalse(mediatorMap.hasMediator(mediator));//"Mediator Should Not Exist"
		Assert.isFalse(mediatorMap.hasMediatorForView(viewComponent));//"View Mediator Should Not Exist"
	}
	
	@Test
	public function mediatorIsMappedAddedAndRemovedByView():Void
	{
		var viewComponent:ViewComponent = new ViewComponent();
		
		mediatorMap.mapView(ViewComponent, ViewMediator, null, false, false);
		contextView.addView(viewComponent);
		
		var mediator:IMediator = mediatorMap.createMediator(viewComponent);

		Assert.isNotNull(mediator);//'Mediator should have been created'
		Assert.isTrue(mediatorMap.hasMediator(mediator));//'Mediator should have been created'
		Assert.isTrue(mediatorMap.hasMediatorForView(viewComponent));//'Mediator should have been created for View Component'
		
		mediatorMap.removeMediatorByView(viewComponent);
		
		Assert.isFalse(mediatorMap.hasMediator(mediator));//"Mediator should not exist"
		Assert.isFalse(mediatorMap.hasMediatorForView(viewComponent));//"View Mediator should not exist"
	}
	
	@Test
	public function autoRegister():Void
	{
		mediatorMap.mapView(ViewComponent, ViewMediator, null, true, true);
		var viewComponent = new ViewComponent();
		contextView.addView(viewComponent);
		Assert.isTrue(mediatorMap.hasMediatorForView(viewComponent));//'Mediator should have been created for View Component'
	}
	/*
	[Test(async, timeout='500')]
	public function mediatorIsKeptDuringReparenting():Void
	{
		var viewComponent:ViewComponent = new ViewComponent();
		
		mediatorMap.mapView(ViewComponent, ViewMediator, null, false, true);
		contextView.addChild(viewComponent);
		
		var mediator:IMediator = mediatorMap.createMediator(viewComponent);
		
		Assert.isNotNull(mediator);//'Mediator should have been created'
		Assert.isTrue(mediatorMap.hasMediator(mediator));//'Mediator should have been created'
		Assert.isTrue(mediatorMap.hasMediatorForView(viewComponent));//'Mediator should have been created for View Component'

		var container:UIComponent = new UIComponent();
		contextView.addChild(container);
		container.addChild(viewComponent);
		
		Async.handleEvent(this, contextView, Event.ENTER_FRAME, delayFurther, 500, {dispatcher:contextView, method: verifyMediatorSurvival, view:viewComponent, mediator: mediator});
	}
	
	function verifyMediatorSurvival(event:Event, data:Dynamic):Void
	{
		var viewComponent:ViewComponent = data.view;
		var mediator:IMediator = data.mediator;
		Assert.isTrue(mediatorMap.hasMediator(mediator));//"Mediator should exist"
		Assert.isTrue(mediatorMap.hasMediatorForView(viewComponent));//"View Mediator should exist"
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
	*/
	@Test
	public function contextViewMediatorIsCreatedWhenMapped():Void
	{
		mediatorMap.mapView( TestContextView, TestContextViewMediator );
		Assert.isTrue(mediatorMap.hasMediatorForView(contextView));//'Mediator should have been created for contextView'
	}
	
	@Test
	public function contextViewMediatorIsNotCreatedWhenMappedAndAutoCreateIsFalse():Void
	{
		mediatorMap.mapView( TestContextView, TestContextViewMediator, null, false );
		Assert.isFalse(mediatorMap.hasMediatorForView(contextView));//'Mediator should NOT have been created for contextView'
	}
	
	@Test
	public function unmapView():Void
	{
		mediatorMap.mapView(ViewComponent, ViewMediator);
		mediatorMap.unmapView(ViewComponent);

		var viewComponent = new ViewComponent();
		contextView.addView(viewComponent);
		
		var hasMediator = mediatorMap.hasMediatorForView(viewComponent);
		var hasMapping = mediatorMap.hasMapping(ViewComponent);

		Assert.isFalse(hasMediator);//'Mediator should NOT have been created for View Component'
		Assert.isFalse(hasMapping);//'View mapping should NOT exist for View Component'
	}
	
	@Test
	public function autoRegisterUnregisterRegister():Void
	{
		mediatorMap.mapView(ViewComponent, ViewMediator, null, true, true);
		mediatorMap.unmapView(ViewComponent);

		var viewComponent = new ViewComponent();
		contextView.addView(viewComponent);

		Assert.isFalse(mediatorMap.hasMediatorForView(viewComponent));//'Mediator should NOT have been created for View Component'
		contextView.removeView(viewComponent);
		
		mediatorMap.mapView(ViewComponent, ViewMediator, null, true, true);
		contextView.addView(viewComponent);

		Assert.isTrue(mediatorMap.hasMediatorForView(viewComponent));//'Mediator should have been created for View Component'
	}
}
