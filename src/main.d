import std.exception;
import std.stdio;
import std.file;
import std.regex;
import std.path;
import std.string;

//Converts our path format to the comma seperated list used by env
string paths_to_csl(string paths)
{
	auto to_csl_regex = ctRegex!(r"\n");
	auto ignore_multislash_regex = ctRegex!(r"[\/]+");
	auto tilde_expand_regex = ctRegex!(r"(?:^|:)~");
	auto remove_trailing_regex = ctRegex!(r"[:\/\s]$");

	string csl_paths = paths;
	csl_paths = csl_paths.replaceAll(to_csl_regex, ":");
	csl_paths = csl_paths.replaceAll(tilde_expand_regex, "~".expandTilde());
	csl_paths = csl_paths.replaceAll(ignore_multislash_regex, "/");
	csl_paths = csl_paths.replaceAll(remove_trailing_regex, "");

	return csl_paths;
}

void main()
{
	string path_file = "~/.path".expandTilde();

	if (exists(path_file))
	{
		string paths = readText(path_file);
		auto csl_paths = paths_to_csl(paths);
		writeln(csl_paths);
	}
}

unittest
{
	writeln("Tilde expansion:");
	assert(paths_to_csl("~/android") == "~/android".expandTilde());
	writeln("Passed");
}

unittest
{
	writeln("Additional slashes are ignored:");
	assert(paths_to_csl("//bin////") == "/bin");
	writeln("Passed");
}

unittest
{
	writeln("Newlines are ignored:");
	assert(paths_to_csl("/bin\n") == "/bin");
	writeln("Passed");
}

unittest
{
	writeln("Multiple paths work:");
	assert(paths_to_csl("/bin\n/usr/bin\n/opt") == "/bin:/usr/bin:/opt");
	writeln("Passed");
}
