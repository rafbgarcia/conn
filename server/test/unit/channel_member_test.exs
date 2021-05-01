defmodule Connect.Unit.ChannelMemberTest do
  use ExUnit.Case

  test "sets admin to false" do
    member = Db.ChannelMember.new(%{}).changes
    assert member.admin == false
  end
end
