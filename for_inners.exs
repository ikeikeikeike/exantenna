back = "rel/exantenna/releases/#{File.read! "VERSION"}/sys.config.back"
path = "rel/exantenna/releases/#{File.read! "VERSION"}/sys.config"

{:ok, conf} = File.read path
{:ok, tokens, _} = :erl_scan.string '#{conf}'
{:ok, erl} = :erl_parse.parse_term tokens

content = :proplists.delete(:quantum, erl)

File.write back, :io_lib.fwrite("~p.\n", [erl])
File.write path, :io_lib.fwrite("~p.\n", [content])
