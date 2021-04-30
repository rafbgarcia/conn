defmodule Connect.EdgeCases.LoginTest do
  use ConnectWeb.ConnCase

  test "fails for invalid password" do
    account = insert(:account, password: "1234")

    query = """
    mutation {
      login(serverId: "#{account.server_id}", login: "#{account.login}", password: "invalid") {
        token
      }
    }
    """

    res = non_auth_gql(query)

    assert Enum.at(res["errors"], 0)["message"] == "unauthorized"
  end

  test "access token returned by login works to authenticate upcoming requests" do
    login = fn ->
      user = insert(:user)
      account = insert(:account, user_id: user.id, server_id: user.server_id, password: "123")

      query = """
      mutation {
        login(serverId: "#{account.server_id}", login: "#{account.login}", password: "123") {
          token
        }
      }
      """

      res = non_auth_gql(query)

      assert res["errors"] == nil
      assert res["data"]["login"]["token"] != nil
      {res["data"]["login"]["token"], user}
    end

    create_message = fn token ->
      query = """
      mutation {
        message: createMessage(channelId: "#{Db.Snowflake.new()}", content: "Hello world") {
          id
          content
          authorId
        }
      }
      """

      res = gql_with_token(query, token)
      assert res["errors"] == nil
      res["data"]["message"]
    end

    # Given a logged in user
    {token, current_user} = login.()

    # When a message is created using his token
    message = create_message.(token)

    # The message should belong to him
    assert message["authorId"] == current_user.id
  end
end
