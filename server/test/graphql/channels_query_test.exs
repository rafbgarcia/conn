defmodule Connect.Graphql.ChannelsQueryTest do
  use Connect.IntegrationCase, truncate_tables: [:channels, :channel_members]
  use ConnectWeb.AbsintheCase

  def scenario, do: "Get current user's channels"

  def query do
    """
    query {
      channels {
        #{document_for(:channel)}
      }
    }
    """
  end

  test "returns channels that the user is a member of" do
    server_id = Db.Snowflake.new()
    user = insert(:user, server_id: server_id)

    channel1 =
      insert(:channel, server_id: server_id, user_id: user.id, name: "Rebels", type: "PRIVATE")

    insert(:channel, server_id: server_id, user_id: user.id, name: "Gabe", type: "DIRECT")

    channel3 =
      insert(:channel, server_id: server_id, user_id: user.id, name: "Gabe", type: "DIRECT")

    insert(:channel_member, channel_id: channel1.id, user_id: user.id)
    insert(:channel_member, channel_id: channel3.id, user_id: user.id)

    assert_data_matches(query(), context: %{current_user: user}) do
      %{"channels" => channels}
    end

    assert_lists_equal(Enum.map(channels, & &1["id"]), [
      "#{channel1.id}",
      "#{channel3.id}"
    ])

    assert_lists_equal(Enum.map(channels, & &1["name"]), ["Rebels", "Gabe"])
  end

  test "returns empty when the user has no channels" do
    user = insert(:user)

    assert_data_matches(query(), context: %{current_user: user}) do
      %{"channels" => []}
    end
  end
end
