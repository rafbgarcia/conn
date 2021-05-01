defmodule ConnectWeb.AbsintheCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Assertions.AbsintheCase, async: true, schema: ConnectWeb.Schema
      import Connect.Factory

      def run(document, opts \\ []) do
        {:ok, %{data: data}} = Absinthe.run(document, ConnectWeb.Schema, opts)
        data
      end

      defmacro assert_data_matches(document, options \\ [], do: expr) do
        quote do
          {:ok, data} = Absinthe.run(unquote(document), ConnectWeb.Schema, unquote(options))
          ExUnit.Assertions.assert(data[:errors] == nil)
          ExUnit.Assertions.assert(%{data: unquote(expr)} = data)
        end
      end

      def assert_errors_equals(document, expected, options \\ [])

      def assert_errors_equals(document, expected, options) when is_list(expected) do
        ExUnit.Assertions.assert(error_messages(document, options) == expected)
      end

      def assert_errors_equals(document, expected, options) when is_binary(expected) do
        messages = error_messages(document, options)
        ExUnit.Assertions.assert(length(messages) == 1)
        ExUnit.Assertions.assert(messages == [expected])
      end

      defp error_messages(document, options) do
        {:ok, %{errors: errors}} = Absinthe.run(document, ConnectWeb.Schema, options)
        error_messages = Enum.map(errors, & &1.message)
      end
    end
  end
end
