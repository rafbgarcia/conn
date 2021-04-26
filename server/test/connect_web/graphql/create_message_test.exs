defmodule ConnectWeb.CreateMessageTest do
  alias Db.{Repo, User}
  use ConnectWeb.ConnCase

  test "creates a message for the current user" do
    user = Repo.insert!(User.new(%{id: 14497, server_id: UUID.uuid1(), name: "Rafa"}))

    {:ok, token, _claims} =
      ConnectWeb.Guardian.encode_and_sign(%{user_id: user.id, server_id: user.server_id})

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

    res =
      build_conn()
      |> put_req_header("authorization", "Bearer #{token}")
      |> post("/api", query: query)
      |> json_response(200)

    message = res["data"]["message"]
    assert is_binary(message["id"])
    assert is_binary(message["channelId"])
    assert message["content"] == "Hello world"
    assert message["authorId"] == user.id
  end

  test "fails when for unauthorized users" do
    query = """
    mutation {
      message: createMessage(channelId: "#{UUID.uuid1()}", content: "Hello world") {
        id
      }
    }
    """

    res =
      build_conn()
      |> put_req_header("authorization", "Bearer invalid")
      |> post("/api", query: query)
      |> json_response(200)

    assert res["errors"] == [
             %{
               "locations" => [%{"column" => 3, "line" => 2}],
               "message" => "unauthorized",
               "path" => ["message"]
             }
           ]
  end
end
