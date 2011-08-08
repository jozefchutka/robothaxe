/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/
package robothaxe.mvcs.support;

import robothaxe.event.Event;
import robothaxe.mvcs.Actor;
import robothaxe.mvcs.ActorTest;

class TestActor extends Actor
{
	public function new()
	{
		super();
	}

	public function dispatchTestEvent():Void
	{
		eventDispatcher.dispatchEvent(new Event(ActorTest.TEST_EVENT));
	}
}
