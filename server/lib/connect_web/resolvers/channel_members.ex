defmodule ConnectWeb.Resolvers.ChannelMembers do
  def create(_parent, args, %{context: %{current_user: user}}) do
    members =
      (args.member_ids ++ [user.id])
      |> Enum.uniq()
      |> Enum.map(&%{user_id: &1, channel_id: args.channel_id})
      |> Enum.map(&Db.ChannelMember.new(&1))

    :ok =
      Db.Repo.batch(fn batch ->
        Enum.reduce(members, batch, fn member, batch ->
          Db.Repo.batch_insert(batch, member)
        end)
      end)

    {:ok, members |> Enum.map(& &1.changes)}
  end

  def create(_parent, _args, _resolutions), do: {:error, :unauthorized}
end
