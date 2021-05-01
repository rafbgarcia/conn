defmodule Connect.Graphql.CreateChannelMembersMutationTest do
  use Connect.IntegrationCase, truncate_tables: [:channel_members]
  use ConnectWeb.AbsintheCase

  def scenario, do: "Add members to a channel"

  test "admins can add members" do
    user = insert(:user)
    channel = insert(:channel)
    insert(:channel_member, channel_id: channel.id, user_id: user.id, admin: true)
    new_member_ids = Enum.to_list(20_000..20_001)

    query = """
    mutation {
      members: createMembers(
        channelId: "#{channel.id}",
        memberIds: [#{Enum.join(new_member_ids, ", ")}]
      ) {
        #{document_for(:member)}
      }
    }
    """

    assert_data_matches(query, context: %{current_user: user}) do
      %{"members" => members}
    end

    assert Enum.map(members, &{&1["channelId"], &1["userId"], &1["admin"], &1["broadcaster"]}) ==
             [{"#{channel.id}", 20000, false, false}, {"#{channel.id}", 20001, false, false}]

    db_rows =
      Db.Repo.all(Db.ChannelMember)
      |> Enum.map(&{&1.channel_id, &1.user_id, &1.admin, &1.broadcaster})

    assert db_rows == [
             {channel.id, user.id, true, false},
             {channel.id, 20000, false, false},
             {channel.id, 20001, false, false}
           ]
  end

  test "non-admins can't add members" do
    user = insert(:user)
    channel = insert(:channel)
    insert(:channel_member, channel_id: channel.id, user_id: user.id, admin: false)

    query = """
    mutation {
      members: createMembers(
        channelId: "#{channel.id}",
        memberIds: [1,2]
      ) {
        #{document_for(:member)}
      }
    }
    """

    assert_errors_equals(query, "unauthorized", context: %{current_user: user})
  end
end
