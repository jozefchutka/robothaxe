/*
* Copyright (c) 2009 the original author or authors
*
* Permission is hereby granted to use, modify, and distribute this file
* in accordance with the terms of the license agreement accompanying it.
*/
package robothaxe.base.support;

import robothaxe.core.IView;

class TestContextView implements IView
{
	public var viewAdded:Dynamic -> Void;
	public var viewRemoved:Dynamic -> Void;

	@inject("injectionName")
	public var injectionPoint:String;
	
	public function new()
	{
	}

	public function addView(view:Dynamic)
	{
		if (viewAdded != null)
		{
			viewAdded(view);
		}
	}

	public function removeView(view:Dynamic)
	{
		if (viewRemoved != null)
		{
			viewRemoved(view);
		}
	}
}
