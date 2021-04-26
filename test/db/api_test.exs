defmodule Db.ApiTest do
  use ConnectWeb.ConnCase, async: true

  alias Db.{Account, Message, Api}

  describe ".messages_for_channel" do
    test "returns channel's messages" do
      message = %{channel_id: UUID.uuid1(), content: "hey", author_id: 2}
      Db.Repo.insert!(Message.new(message))
      Db.Repo.insert!(Message.new(message))

      messages = Api.messages_for_channel(message.channel_id)
      assert Kernel.length(messages) == 2
    end
  end

  test "fetches account from the db" do
    account =
      Db.Repo.insert!(
        Account.new(%{server_id: UUID.uuid1(), user_id: 123, login: "rafa", password: "1234"})
      )

    db_account = Api.get_account(account.server_id, account.login)
    assert db_account.login == account.login
    assert db_account.server_id == account.server_id
    assert db_account.user_id == account.user_id
    assert db_account.password == account.password
    assert Bcrypt.verify_pass("1234", db_account.password)
  end
end
