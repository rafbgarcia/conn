defmodule Connect.Graphql.ThreadMessagesQueryTest do
  use ConnectWeb.AbsintheCase

  def scenario, do: "Fetch messages of a thread"

  test "returns the last 25 messages of a thread" do
    user = insert(:user)
    channel = insert(:channel)
    insert(:channel_member, user_id: user.id, channel_id: channel.id)
    parent_message = insert(:message, channel_id: channel.id, content: "Parent")

    for i <- 1..50,
        do:
          insert(:thread_message,
            channel_id: channel.id,
            parent_message_id: parent_message.id,
            content: "Msg #{i}"
          )

    query = """
    query {
      threadMessages(channelId: "#{channel.id}", parentMessageId: "#{parent_message.id}") {
        #{document_for(:message)}
      }
    }
    """

    assert_data_matches(query, context: %{current_user: user}) do
      %{"threadMessages" => messages}
    end

    assert length(messages) == 25
    assert Enum.map(messages, & &1["content"]) == Enum.map(50..26, &"Msg #{&1}")
    assert Enum.at(messages, 0)["__typename"] == "Message"
    assert is_integer(Enum.at(messages, 0)["authorId"])
    assert Enum.at(messages, 0)["channelId"] == "#{channel.id}"
    assert Enum.at(messages, 0)["content"] == "Msg 50"
    assert is_binary(Enum.at(messages, 0)["createdAt"])
    assert Enum.at(messages, 0)["edited"] == false
    assert Enum.at(messages, 0)["editedAt"] == nil
    assert is_binary(Enum.at(messages, 0)["id"])
    assert Enum.at(messages, 0)["parentMessageId"] == "#{parent_message.id}"
  end

  test "user must be a member of the channel to see thread messages" do
    user = insert(:user)
    channel = insert(:channel)
    parent_message = insert(:message, channel_id: channel.id, content: "Parent")

    query = """
    query {
      threadMessages (channelId: "#{channel.id}", parentMessageId: "#{parent_message.id}") {
        id
      }
    }
    """

    assert_errors_equals(query, "unauthorized", context: %{current_user: user})
  end
end
