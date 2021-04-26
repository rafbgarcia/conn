defmodule Connect do
  import Cassandrax.Query

  alias Db.{Repo, Account, Message, User}

  def messages_for_channel(channel_id) do
    Message
    |> where(channel_id: channel_id)
    |> limit(50)
    |> allow_filtering
    |> Repo.all()
    |> Enum.sort_by(& &1.id)
    |> Enum.reverse()
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
