defmodule Db.ApiTest do
  use ConnectWeb.ConnCase, async: true
  use IntegrationCase, truncate_tables: [:messages, :accounts, :servers, :users]

  alias Db.{Account, Server, User, Message, UUID, Api}

  describe ".messages_for_channel" do
    test "returns channel's messages" do
      message = %{channel_id: UUID.uuid(), content: "hey", author_id: 2}
      Db.Repo.insert!(Message.new(message))
      Db.Repo.insert!(Message.new(message))

      messages = Api.messages_for_channel(message.channel_id)
      assert Kernel.length(messages) == 2
    end
  end

  test "fetches account from the db" do
    server = Db.Repo.insert!(Server.new(%{name: "Power"}))
    user = Db.Repo.insert!(User.new(%{id: 1, server_id: server.id, name: "Rafa"}))

    account =
      Db.Repo.insert!(
        Account.new(%{server_id: server.id, user_id: user.id, login: "rafa", password: "1234"})
      )

    db_account = Api.get_account(account.server_id, account.login)
    assert db_account.login == account.login
    assert db_account.server_id == account.server_id
  end
end
