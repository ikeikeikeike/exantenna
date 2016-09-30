back = "rel/exantenna/releases/#{File.read! "VERSION"}/sys.config.back"
path = "rel/exantenna/releases/#{File.read! "VERSION"}/sys.config"

{:ok, conf} = File.read path
{:ok, tokens, _} = :erl_scan.string '#{conf}'
{:ok, erl} = :erl_parse.parse_term tokens

content = Keyword.delete erl, :quantum
content = put_in content, [:exantenna, :toon_filters], []
content = put_in content, [:exantenna, :char_filters], []
content = put_in content, [:exantenna, :translate_filters], []

File.rename path, back
File.write path, :io_lib.fwrite("~p.\n", [content])
