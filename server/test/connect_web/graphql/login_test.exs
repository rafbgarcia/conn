defmodule ConnectWeb.LoginTest do
  use ConnectWeb.ConnCase
  import Connect.Factories

  def login(wrong_pass \\ false) do
    user = insert(:user)
    account = insert(:account, user_id: user.id, server_id: user.server_id, password: "1234")
    password = (wrong_pass && "wrong pass") || "1234"

    query = """
    mutation {
      login(serverId: "#{account.server_id}", login: "#{account.login}", password: "#{password}") {
        token
      }
    }
    """

    build_conn()
    |> post("/api", query: query)
    |> json_response(200)
  end

  test "succeeds for valid credentials" do
    res = login()

    assert res["errors"] == nil
    assert is_binary(res["data"]["login"]["token"])
  end

  test "fails for invalid credentials" do
    res = login(true)

    assert res["errors"] == [
             %{
               "locations" => [%{"column" => 3, "line" => 2}],
               "message" => "unauthorized",
               "path" => ["login"]
             }
           ]
  end
end
