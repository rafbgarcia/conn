defmodule ConnectWeb.CreateMessageTest do
  use ConnectWeb.ConnCase
  import Connect.Factories

  test "creates a message for the current user" do
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

    {token, user, _} = jwt()

    message =
      build_conn()
      |> put_req_header("authorization", "Bearer #{token}")
      |> post("/api", query: query)
      |> json_response(200)
      |> get_in(["data", "message"])

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
