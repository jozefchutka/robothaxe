package raxe;

class Build extends BuildBase
{
	public static function main(){ new Build().run(); }

	public function new()
	{
		super();

		haxelib.name = "robothaxe";
		haxelib.url = "http://massiveinteractive.com";
		haxelib.username = "massive";
		haxelib.description = "RobotHaxe is a port of the AS3 RobotLegs framework.";
		haxelib.version.set("1.0.0");
		haxelib.tag.add("cross");
		haxelib.file.add("src");
		haxelib.file.add("test");
	}
}