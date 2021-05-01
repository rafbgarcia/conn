defmodule Connect.Graphql.CreateChannelMembersMutationTest do
  use Connect.IntegrationCase, truncate_tables: [:channel_members]
  use ConnectWeb.AbsintheCase

  test "add members to a channel" do
    user = insert(:user)
    channel_id = Db.Snowflake.new()
    member_ids = Enum.to_list(1..5) -- [user.id]

    query = """
    mutation {
      members: createMembers(
        channelId: "#{channel_id}",
        memberIds: [#{Enum.join(member_ids, ", ")}]
      ) {
        #{document_for(:member)}
      }
    }
    """

    assert_data_matches(query, context: %{current_user: user}) do
      %{"members" => members}
    end

    member_ids_with_current_user = member_ids ++ [user.id]
    db_rows = Db.Repo.all(Db.ChannelMember)

    assert Db.Repo.count(Db.ChannelMember) == length(member_ids_with_current_user)

    assert_all_have_value(members, "channelId", "#{channel_id}")
    assert_lists_equal(Enum.map(members, & &1["userId"]), member_ids_with_current_user)

    assert_all_have_value(db_rows, :channel_id, channel_id)
    assert_lists_equal(Enum.map(db_rows, & &1.user_id), member_ids_with_current_user)
  end
end
