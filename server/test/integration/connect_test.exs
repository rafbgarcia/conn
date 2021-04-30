defmodule ConnectTest do
  use ConnectWeb.ConnCase, async: true
  use Connect.IntegrationCase, truncate_tables: [:channels, :messages]

  describe ".messages_for_channel" do
    test "returns channel's messages" do
      channel_id = build(:channel).id
      insert(:message, channel_id: channel_id)
      insert(:message, channel_id: channel_id)

      messages = Connect.messages_for_channel(channel_id)
      assert Kernel.length(messages) == 2
    end

    test "ensure messages order when fetching from different buckets" do
      channel = build(:channel) |> Map.put(:id, Db.Snowflake.gen_buckets_diff_id(1)) |> insert

      Enum.each(0..6, fn i ->
        id = Db.Snowflake.gen_buckets_diff_id(floor(i / 3) + 1)

        build(:message, channel_id: channel.id, content: "msg #{i}", author_id: 2)
        |> Map.put(:bucket, Db.Snowflake.bucket(id))
        |> insert
      end)

      messages =
        Connect.messages_for_channel(channel.id, 5)
        |> Enum.map(&{&1.bucket, &1.content})

      assert messages == [
               {3, "msg 6"},
               {2, "msg 5"},
               {2, "msg 4"},
               {2, "msg 3"},
               {1, "msg 2"}
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
