defmodule Connect do
  import Cassandrax.Query

  def get_message(channel_id, message_id) do
    Db.Message
    |> where(channel_id: channel_id)
    |> where(bucket: Db.Snowflake.bucket(message_id))
    |> where(id: message_id)
    |> Db.Repo.one()
  end

  def channels_for(user, limit \\ 50) do
    Db.ChannelMember
    |> select([:channel_id])
    |> where(user_id: user.id)
    |> limit(limit)
    |> Db.Repo.all()
    |> case do
      [] ->
        []

      channel_members ->
        channel_ids = Enum.map(channel_members, & &1.channel_id)

        Db.Channel
        |> where(server_id: user.server_id)
        |> where(id: channel_ids)
        |> Db.Repo.all()
    end
  end

  def channel_messages(channel_id, limit \\ 50) do
    Db.Snowflake.bucket_range(channel_id)
    |> Enum.reduce_while([], fn bucket, messages ->
      if length(messages) < limit do
        next_messages =
          Db.Message
          |> where(channel_id: channel_id)
          |> where(bucket: bucket)
          |> limit(limit - length(messages))
          |> Db.Repo.all()

        {:cont, messages ++ next_messages}
      else
        {:halt, messages}
      end
    end)
  end

  def thread_messages(message_id) do
    Db.ThreadMessage
    |> where(parent_message_id: message_id)
    |> limit(25)
    |> Db.Repo.all()
  end

  def get_user(server_id, id) do
    Db.User
    |> where(server_id: server_id)
    |> where(id: id)
    |> Db.Repo.one()
  end

  def get_account(server_id, login) do
    Db.Account
    |> where(server_id: server_id)
    |> where(login: login)
    |> Db.Repo.one()
  end

  def channel_member?(channel_id, user_id) do
    Db.ChannelMember
    |> where(channel_id: channel_id)
    |> where(user_id: user_id)
    |> Db.Repo.count() > 0
  end

  def channel_message?(channel_id, message_id) do
    Db.Message
    |> where(channel_id: channel_id)
    |> where(bucket: Db.Snowflake.bucket(message_id))
    |> where(id: message_id)
    |> Db.Repo.count() > 0
  end

  def channel_admin?(channel_id, user_id) do
    Db.ChannelMember
    |> where(channel_id: channel_id)
    |> where(user_id: user_id)
    |> Db.Repo.one()
    |> case do
      nil -> false
      member -> member.admin
    end
  end
end
