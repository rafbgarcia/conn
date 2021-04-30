defmodule Db.Channel do
  use Cassandrax.Schema
  import Ecto.Changeset

  alias Db.{Channel}

  @primary_key [:user_id, :id]

  table "channels" do
    field(:user_id, :integer)
    field(:id, :integer)
    field(:name, :string)
  end

  def new(attrs) do
    data =
      attrs
      |> Map.put(:id, Db.Snowflake.new())

    cast(%Channel{}, data, [
      :user_id,
      :id,
      :name
    ])
    |> validate_required([:user_id, :id, :name])
  end
end
