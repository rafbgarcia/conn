defmodule Connect.Unit.ThreadMessageTest do
  use ExUnit.Case

  @msg Db.ThreadMessage.new(%{}).changes

  test "sets id" do
    assert is_integer(@msg.id)
  end

  test "sets created_at" do
    assert is_struct(@msg.created_at)
  end

  test "edit" do
    message = Db.ThreadMessage.new(%{content: "Hello"})

    edited = Db.ThreadMessage.edit(message, %{content: "Hello world"}).changes
    assert edited.content == "Hello world"
    assert is_struct(edited.edited_at)
  end
end
