defmodule Db.ChannelMember do
  use Cassandrax.Schema
  import Ecto.Changeset

  alias Db.{ChannelMember}

  @primary_key [:channel_id, :user_id]

  table "channel_members" do
    field(:channel_id, :integer)
    field(:user_id, :integer)
    field(:admin, :boolean)
    field(:broadcaster, :boolean)
  end

  def new(attrs) do
    permitted_attrs = [:channel_id, :user_id, :admin, :broadcaster]

    data =
      attrs
      |> Map.put(:admin, attrs[:admin] || false)
      |> Map.put(:broadcaster, attrs[:broadcaster] || false)

    cast(%ChannelMember{}, data, permitted_attrs)
    |> validate_required(permitted_attrs)
  end
end
