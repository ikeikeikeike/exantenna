defmodule Exantenna.Redises.Redis do
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

    end
  end
end
