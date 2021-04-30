defmodule Connect.Features.MessageThreadsTest do
  use ConnectWeb.ConnCase

  test "creates a message that points to another message" do
    parent_message = insert(:message)

    %{res: res, user: current_user} =
      gql("""
      mutation {
        message: createMessage(
          channelId: "#{parent_message.channel_id}",
          parentMessageId: "#{parent_message.id}",
          content: "Message inside a thread"
        ) {
          id
          channelId
          authorId
          content
          parentMessageId
        }
      }
      """)

    assert res["errors"] == nil

    message = res["data"]["message"]
    assert message["parentMessageId"] == "#{parent_message.id}"
    assert message["id"] != parent_message.id
    assert is_binary(message["id"])
    assert is_binary(message["channelId"])
    assert message["content"] == "Message inside a thread"
    assert message["authorId"] == current_user.id
  end

  test "fetch thread messages sorted by most recent" do
    message = insert(:message, content: "Parent")
    attrs = %{channel_id: message.channel_id, parent_message_id: message.id}

    insert(:thread_message, Map.put(attrs, :content, "msg 1"))
    insert(:thread_message, Map.put(attrs, :content, "msg 2"))
    insert(:thread_message, Map.put(attrs, :content, "msg 3"))

    %{res: res} =
      gql("""
      query {
        messages (channelId: "#{message.channel_id}") {
          id
          messages {
            id
            content
          }
        }
      }
      """)

    assert res["errors"] == nil

    messages = res["data"]["messages"]
    assert length(messages) == 1

    parent_message = Enum.at(messages, 0)
    assert length(parent_message["messages"]) == 3
    assert Enum.map(parent_message["messages"], & &1["content"]) == ["msg 3", "msg 2", "msg 1"]
  end
end
