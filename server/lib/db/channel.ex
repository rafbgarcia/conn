defmodule Db.Channel do
  use Cassandrax.Schema
  import Ecto.Changeset

  alias Db.{Channel}

  @primary_key [[:server_id, :deleted], :id]

  table "channels" do
    field(:server_id, :integer)
    field(:deleted, :boolean)
    field(:id, :integer)
    field(:name, :string)
  end

  def new(attrs) do
    data =
      attrs
      |> Map.put(:id, Db.Snowflake.new())
      |> Map.put(:deleted, false)

    cast(%Channel{}, data, [
      :server_id,
      :deleted,
      :id,
      :name
    ])
  end
end
