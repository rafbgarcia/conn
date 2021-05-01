defmodule Connect.Unit.ChannelMemberTest do
  use ExUnit.Case

  @member Db.ChannelMember.new(%{}).changes

  test "sets admin to false" do
    assert @member.admin == false
  end

  test "sets broadcaster to false" do
    assert @member.broadcaster == false
  end
end
