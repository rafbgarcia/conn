defmodule Db.Account do
  use Cassandrax.Schema
  import Ecto.Changeset

  alias Db.{Account}

  @primary_key [:server_id, :login]

  table "accounts" do
    field(:server_id, :integer)
    field(:login, :string)
    field(:password, :string)
    field(:user_id, :integer)
  end

  def new(attrs) do
    attrs = Map.put(attrs, :password, Bcrypt.hash_pwd_salt(attrs.password))

    cast(%Account{}, attrs, [
      :server_id,
      :login,
      :password,
      :user_id
    ])
  end
end
