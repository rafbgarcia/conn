defmodule Connect.Unit.MessageTest do
  use ExUnit.Case

  alias Db.{Message}

  @msg Message.new(%{}).changes

  test "sets id" do
    assert is_integer(@msg.id)
  end

  test "sets bucket" do
    assert is_integer(@msg.bucket)
  end

  test "sets created_at" do
    assert is_struct(@msg.created_at)
  end
end
