defmodule Db.User do
  use Cassandrax.Schema
  import Ecto.Changeset

  alias Db.{User}

  @primary_key [:server_id, :id]

  table "users" do
    field(:server_id, :integer)
    field(:id, :integer)
    field(:name, :string)
  end

  def new(attrs) do
    %User{}
    |> cast(attrs, [
      :server_id,
      :id,
      :name
    ])
    |> validate_required([:server_id, :id])
  end
end
