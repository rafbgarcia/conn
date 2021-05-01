defmodule Connect.Unit.ServerTest do
  use ExUnit.Case

  @server Db.Server.new(%{}).changes

  test "sets id" do
    assert is_integer(@server.id)
  end
end
