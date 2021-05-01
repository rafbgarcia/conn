defmodule Connect.Graphql.LoginMutationTest do
  use ConnectWeb.AbsintheCase

  def scenario, do: "User Login"

  test "returns the access token, used to identify the user on upcoming requests" do
    account = insert(:account, password: "1234")

    query = """
    mutation {
      account: login(serverId: "#{account.server_id}", login: "#{account.login}", password: "1234") {
        token
      }
    }
    """

    assert_response_matches(query) do
      %{"account" => %{"token" => token}}
    end

    assert is_binary(token)
  end

  test "returns an error when user's password is incorrect" do
    account = insert(:account, password: "1234")

    query = """
    mutation {
      login(serverId: "#{account.server_id}", login: "#{account.login}", password: "invalid") {
        token
      }
    }
    """

    assert_errors_equals(query, "unauthorized")
  end
end
