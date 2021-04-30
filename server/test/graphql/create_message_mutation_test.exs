defmodule Connect.Graphql.CreateMessageMutationTest do
  use ConnectWeb.ConnCase

  test "Creates a message for the current user in a given channel" do
    query = """
    mutation {
      message: createMessage(channelId: "#{Db.Snowflake.new()}", content: "Hello world") {
        id
        channelId
        authorId
        content
      }
    }
    """

    %{res: res, user: current_user} = gql(query)

    message = res["data"]["message"]
    assert is_binary(message["id"])
    assert is_binary(message["channelId"])
    assert message["content"] == "Hello world"
    assert message["authorId"] == current_user.id
  end

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

  test "fails when for unauthorized users" do
    query = """
    mutation {
      message: createMessage(channelId: "#{Db.Snowflake.new()}", content: "Hello world") {
        id
      }
    }
    """

    res = gql_with_token(query, "invalid")

    assert Enum.at(res["errors"], 0)["message"] == "unauthorized"
  end

  test "checks if user has access to the channel" do
  end
end
