/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package robothaxe.mvcs.support;

import robothaxe.event.Event;

class EventCommand
 {
	public function new(){}
	
	@inject
	public var testSuite:ICommandTester;
	
	public function execute():Void
	{
		testSuite.markCommandExecuted();
	}

}
