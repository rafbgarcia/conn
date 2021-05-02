defmodule Connect.Unit.ChannelMemberTest do
  use ExUnit.Case

  @member Db.ChannelMember.new(%{
            channel_id: Db.Snowflake.new(),
            user_id: 1,
            admin: true,
            broadcaster: true
          }).changes

  test "sets attrs" do
    assert @member.user_id == 1
    assert is_integer(@member.channel_id)
    assert @member.admin
    assert @member.broadcaster
  end

  @member Db.ChannelMember.new(%{}).changes
  test "sets admin to false", do: assert(@member.admin == false)
  test "sets broadcaster to false", do: assert(@member.broadcaster == false)
end
