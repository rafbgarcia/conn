defmodule ConnectWeb.LoginTest do
  alias Db.{Repo, Account, Channel, Server, User}
  use ConnectWeb.ConnCase

  describe "login" do
    test "succeeds when login and password match", %{conn: conn} do
      server = Repo.insert!(Server.new(%{name: "Power"}))
      user = Repo.insert!(User.new(%{id: 1, server_id: server.id, name: "Rafa"}))

      account =
        Repo.insert!(
          Account.new(%{server_id: server.id, user_id: user.id, login: "rafa", password: "1234"})
        )

      query = """
      mutation {
        login(serverId: "#{account.server_id}", login: "#{account.login}", password: "1234") {
          token
        }
      }
      """

      conn = post(conn, "/api", query: query)
      res = json_response(conn, 200)

      assert is_binary(get_in(res, ["data", "login", "token"]))
    end

    test "s" do
      server = Repo.insert!(Server.new(%{name: "Power"}))
      channel = Repo.insert!(Channel.new(%{server_id: server.id, name: "Rebels"}))
      current_user = Repo.insert!(User.new(%{id: 14497, server_id: server.id, name: "Rafa"}))

      account =
        Repo.insert!(
          Account.new(%{
            server_id: server.id,
            user_id: current_user.id,
            login: "rafa",
            password: "1234"
          })
        )

      query = """
      mutation {
        login(serverId: "#{account.server_id}", login: "#{account.login}", password: "1234") {
          token
        }
      }
      """

      conn = post(build_conn(), "/api", query: query)
      token = get_in(json_response(conn, 200), ["data", "login", "token"])

      # Create a message with the current user
      query = """
      mutation {
        message: createMessage(channelId: "#{channel.id}", content: "Hello world") {
          id
          content
          authorId
        }
      }
      """

      conn =
        build_conn()
        |> put_req_header("authorization", "Bearer #{token}")
        |> post("/api", query: query)

      %{"data" => %{"message" => message}} = json_response(conn, 200)
      assert message["authorId"] == current_user.id
    end
  end
end
