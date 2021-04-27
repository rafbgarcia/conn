defmodule Connect.UserActions.LoginTest do
  use ConnectWeb.ConnCase

  test "returns access token" do
    account = insert(:account, password: "1234")

    query = """
    mutation {
      login(serverId: "#{account.server_id}", login: "#{account.login}", password: "1234") {
        token
      }
    }
    """

    res =
      build_conn()
      |> post("/api", query: query)
      |> json_response(200)

    assert res["errors"] == nil
    assert is_binary(res["data"]["login"]["token"])
  end
end
