defmodule Connect.Graphql.EditMessageMutationTest do
  use ConnectWeb.AbsintheCase

  def scenario, do: "Edit messages"

  test "users can edit their own messages" do
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

    assert_data_matches(query, context: %{current_user: user}) do
      %{"message" => edited_message}
    end

    assert is_binary(edited_message["id"])
    assert is_binary(edited_message["channelId"])
    assert edited_message["content"] == "Hello"
    assert edited_message["authorId"] == user.id
    assert edited_message["edited"] == true
    assert is_binary(edited_message["editedAt"])
  end

  test "users can't edit others' messages" do
    user = insert(:user)
    message = insert(:message, author_id: user.id + 1, content: "Hey")

    query = """
    mutation {
      message: editMessage(
        channelId: "#{message.channel_id}",
        messageId: "#{message.id}",
        content: "Hello"
      ) {
        id
      }
    }
    """

    assert_errors_equals(query, "unauthorized", context: %{current_user: user})
  end
end
