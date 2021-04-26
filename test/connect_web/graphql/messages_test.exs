defmodule ConnectWeb.MessagesTest do
  alias Db.{Repo, Server, Channel, User}
  use ConnectWeb.ConnCase

  test "createMessage" do
    server = Repo.insert!(Server.new(%{name: "Power"}))
    channel = Repo.insert!(Channel.new(%{server_id: server.id, name: "Rebels"}))
    user = Repo.insert!(User.new(%{id: 14497, server_id: server.id, name: "Rafa"}))

    {:ok, token, _claims} =
      ConnectWeb.Guardian.encode_and_sign(%{user_id: user.id, server_id: user.server_id})

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

    conn =
      build_conn()
      |> put_req_header("authorization", "Bearer #{token}")
      |> post("/api", query: query)

    %{"data" => %{"message" => message}} = json_response(conn, 200)
    assert is_binary(message["id"])
    assert is_binary(message["channelId"])
    assert message["content"] == "Hello world"
    assert message["authorId"] == user.id
  end
end
