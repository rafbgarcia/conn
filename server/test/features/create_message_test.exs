defmodule Connect.Features.MessageThreads do
  use ConnectWeb.ConnCase

  test "Creates a message for the current user in a given channel" do
    query = """
    mutation {
      message: createMessage(channelId: "#{UUID.uuid1()}", content: "Hello world") {
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
end
