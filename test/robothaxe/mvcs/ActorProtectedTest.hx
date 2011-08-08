/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/
package robothaxe.mvcs;

import massive.munit.Assert;
import robothaxe.mvcs.Actor;

/**
 * Extends Mediator in order to test protected APIs.
 */
class ActorProtectedTest extends Actor
{
	/**
	 * Exposed a bug with the lazy getter where a new EventMap was being created each time.
	 */
	public function new()
	{
		super();
	}
	
	/**
	 * Exposed a bug with the lazy getter where a new EventMap was being created each time.
	 */
	@Test
	public function retrievingEventMapTwiceShouldYieldSameObject():Void
	{
		Assert.areEqual(this.eventMap, this.eventMap);
	}
	
}
