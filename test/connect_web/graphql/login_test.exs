defmodule ConnectWeb.LoginTest do
  alias Db.{Repo, Account, Server, User}
  use ConnectWeb.ConnCase

  def login(wrong_pass \\ false) do
    server = Repo.insert!(Server.new(%{name: "Power"}))
    user = Repo.insert!(User.new(%{id: 1, server_id: server.id, name: "Rafa"}))
    pass = "1234"

    account =
      Repo.insert!(
        Account.new(%{server_id: server.id, user_id: user.id, login: "rafa", password: pass})
      )

    password = (wrong_pass && "wrong pass") || pass

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
    assert res["errors"] != nil

    assert res["errors"] == [
             %{
               "locations" => [%{"column" => 3, "line" => 2}],
               "message" => "unauthorized",
               "path" => ["login"]
             }
           ]
  end
end
