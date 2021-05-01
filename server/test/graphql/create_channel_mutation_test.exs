defmodule Connect.Graphql.CreateChannelMutationTest do
  use Connect.IntegrationCase, truncate_tables: [:channels, :channel_members]
  use ConnectWeb.AbsintheCase

  def scenario, do: "Create a new channel"

  def query(server_id, name, type) do
    """
    mutation {
      channel: createChannel(serverId: "#{server_id}", name: "#{name}", type: #{type}) {
        #{document_for(:channel)}
      }
    }
    """
  end

  test "creates a private channel" do
    user = insert(:user)
    server_id = "#{Db.Snowflake.new()}"
    type = Db.Channel.types().private
    uid = user.id

    assert_response_matches(query(server_id, "Rebels", type), context: %{current_user: user}) do
      %{
        "channel" => %{
          "__typename" => "Channel",
          "id" => id,
          "name" => "Rebels",
          "ownerId" => ^uid,
          "serverId" => ^server_id,
          "type" => ^type
        }
      }
    end

    assert is_binary(id)
    assert Db.Repo.count(Db.Channel) == 1
  end

  test "adds the owner as a member" do
    user = insert(:user)
    data = run(query(1, "Rebels", 0), context: %{current_user: user})

    assert Db.Repo.count(Db.ChannelMember) == 1

    member = Db.Repo.one(Db.ChannelMember)
    assert member.user_id == user.id
    assert "#{member.channel_id}" == data["channel"]["id"]
  end
end
