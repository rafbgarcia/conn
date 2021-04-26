defmodule Db.User do
  use Cassandrax.Schema
  import Ecto.Changeset

  alias Db.{User}

  @primary_key [:server_id, :id]

  table "users" do
    field(:server_id, :string)
    field(:id, :integer)
    field(:name, :string)
  end

  def new(attrs) do
    cast(%User{}, attrs, [
      :server_id,
      :id,
      :name
    ])
  end
end
