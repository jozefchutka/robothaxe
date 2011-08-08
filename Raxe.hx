class Raxe implements raxe.Module
{
	public function new(){}
	
	public function setup(app:raxe.Build)
	{
		app.set
		({
			app:
			{
				version:"0.0.1",
				id:"RobotHaxe"
			},
			haxe:
			{
				main:"Main",
				macros:
				{
					rtti:"RTTI.generate()"
				},
				classPaths:
				{
					test:
					{
						path:"test"
					}
				}
			}
		});
		
		app.task("default").require("test js as3");
	}
}
