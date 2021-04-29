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
    assert message["parentMessageId"] == parent_message.id
    assert message["id"] != parent_message.id
    assert is_binary(message["id"])
    assert is_binary(message["channelId"])
    assert message["content"] == "Message inside a thread"
    assert message["authorId"] == current_user.id
  end
end
