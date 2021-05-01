defmodule Connect.Graphql.CreateMessageMutationTest do
  use ConnectWeb.ConnCase
  use ConnectWeb.AbsintheCase

  def scenario, do: "Create messages"

  test "users can create messages in channels they are members" do
    user = insert(:user)
    channel = insert(:channel)
    insert(:channel_member, channel_id: channel.id, user_id: user.id)

    query = """
    mutation {
      message: createMessage(channelId: "#{channel.id}", content: "Hello world") {
        id
        channelId
        authorId
        content
      }
    }
    """

    assert_response_matches(query, context: %{current_user: user}) do
      %{"message" => message}
    end

    assert is_binary(message["id"])
    assert is_binary(message["channelId"])
    assert message["content"] == "Hello world"
    assert message["authorId"] == user.id
  end

  test "users can create thread messages in channels they are members" do
    user = insert(:user)
    channel = insert(:channel)
    parent_message = insert(:message, channel_id: channel.id)
    insert(:channel_member, channel_id: channel.id, user_id: user.id)

    query = """
    mutation {
      message: createMessage(
        channelId: "#{parent_message.channel_id}",
        parentMessageId: "#{parent_message.id}",
        content: "Message inside a thread"
      ) {
        #{document_for(:message)}
      }
    }
    """

    assert_data_matches(query, context: %{current_user: user}) do
      %{"message" => message}
    end

    assert message["parentMessageId"] == "#{parent_message.id}"
    assert message["id"] != parent_message.id
    assert is_binary(message["id"])
    assert is_binary(message["channelId"])
    assert message["content"] == "Message inside a thread"
    assert message["authorId"] == user.id
  end

  test "users can't send thread messages in channels they are not members" do
    user = insert(:user)
    channel = insert(:channel)
    insert(:channel_member, channel_id: channel.id, user_id: user.id)
    # Message belongs to a channel that the user is not a member of
    diff_channel = insert(:channel)
    parent_message = insert(:message, channel_id: diff_channel.id)

    query = """
    mutation {
      message: createMessage(
        channelId: "#{channel.id}",
        parentMessageId: "#{parent_message.id}",
        content: "Hello"
      ) {
        id
      }
    }
    """

    assert_errors_equals(query, "unauthorized", context: %{current_user: user})
  end

  test "users can't send messages in channels they are not members" do
    user = insert(:user)
    channel = insert(:channel)

    query = """
    mutation {
      createMessage(channelId: "#{channel.id}", content: "Hello") {
        id
      }
    }
    """

    assert_errors_equals(query, "unauthorized", context: %{current_user: user})
  end

  test "non-authenticated users can't create messages" do
    query = """
    mutation {
      message: createMessage(channelId: "#{Db.Snowflake.new()}", content: "Hello world") {
        id
      }
    }
    """

    assert_errors_equals(query, "unauthorized")
  end
end
