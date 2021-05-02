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

  test "users can create a new private channel" do
    user = insert(:user)
    server_id = "#{Db.Snowflake.new()}"
    type = Db.Channel.types().private
    uid = user.id

    assert type == "PRIVATE"

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

    channel =
      Db.Repo.get(Db.Channel, server_id: String.to_integer(server_id), id: String.to_integer(id))

    assert channel.type == type
  end

  # test "the channel creator is added as an admin member" do
  #   user = insert(:user)
  #   data = run(query(1, "Rebels", "PRIVATE"), context: %{current_user: user})

  #   assert Db.Repo.count(Db.ChannelMember) == 1

  #   member = Db.Repo.one(Db.ChannelMember)
  #   assert member.user_id == user.id
  #   assert member.admin
  #   assert "#{member.channel_id}" == data["channel"]["id"]
  # end
end
