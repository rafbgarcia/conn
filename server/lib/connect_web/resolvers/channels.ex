defmodule ConnectWeb.Resolvers.Channels do
  def list(_parent, _args, %{context: %{current_user: user}}) do
    channels = Connect.channels_for(user)
    {:ok, channels}
  end

  def create(_parent, args, %{context: %{current_user: user}}) do
    attrs = Map.put(args, :owner_id, user.id)
    channel = Db.Channel.new(attrs) |> Db.Repo.insert!()
    Db.ChannelMember.new(%{channel_id: channel.id, user_id: user.id}) |> Db.Repo.insert!()
    {:ok, channel}
  end

  def create(_parent, _args, _resolutions), do: {:error, :unauthorized}
end
