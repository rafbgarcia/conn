defmodule Db.Channel do
  use Cassandrax.Schema
  import Ecto.Changeset

  alias Db.{Channel}

  @types %{
    private: 0,
    public: 1,
    broadcasting: 2,
    direct: 3,
    group: 4
  }

  @primary_key [:server_id, :id]

  table "channels" do
    field(:server_id, :integer)
    field(:id, :integer)
    field(:owner_id, :integer)
    field(:name, :string)
    field(:type, :integer)
  end

  def new(attrs) do
    permitted_attrs = [:server_id, :id, :owner_id, :name, :type]

    data =
      attrs
      |> Map.put(:id, Db.Snowflake.new())

    cast(%Channel{}, data, permitted_attrs)
    |> validate_required(permitted_attrs)
  end

  def types, do: @types
end
