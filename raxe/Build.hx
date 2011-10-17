package raxe;

import raxe.HaxeLib;

class Build extends BuildBase
{
	public static function main(){ new Build().run(); }

	public function new()
	{
		super();

		project.id = "robothaxe";

		haxelib.name = "robothaxe";
		haxelib.url = "https://github.com/DavidPeek/robothaxe";
		haxelib.username = "massive";
		haxelib.description = "RobotHaxe is a port of the AS3 RobotLegs framework.";
		haxelib.version.set("1.0.1");
		haxelib.version.description = "Minor change: don't delay mediator release.";
		haxelib.tag.add("cross");
		haxelib.file.add("src");
		haxelib.file.add("LICENSE");
		haxelib.file.add("README");
		haxelib.license = BSD;
	}
}