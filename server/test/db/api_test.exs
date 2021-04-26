defmodule Db.ApiTest do
  use ConnectWeb.ConnCase, async: true

  alias Db.{Repo, Account, Message}

  describe ".messages_for_channel" do
    test "returns channel's messages" do
      message = %{channel_id: UUID.uuid1(), content: "hey", author_id: 2}
      Repo.insert!(Message.new(message))
      Repo.insert!(Message.new(message))

      messages = Connect.messages_for_channel(message.channel_id)
      assert Kernel.length(messages) == 2
    end

    def bucket(i) do
      case i do
        n when n <= 2 -> "20201"
        n when n <= 4 -> "20202"
        n when n <= 6 -> "20211"
        _ -> "20212"
      end
    end

    test "messages order when fetching from different buckets" do
      channel_id = UUID.uuid1()

      Enum.each(0..8, fn i ->
        message = Message.new(%{channel_id: channel_id, content: "msg #{i}", author_id: 2})
        message = struct(Message, Map.put(message.changes, :bucket, bucket(i)))
        Repo.insert!(message)
      end)

      messages =
        Connect.messages_for_channel(channel_id)
        |> Enum.map(&{&1.bucket, &1.content})

      assert messages == [
               {"20212", "msg 8"},
               {"20212", "msg 7"},
               {"20211", "msg 6"},
               {"20211", "msg 5"},
               {"20202", "msg 4"},
               {"20202", "msg 3"},
               {"20201", "msg 2"},
               {"20201", "msg 1"},
               {"20201", "msg 0"}
             ]
    end
  end

  test "fetches account from the db" do
    account =
      Repo.insert!(
        Account.new(%{server_id: Db.UUID.uuid(), user_id: 123, login: "rafa", password: "1234"})
      )

    db_account = Connect.get_account(account.server_id, account.login)
    assert db_account.login == account.login
    assert db_account.server_id == account.server_id
    assert db_account.user_id == account.user_id
    assert db_account.password == account.password
    assert Bcrypt.verify_pass("1234", db_account.password)
  end
end
