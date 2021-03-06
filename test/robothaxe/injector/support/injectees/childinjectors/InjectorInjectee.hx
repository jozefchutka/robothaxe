/*
 * Copyright (c) 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package robothaxe.injector.support.injectees.childinjectors;

import robothaxe.injector.Injector;

class InjectorInjectee
{
	public function new(){}
	
	@inject
	public var injector:Injector;

	public var nestedInjectee:NestedInjectorInjectee;

	@post
	public function createAnotherChildInjector()
	{
		nestedInjectee = injector.instantiate(NestedInjectorInjectee);
	}
}
