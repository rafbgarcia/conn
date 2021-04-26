defmodule ConnectWeb.LoginAndAuthTest do
  @moduledoc """
  Tests the user flow of logging in and making an authenticated request.

  * Logs in
  * Creates a message with token sent via the authorization header
  """

  import Connect.Factories
  use ConnectWeb.ConnCase

  def login do
    user = insert(:user)
    account = insert(:account, user_id: user.id, server_id: user.server_id, password: "123")

    query = """
    mutation {
      login(serverId: "#{account.server_id}", login: "#{account.login}", password: "123") {
        token
      }
    }
    """

    res = build_conn() |> post("/api", query: query) |> json_response(200)
    assert res["errors"] == nil
    {res["data"]["login"]["token"], user}
  end

  def create_message(token) do
    query = """
    mutation {
      message: createMessage(channelId: "#{Db.UUID.uuid()}", content: "Hello world") {
        id
        content
        authorId
      }
    }
    """

    res =
      build_conn()
      |> put_req_header("authorization", "Bearer #{token}")
      |> post("/api", query: query)
      |> json_response(200)

    res["data"]["message"]
  end

  test "login and creating a message with the current user" do
    {token, current_user} = login()
    message = create_message(token)

    assert message["authorId"] == current_user.id
  end
end
