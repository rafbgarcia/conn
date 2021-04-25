defmodule Db.Channel do
  use Cassandrax.Schema
  import Ecto.Changeset

  alias Db.{UUID, Channel}

  @primary_key [[:server_id, :deleted], :id]

  table "channels" do
    field(:server_id, :string)
    field(:deleted, :boolean)
    field(:id, :string)
    field(:name, :string)
  end

  def new(attrs) do
    data =
      attrs
      |> Map.merge(%{
        id: UUID.timeuuid(),
        deleted: false
      })

    cast(%Channel{}, data, [
      :server_id,
      :deleted,
      :id,
      :name
    ])
  end
end
