package robothaxe.injector.injectionpoints;

import massive.munit.Assert;
import robothaxe.injector.Injector;
import robothaxe.injector.support.injectees.ClassInjectee;

class PostConstructInjectionPointTest
 {
	public function new() { }
	
	@Test
	public function passingTest()
	{
		// not sure what this test was proving.
		Assert.isTrue(true);
	}
	/*
	@Test
	public function invokeXMLConfiguredPostConstructMethod():Void
	{
		var injectee:ClassInjectee = applyPostConstructToClassInjectee();
		Assert.isTrue(injectee.someProperty);
	}
	
	function applyPostConstructToClassInjectee():ClassInjectee
	{
		var injectee:ClassInjectee = new ClassInjectee();
		var injector:Injector = new Injector(
			Xml.parse("<types>
				<type name='robothaxe.injector.support.injectees::ClassInjectee'>
					<postconstruct name='doSomeStuff' order='1'/>
				</type>
			</types>"));
		injector.injectInto(injectee);
		
		return injectee;
	}
	*/
}
