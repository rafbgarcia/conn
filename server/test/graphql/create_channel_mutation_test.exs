defmodule Connect.Graphql.CreateChannelMutationTest do
  use ConnectWeb.ConnCase

  test "creates a private channel" do
    server_id = Db.Snowflake.new()

    query = """
    mutation {
      channel: createChannel(
        serverId: "#{server_id}",
        name: "Rebels",
        type: #{Db.Channel.types().private}
      ) {
        id
        serverId
        name
        type
        ownerId
      }
    }
    """

    %{res: res, user: current_user} = gql(query)
    assert res["errors"] == nil

    channel = res["data"]["channel"]
    assert is_binary(channel["id"])
    assert channel["serverId"] == "#{server_id}"
    assert channel["name"] == "Rebels"
    assert channel["ownerId"] == current_user.id
    assert channel["type"] == Db.Channel.types().private
  end
end
