defmodule ConnectWeb.Schema.ScalarTypes do
  @moduledoc """
  Custom Scalar types
  """
  use Absinthe.Schema.Notation

  @desc """
  Represents a 64 bit number, appears in JSON responses as a
  UTF-8 String due to Javascript's lack of support for numbers > 53-bits.
  Its parsed again to an integer after received.
  """
  scalar :bigint, name: "Bigint" do
    serialize(&Integer.to_string/1)
    parse(&decode_bigint/1)
  end

  @spec decode_bigint(struct()) :: {:ok, integer()} | {:ok, nil} | :error
  defp decode_bigint(%Absinthe.Blueprint.Input.String{value: value}) do
    case Integer.parse(value) do
      {int, _} -> {:ok, int}
      _error -> :error
    end
  end

  defp decode_bigint(%Absinthe.Blueprint.Input.Integer{value: value}), do: {:ok, value}
  defp decode_bigint(%Absinthe.Blueprint.Input.Null{}), do: {:ok, nil}
  defp decode_bigint(_), do: :error
end
