defmodule Connect do
  import Cassandrax.Query

  alias Db.{Repo, Account, Message, ThreadMessage, User}

  def get_message(channel_id, message_id) do
    Message
    |> where(channel_id: channel_id)
    |> where(bucket: Message.bucket(Db.UUID.to_datetime(message_id)))
    |> where(id: message_id)
    |> allow_filtering()
    |> Repo.one()
  end

  def messages_for_channel(channel_id) do
    Message
    |> where(channel_id: channel_id)
    |> limit(50)
    |> allow_filtering
    |> Repo.all()
    # Need to sort in case it fetches data from different buckets
    |> Enum.sort_by(& &1.id)
    |> Enum.reverse()
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
