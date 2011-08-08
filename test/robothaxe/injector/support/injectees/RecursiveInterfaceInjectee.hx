package robothaxe.injector.support.injectees;

import robothaxe.injector.support.types.Interface1;

class RecursiveInterfaceInjectee implements Interface1
{
	@inject
	public var interfaceInjectee:InterfaceInjectee;
	
	public function new(){}
}
