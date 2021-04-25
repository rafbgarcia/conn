defmodule Db.Server do
  use Cassandrax.Schema
  import Ecto.Changeset

  alias Db.{UUID, Server}

  @primary_key [:id]

  table "servers" do
    field(:id, :string)
    field(:name, :string)
  end

  def new(attrs) do
    data =
      attrs
      |> Map.merge(%{
        id: UUID.uuid()
      })

    cast(%Server{}, data, [
      :id,
      :name
    ])
  end
end
