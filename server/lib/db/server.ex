defmodule Db.Server do
  use Cassandrax.Schema
  import Ecto.Changeset

  alias Db.{Server}

  @primary_key [:id]

  table "servers" do
    field(:id, :integer)
    field(:name, :string)
  end

  def new(attrs) do
    data =
      attrs
      |> Map.put(:id, Db.Snowflake.new())

    cast(%Server{}, data, [
      :id,
      :name
    ])
  end
end
