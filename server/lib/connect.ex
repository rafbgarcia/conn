defmodule Connect do
  import Cassandrax.Query

  alias Db.{Repo, Account, Message, ThreadMessage, User}

  def get_message(channel_id, message_id) do
    Message
    |> where(channel_id: channel_id)
    |> where(bucket: Db.Snowflake.bucket(message_id))
    |> where(id: message_id)
    |> Repo.one()
  end

  def messages_for_channel(channel_id, limit \\ 50) do
    Db.Snowflake.bucket_range(channel_id)
    |> Enum.reduce_while([], fn bucket, messages ->
      if length(messages) < limit do
        next_messages =
          Message
          |> where(channel_id: channel_id)
          |> where(bucket: bucket)
          |> limit(limit - length(messages))
          |> Repo.all()

        {:cont, messages ++ next_messages}
      else
        {:halt, messages}
      end
    end)
  end

  def thread_messages(message_id) do
    ThreadMessage
    |> where(parent_message_id: message_id)
    |> limit(25)
    |> Repo.all()
  end

  def get_user(server_id, id) do
    User
    |> where(server_id: server_id)
    |> where(id: id)
    |> Repo.one()
  end

  def get_account(server_id, login) do
    Account
    |> where(server_id: server_id)
    |> where(login: login)
    |> Repo.one()
  end
end
