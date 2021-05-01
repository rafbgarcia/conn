defmodule ConnectWeb.AbsintheCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Assertions.AbsintheCase, async: true, schema: ConnectWeb.Schema
      import Connect.Factory

      def run(document, opts \\ []) do
        {:ok, %{data: response}} = Absinthe.run(document, ConnectWeb.Schema, opts)
        response
      end
    end
  end
end
