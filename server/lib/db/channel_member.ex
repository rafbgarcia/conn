defmodule Db.ChannelMember do
  use Cassandrax.Schema
  import Ecto.Changeset

  alias Db.{ChannelMember}

  @primary_key [:channel_id]

  table "channel_members" do
    field(:channel_id, :integer)
    field(:user_id, :integer)
  end

  def new(attrs) do
    permitted_attrs = [:channel_id, :user_id]

    cast(%ChannelMember{}, attrs, permitted_attrs)
    |> validate_required(permitted_attrs)
  end
end
