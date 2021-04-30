defmodule ConnectWeb.Schema.ScalarType do
  @moduledoc """
  Custom Scalar types
  """
  use Absinthe.Schema.Notation

  @desc """
  Represents a 64 bit number, appears in JSON responses as a
  UTF-8 String due to Javascript's lack of support for numbers > 53-bits.
  Its parsed again to an integer after received.
  """
  scalar :snowflake, name: "Snowflake" do
    serialize(&Integer.to_string/1)
    parse(&decode_exnowflake/1)
  end

  @spec decode_exnowflake(struct()) :: {:ok, integer()} | {:ok, nil} | :error
  defp decode_exnowflake(%Absinthe.Blueprint.Input.String{value: value}) do
    case Integer.parse(value) do
      {int, _} -> {:ok, int}
      _error -> :error
    end
  end

  defp decode_exnowflake(%Absinthe.Blueprint.Input.Integer{value: value}), do: {:ok, value}
  defp decode_exnowflake(%Absinthe.Blueprint.Input.Null{}), do: {:ok, nil}
  defp decode_exnowflake(_), do: :error
end
