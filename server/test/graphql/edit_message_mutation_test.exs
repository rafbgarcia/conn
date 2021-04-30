defmodule Connect.Graphql.EditMessageMutationTest do
  use ConnectWeb.ConnCase

  test "Edits a message" do
    user = insert(:user)
    message = insert(:message, author_id: user.id, content: "Hey")

    query = """
    mutation {
      message: editMessage(
        channelId: "#{message.channel_id}",
        messageId: "#{message.id}",
        content: "Hello"
      ) {
        id
        channelId
        authorId
        content
        edited
        editedAt
      }
    }
    """

    %{res: res} = gql(query, current_user: user)

    edited_message = res["data"]["message"]

    assert res["errors"] == nil
    assert is_binary(edited_message["id"])
    assert is_binary(edited_message["channelId"])
    assert edited_message["content"] == "Hello"
    assert edited_message["authorId"] == user.id
    assert edited_message["edited"] == true
    assert is_binary(edited_message["editedAt"])
  end
end
