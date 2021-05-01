defmodule Connect.Graphql.MessagesQueryTest do
  use ConnectWeb.AbsintheCase

  def scenario, do: "Fetch a channel's messages"

  test "returns the last 50 messages of the channel" do
    user = insert(:user)
    channel = insert(:channel)
    insert(:channel_member, user_id: user.id, channel_id: channel.id)
    for i <- 1..75, do: insert(:message, channel_id: channel.id, content: "Msg #{i}")

    query = """
    query {
      messages (channelId: "#{channel.id}") {
        #{document_for(:message)}
      }
    }
    """

    assert_data_matches(query, context: %{current_user: user}) do
      %{"messages" => messages}
    end

    assert length(messages) == 50
    assert Enum.map(messages, & &1["content"]) == Enum.map(75..26, &"Msg #{&1}")
    assert Enum.at(messages, 0)["__typename"] == "Message"
    assert is_integer(Enum.at(messages, 0)["authorId"])
    assert Enum.at(messages, 0)["channelId"] == "#{channel.id}"
    assert Enum.at(messages, 0)["content"] == "Msg 75"
    assert is_binary(Enum.at(messages, 0)["createdAt"])
    assert Enum.at(messages, 0)["edited"] == false
    assert Enum.at(messages, 0)["editedAt"] == nil
    assert is_binary(Enum.at(messages, 0)["id"])
    assert Enum.at(messages, 0)["parentMessageId"] == nil
  end

  test "user must be a member of the channel to see messages" do
    user = insert(:user)

    query = """
    query {
      messages (channelId: "#{Db.Snowflake.new()}") {
        id
      }
    }
    """

    assert_errors_equals(query, "unauthorized", context: %{current_user: user})
  end
end
