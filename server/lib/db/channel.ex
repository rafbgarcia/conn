defmodule Db.Channel do
  use Cassandrax.Schema
  import Ecto.Changeset

  alias Db.{Channel}

  @types ConnectWeb.Schema.__absinthe_type__(:channel_type).values
         |> Enum.reduce(%{}, fn {type, field}, acc ->
           Map.put(acc, type, field.value)
         end)

  @primary_key [:server_id, :id]

  table "channels" do
    field(:server_id, :integer)
    field(:id, :integer)
    field(:owner_id, :integer)
    field(:name, :string)
    field(:type, :string)
  end

  def new(attrs) do
    permitted_attrs = [:server_id, :id, :owner_id, :name, :type]

    data =
      attrs
      |> Map.put(:id, attrs[:id] || Db.Snowflake.new())

    cast(%Channel{}, data, permitted_attrs)
    |> validate_required(permitted_attrs)
    |> validate_inclusion(:type, Map.values(@types))
  end

  def types, do: @types
end
