defmodule Exantenna.Redis do
  defmacro __using__(opts) do
    quote do

      @__using_resource__ unquote(opts)

      def pid do
        opts = @__using_resource__
        case Redix.start_link(opts[:uri], name: __MODULE__) do
          {:ok, pid} -> pid
          {:error, {:already_started, pid}} -> pid
        end
      end

      case @__using_resource__[:type] do
        :string ->
          def get(key) do
            case Redix.command!(pid, ~w(GET #{key})) do
              nil -> nil
              val -> Poison.Parser.parse!(val)
            end
          end
        :list ->
          def shift(key) do
            case Redix.command!(pid, ~w(LPOP #{key})) do
              nil -> nil
              val -> Poison.Parser.parse!(val)
            end
          end

          def all(key) do
            Redix.command!(pid, ~w(LRANGE #{key} 0 -1))
            |> Enum.map(&Poison.Parser.parse!(&1))
          end
      end
    end
  end
end
