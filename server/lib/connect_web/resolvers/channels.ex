defmodule ConnectWeb.Resolvers.Channels do
  def list(_parent, args, _resolution) do
    channels = [%{id: "a99c76f9-4d43-4125-94ba-4c6bddbcf370", name: args.name}]
    {:ok, channels}
  end

  def create(_parent, args, %{context: %{current_user: user}}) do
    attrs = Map.put(args, :owner_id, user.id)
    channel = Db.Channel.new(attrs) |> Db.Repo.insert!()
    {:ok, channel}
  end

  def create(_parent, args, _resolutions), do: {:error, :unauthorized}
end
