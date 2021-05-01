defmodule Connect.Graphql.CreateChannelMembersMutationTest do
  use Connect.IntegrationCase, truncate_tables: [:channel_members]
  use ConnectWeb.ConnCase

  test "add members to a channel" do
    current_user = insert(:user)
    channel_id = Db.Snowflake.new()
    member_ids = Enum.to_list(1..5) -- [current_user.id]

    query = """
    mutation {
      members: createMembers(
        channelId: "#{channel_id}",
        memberIds: [#{Enum.join(member_ids, ", ")}]
      ) {
        userId
        channelId
      }
    }
    """

    %{res: res} = gql(query, current_user: current_user)
    assert res["errors"] == nil
    members = res["data"]["members"]
    member_ids_with_current_user = member_ids ++ [current_user.id]
    db_rows = Db.Repo.all(Db.ChannelMember)

    assert Db.Repo.count(Db.ChannelMember) == length(member_ids_with_current_user)

    assert_all_have_value(members, "channelId", "#{channel_id}")
    assert_lists_equal(Enum.map(members, & &1["userId"]), member_ids_with_current_user)

    assert_all_have_value(db_rows, :channel_id, channel_id)
    assert_lists_equal(Enum.map(db_rows, & &1.user_id), member_ids_with_current_user)
  end
end
