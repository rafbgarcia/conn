defmodule Connect.ConnectTest do
  use ConnectWeb.ConnCase, async: true
  use Connect.IntegrationCase, truncate_tables: [:channels, :messages]

  describe ".channel_messages" do
    test "returns channel's messages" do
      channel_id = Db.Snowflake.new()
      insert(:message, channel_id: channel_id)
      insert(:message, channel_id: channel_id)

      messages = Connect.channel_messages(channel_id)
      assert Kernel.length(messages) == 2
    end

    test "sorts by latest messages, even when fetching from different buckets" do
      channel = insert(:channel, id: Db.Snowflake.gen_buckets_diff_id(1))

      Enum.each(0..6, fn i ->
        id = Db.Snowflake.gen_buckets_diff_id(floor(i / 3) + 1)

        insert(:message,
          channel_id: channel.id,
          content: "msg #{i}",
          author_id: 2,
          bucket: Db.Snowflake.bucket(id)
        )
      end)

      messages =
        Connect.channel_messages(channel.id, 5)
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

  test ".get_account" do
    account = insert(:account, password: "1234")

    db_account = Connect.get_account(account.server_id, account.login)
    assert db_account.login == account.login
    assert db_account.server_id == account.server_id
    assert db_account.user_id == account.user_id
    assert db_account.password == account.password
    assert Bcrypt.verify_pass("1234", db_account.password)
  end

  test ".channels_for" do
    user = insert(:user)
    channel1 = insert(:channel, server_id: user.server_id)
    channel2 = insert(:channel, server_id: user.server_id)
    insert(:channel)

    assert length(Connect.channels_for(user)) == 0

    insert(:channel_member, user_id: user.id, channel_id: channel1.id)
    insert(:channel_member, user_id: user.id, channel_id: channel2.id)
    assert length(Connect.channels_for(user)) == 2
  end

  test ".channel_member?" do
    user = insert(:user)
    channel = insert(:channel)

    assert Connect.channel_member?(channel.id, user.id) == false

    insert(:channel_member, user_id: user.id, channel_id: channel.id)
    assert Connect.channel_member?(channel.id, user.id) == true
  end

  test ".channel_message?" do
    channel = insert(:channel)
    message = insert(:message, channel_id: channel.id)

    assert Connect.channel_message?(channel.id, message.id + 1) == false
    assert Connect.channel_message?(channel.id, message.id) == true
  end

  test ".thread_messages" do
    parent_message = insert(:message)
    assert length(Connect.thread_messages(parent_message.id)) == 0

    for _ <- 1..10,
        do: insert(:thread_message, parent_message_id: parent_message.id)

    assert length(Connect.thread_messages(parent_message.id)) == 10
  end
end
