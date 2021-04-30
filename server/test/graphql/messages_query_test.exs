defmodule Connect.Graphql.MessagesQueryTest do
  use ConnectWeb.ConnCase

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
