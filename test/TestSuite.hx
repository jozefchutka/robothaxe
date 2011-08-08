import massive.munit.TestSuite;

import robothaxe.base.CommandMapTest;
import robothaxe.base.CommandMapWithEventClassTest;
import robothaxe.base.EventMapTest;
import robothaxe.base.MediatorMapTest;
import robothaxe.base.ViewMapTest;
import robothaxe.injector.ChildInjectorTest;
import robothaxe.injector.GetConstructorTest;
import robothaxe.injector.InjectionConfigTest;
import robothaxe.injector.injectionpoints.ConstructorInjectionPointTest;
import robothaxe.injector.injectionpoints.MethodInjectionPointTest;
import robothaxe.injector.injectionpoints.NoParamsConstructorInjectionPointTest;
import robothaxe.injector.injectionpoints.PostConstructInjectionPointTest;
import robothaxe.injector.injectionpoints.PropertyInjectionPointTest;
import robothaxe.injector.InjectorTest;
import robothaxe.injector.ReflectorTest;
import robothaxe.mvcs.ActorProtectedTest;
import robothaxe.mvcs.ActorTest;
import robothaxe.mvcs.CommandTest;
import robothaxe.mvcs.ContextTest;
import robothaxe.mvcs.MediatorProtectedTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(robothaxe.base.CommandMapTest);
		add(robothaxe.base.CommandMapWithEventClassTest);
		add(robothaxe.base.EventMapTest);
		add(robothaxe.base.MediatorMapTest);
		add(robothaxe.base.ViewMapTest);
		add(robothaxe.injector.ChildInjectorTest);
		add(robothaxe.injector.GetConstructorTest);
		add(robothaxe.injector.InjectionConfigTest);
		add(robothaxe.injector.injectionpoints.ConstructorInjectionPointTest);
		add(robothaxe.injector.injectionpoints.MethodInjectionPointTest);
		add(robothaxe.injector.injectionpoints.NoParamsConstructorInjectionPointTest);
		add(robothaxe.injector.injectionpoints.PostConstructInjectionPointTest);
		add(robothaxe.injector.injectionpoints.PropertyInjectionPointTest);
		add(robothaxe.injector.InjectorTest);
		add(robothaxe.injector.ReflectorTest);
		add(robothaxe.mvcs.ActorProtectedTest);
		add(robothaxe.mvcs.ActorTest);
		add(robothaxe.mvcs.CommandTest);
		add(robothaxe.mvcs.ContextTest);
		add(robothaxe.mvcs.MediatorProtectedTest);
	}
}
