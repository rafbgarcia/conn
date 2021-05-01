defmodule Connect.LoginAndCreateMessageTest do
  use ConnectWeb.ConnCase

  test "access token returned by login works to authenticate upcoming requests" do
    # Login
    current_user = insert(:user)

    account =
      insert(:account,
        user_id: current_user.id,
        server_id: current_user.server_id,
        password: "123"
      )

    query = """
    mutation {
      login(serverId: "#{account.server_id}", login: "#{account.login}", password: "123") {
        token
      }
    }
    """

    res = non_auth_gql(query)
    assert res["errors"] == nil
    token = res["data"]["login"]["token"]

    # Successfuly authenticates the user
    channel = insert(:channel)
    insert(:channel_member, user_id: current_user.id, channel_id: channel.id)

    query = """
    mutation {
      message: createMessage(channelId: "#{channel.id}", content: "Hello world") {
        authorId
      }
    }
    """

    res = gql_with_token(query, token)
    assert res["errors"] == nil

    # Message belongs to curreent_user
    assert res["data"]["message"]["authorId"] == current_user.id
  end
end
