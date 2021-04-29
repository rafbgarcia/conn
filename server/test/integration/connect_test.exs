defmodule ConnectTest do
  use ConnectWeb.ConnCase, async: true

  describe ".messages_for_channel" do
    test "returns channel's messages" do
      channel_id = Db.UUID.uuid()
      insert(:message, channel_id: channel_id)
      insert(:message, channel_id: channel_id)

      messages = Connect.messages_for_channel(channel_id)
      assert Kernel.length(messages) == 2
    end

    test "messages order when fetching from different buckets" do
      bucket = fn i ->
        case i do
          n when n <= 2 -> "20201"
          n when n <= 4 -> "20202"
          n when n <= 6 -> "20211"
          _ -> "20212"
        end
      end

      channel_id = Db.UUID.uuid()

      Enum.each(0..8, fn i ->
        build(:message, channel_id: channel_id, content: "msg #{i}", author_id: 2)
        |> Map.put(:bucket, bucket.(i))
        |> insert
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
    account = insert(:account, password: "1234")

    db_account = Connect.get_account(account.server_id, account.login)
    assert db_account.login == account.login
    assert db_account.server_id == account.server_id
    assert db_account.user_id == account.user_id
    assert db_account.password == account.password
    assert Bcrypt.verify_pass("1234", db_account.password)
  end
end
